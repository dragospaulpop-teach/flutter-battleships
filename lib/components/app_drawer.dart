import "package:flutter/material.dart";
import 'package:flutter_battleships/components/naval_text_field.dart';
import 'package:flutter_battleships/state/auth_notifier.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.toggleDarkMode});
  final VoidCallback? toggleDarkMode;

  void editDisplayName(BuildContext context) {
    final _auth = Provider.of<AuthNotifier>(context, listen: false);
    final TextEditingController controller =
        TextEditingController(text: _auth.user?.displayName);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit your username'),
          content: NavalTextField(
              controller: controller,
              label: 'Username',
              hint: 'Enter your username',
              obscureText: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              }),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _auth.updateDisplayName(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
