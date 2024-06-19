import 'package:auhackathon/auth/auth_controller.dart';
import 'package:auhackathon/auth/login.dart';
import 'package:auhackathon/models/usermodel.dart';
import 'package:auhackathon/widgets/color_utils.dart';
import 'package:auhackathon/widgets/show_loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool isLoading = true;
  bool dark = false;
  UserModel? _user;
  loadUser() async {
    UserModel? user =
        await ref.read(authControllerProvider).getCurrentUserInfo();
    setState(() {
      _user = user;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 33, 124, 243),
              ),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                _user!.profileImageUrl != ""
                    ? CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(_user!.profileImageUrl),
                        radius: 58,
                      )
                    : const CircleAvatar(
                        radius: 58,
                        backgroundColor: Color.fromARGB(255, 236, 188, 249),
                        child: Icon(Icons.person_3, size: 50),
                      ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: const Color.fromARGB(255, 177, 236, 243),
                    child: ListTile(
                      title: Text(_user!.username),
                      subtitle: Text(_user!.email),
                      trailing: const Icon(Icons.edit),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: const Color.fromARGB(255, 177, 236, 243),
                    child: ListTile(
                      // contentPadding: const EdgeInsets.only(left: 30),
                      title: const Text('Theme'),
                      subtitle: const Text(
                        'Change Theme', //pachhi dynamic karvu jose
                        // style: TextStyle(
                        // color: Color.fromARGB(255, 177, 236, 243),
                        // ),
                      ),
                      trailing: Switch(
                        value: dark,
                        onChanged: (bool value) {
                          setState(() {
                            // globals.darkMode = value;
                            // provider.Provider.of<ThemeProvider>(context, listen: false)
                            //     .toggleTheme(value);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: CustomElevatedButton(
        onPressed: () {
          showLoadingDialog(context: context, message: 'Signing out..');
          FirebaseAuth.instance.signOut().then((value) {
            print("Signed Out");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
              (route) => false,
            );
          });
        },
        buttonWidth: 140,
        backgroundColor: hexStringToColor("5E61F4"),
        text: "Sign Out",
        icon: Icons.logout,
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final double? buttonWidth;
  final VoidCallback onPressed;
  final dynamic backgroundColor;
  final String text;
  final dynamic icon;
  const CustomElevatedButton(
      {Key? key,
      this.buttonWidth,
      required this.onPressed,
      this.backgroundColor,
      required this.text,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      width: buttonWidth ?? MediaQuery.of(context).size.width - 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
