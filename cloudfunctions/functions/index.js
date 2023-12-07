/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const logger = require("firebase-functions/logger");

// The Firebase Admin SDK to access Firestore.
const {initializeApp} = require("firebase-admin/app");

// events
const {onDocumentWritten} = require("firebase-functions/v2/firestore");

// firestore access
const {getFirestore, FieldValue} = require("firebase-admin/firestore");

// fcm access
const {getMessaging} = require("firebase-admin/messaging");
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

initializeApp();
const db = getFirestore();
const messaging = getMessaging();

exports.sendNotification = onDocumentWritten(
    "challenges/{userId}/received_challenges/{challengeId}",
    async (event) => {
      // Check if the document has been deleted
      if (!event.data.after.exists) {
        logger.info("challenge has been deleted; no notification sent");

        const oldData = event.data.before.data();
        const issuerUsername = oldData.issuerUsername;
        const receiverId = oldData.targetId;
        const notificationsRef = db
            .collection("notifications")
            .doc(receiverId)
            .collection("messages");
        const notification = {
          title: "Challenged withdrawn",
          body: `${issuerUsername} withdrew their challenge`,
          timestamp: FieldValue.serverTimestamp(),
        };
        await notificationsRef.add(notification);

        logger.info("notification saved: " + JSON.stringify(notification));
        return null;
      }

      const newChallenge = event.data.after.data();
      logger.info("challenge has been issued; sending notification");
      // challenge format
      // isAccepted: boolean
      // issuerId: string
      // issuerUsername: string
      // targetId: string
      // targetUsername: string
      // timestamp: timestamp
      try {
        // get notification token for receiver
        const receiverId = newChallenge.targetId;
        const receiverRef = db.collection("users").doc(receiverId);
        const receiverSnapshot = await receiverRef.get();
        const receiver = receiverSnapshot.data();
        const receiverToken = receiver.token;
        const receiverUsername = receiver.username;

        if (receiverToken === null) {
          logger.info(`receiver ${receiverUsername} has no token`);
        } else {
          // construct fcm message paylod
          const payload = {
            notification: {
              title: "New battle challenge!",
              body: newChallenge.issuerUsername + " has challenged you!",
            },
            token: receiverToken,
          };

          logger.info("notification payload: " + JSON.stringify(payload));

          // send the notification
          await messaging.send(payload);
        }

        // save notification message
        // into the notifications collection for the receiver

        const notificationsRef = db
            .collection("notifications")
            .doc(receiverId)
            .collection("messages");
        const isOldChallenge = event.data.before.exists;
        const notification = {
          title: isOldChallenge ?
            "Challenged updated":
            "New battle challenge!",
          body: `${newChallenge.issuerUsername} has challenged you${
            isOldChallenge ? " ...again!" : "!"
          }`,
          timestamp: FieldValue.serverTimestamp(),
          isSeen: false,
        };

        await notificationsRef.add(notification);
        logger.info("notification saved: " + JSON.stringify(notification));
      } catch (error) {
        logger.error(error);
      }
    });
