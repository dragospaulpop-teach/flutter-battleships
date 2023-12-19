import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter_battleships/components/image_capturer.dart';
import 'package:flutter_battleships/components/naval_text_field.dart';
import 'package:flutter_battleships/state/auth_notifier.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.toggleDarkMode});
  final VoidCallback? toggleDarkMode;

  void editDisplayName(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final auth = Provider.of<AuthNotifier>(context, listen: false);
          final TextEditingController controller =
              TextEditingController(text: auth.user?.displayName);

          File? imageFile;

          Future<void> captureImage(String source, setState) async {
            File? image = await ImageCapturer.captureImage(source);
            setState(() {
              imageFile = image;
            });
          }

          void saveInfo() {
            auth.updateDisplayName(controller.text);
            if (imageFile != null) {
              auth.uploadAvatar(imageFile!);
            }
            Navigator.of(context).pop();
          }

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit your username'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NavalTextField(
                    controller: controller,
                    label: 'Username',
                    hint: 'Enter your username',
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      await captureImage("camera", setState);
                    },
                    child: const Text("open the camera"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextButton(
                    onPressed: () async {
                      await captureImage("gallery", setState);
                    },
                    child: const Text("open the gallery"),
                  ),
                  if (imageFile != null)
                    Image.file(
                      imageFile!,
                      width: 100,
                      height: 100,
                    ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () => saveInfo(),
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthNotifier>(builder: (context, auth, child) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (auth.user != null)
              UserAccountsDrawerHeader(
                onDetailsPressed: () => editDisplayName(context),
                accountName: Text(
                  auth.user?.displayName ?? '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  auth.user!.email!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: auth.user?.photoURL != null
                      ? NetworkImage(auth.user!.photoURL!)
                      : null,
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  child: Text(auth.user?.displayName != null &&
                          auth.user!.displayName!.isNotEmpty
                      ? auth.user!.displayName!.substring(0, 1)
                      : '-'),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/hero_image.png',
                    ),
                    fit: BoxFit.fill,
                    opacity: 0.35,
                  ),
                ),
              )
            else
              SizedBox(
                // display image
                height: 200,
                child: Image.asset(
                  'assets/images/hero_image.png',
                  fit: BoxFit.fill,
                ),
              ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (auth.user != null)
                    ListTile(
                      leading: const Icon(Icons.local_fire_department),
                      title: const Text("Active Challenges"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/challenges');
                      },
                    ),
                  if (auth.user != null)
                    ListTile(
                      leading: const Icon(Icons.military_tech),
                      title: const Text("Battle History"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/history');
                      },
                    ),
                  if (auth.user != null)
                    ListTile(
                      leading: const Icon(Icons.radar),
                      title: const Text("Challenge a friend"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/users');
                      },
                    ),
                  if (auth.user != null)
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text("Notifications"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/notifications');
                      },
                    ),
                  // if (auth.user != null)
                  //   ListTile(
                  //     leading: const Icon(Icons.gamepad),
                  //     title: const Text("Battle screen"),
                  //     onTap: () {
                  //       Navigator.pop(context);
                  //       Navigator.pushNamed(context, '/battlescreen');
                  //     },
                  //   ),
                  ListTile(
                    leading: const Icon(Icons.info_sharp),
                    title: const Text("About"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 0.5,
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text("Toggle Dark Mode"),
              onTap: () {
                Navigator.pop(context);
                toggleDarkMode?.call();
              },
            ),
            if (auth.user != null)
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {
                  Navigator.pop(context);
                  auth.signOut();
                },
              ),
          ],
        );
      }),
    );
  }
}
