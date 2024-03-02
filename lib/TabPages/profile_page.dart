import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/constants/routes.dart';
import 'package:gamezone/utilities/should_logout_dialog.dart';
import 'package:gamezone/widgets/profile_views.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: ClipOval(
            child: Image(
              image: AssetImage('assets/images/launcher.jpg'),
            ),
          ),
        ),
        title: const Column(
          children: [
            Text(
              "Hey Imran!!!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "Here we will add your bio",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            ProfileButtons(
              text: const Text("Edit Profile"),
              icon: const Icon(Icons.edit_note_rounded),
              func: () => {
                Navigator.of(context).pushNamed(
                  editProfilePageScreenRoute,
                ),
              },
            ),
            ProfileButtons(
              text: const Text("My Orders"),
              icon: const Icon(Icons.playlist_add_check_circle_outlined),
              func: () => {
                Navigator.of(context).pushNamed(
                  orderPageScreenRoute,
                ),
              },
            ),
            ProfileButtons(
              text: const Text("Subscription"),
              icon: const Icon(Icons.subscriptions_rounded),
              func: () => {},
            ),
            ProfileButtons(
              text: const Text("On Sell"),
              icon: const Icon(Icons.local_convenience_store_rounded),
              func: () => {
                Navigator.of(context).pushNamed(
                  onSellPageScreenRoute,
                ),
              },
            ),
            ProfileButtons(
              text: const Text("Bank Account"),
              icon: const Icon(Icons.account_balance_wallet_outlined),
              func: () => {},
            ),
            ProfileButtons(
              text: const Text("Contact Us"),
              icon: const Icon(Icons.call_outlined),
              func: () => {
                Navigator.of(context).pushNamed(
                  contactPageScreenRoute,
                ),
              },
            ),
            ProfileButtons(
              text: const Text("Privacy policy"),
              icon: const Icon(Icons.privacy_tip_outlined),
              func: () => {
                Navigator.of(context).pushNamed(
                  privacyPageScreenRoute,
                ),
              },
            ),
            ProfileButtons(
              text: const Text("Logout"),
              icon: const Icon(Icons.logout_rounded),
              func: () async {
                final navigator = Navigator.of(context);
                final shouldlogout = await showLogoutDialog(context);
                if (shouldlogout) {
                  FirebaseAuth.instance.signOut();
                  navigator.pushNamedAndRemoveUntil(
                    loginScreenRoute,
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
