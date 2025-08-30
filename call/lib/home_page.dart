import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController inviteeUserIDCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 20,
              right: 10,
              child: logoutButton(),
            ),
            Positioned(
              top: 50,
              left: 10,
              child: Text('Your User ID: ${currentUser.id}'),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter the ID of the user you want to call',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: inviteeUserIDCtrl,
                      decoration: const InputDecoration(
                        labelText: "Target User ID",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (inviteeUserIDCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter a user ID to call.")),
                          );
                          return;
                        }

                        if (ZegoUIKitPrebuiltCallController().minimize.isMinimizing) {
                          return;
                        }

                        startCall(inviteeUserIDCtrl.text.trim());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: const Text('Start Video Call', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startCall(String inviteeUserID) {
    // Combine the user IDs to create a unique and consistent callID.
    final List<String> userIDs = [currentUser.id, inviteeUserID]..sort();
    final String callID = userIDs.join('_');

    Navigator.pushNamed(
      context,
      PageRouteNames.call,
      arguments: <String, String>{
        PageParam.call_id: callID,
      },
    );
  }

  Widget logoutButton() {
    return Ink(
      width: 35,
      height: 35,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent,
      ),
      child: IconButton(
        icon: const Icon(Icons.exit_to_app_sharp),
        iconSize: 20,
        color: Colors.white,
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.remove(cacheUserIDKey);
          Navigator.pushNamedAndRemoveUntil(
            context,
            PageRouteNames.login,
                (route) => false,
          );
        },
      ),
    );
  }
}