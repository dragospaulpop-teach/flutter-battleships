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
const {getFirestore} = require("firebase-admin/firestore");

// fcm access
const {getMessaging} = require("firebase-admin/messaging");
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

initializeApp();
const db = getFirestore();
const messaging = getMessaging();

exports.sendNotification = onDocumentWritten(
    "challenges/{challengeId}",
    async (event) => {
      // Check if the document has been deleted
      if (!event.data.after.exists) {
        logger.info("challenge has been deleted; no notification sent");
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
          return;
        }

        // construct fcm message paylod
        const payload = {
          notification: {
            title: "New battle challenge!",
            body: newChallenge.issuerUsername + " has challenged you!",
          },
          token: receiverToken,
        };

        logger.info("payload: " + JSON.stringify(payload));

        // send the notification
        await messaging.send(payload);
      } catch (error) {
        logger.error(error);
      }
    });
