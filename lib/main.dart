import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gamezone/AuthenticationPages/email_verification.dart';
import 'package:gamezone/AuthenticationPages/login_view.dart';
import 'package:gamezone/AuthenticationPages/register_view.dart';
import 'package:gamezone/IconPages/sell_main.dart';
import 'package:gamezone/IconPages/selling.dart';
import 'package:gamezone/IconPages/wallet.dart';
import 'package:gamezone/IconPages/wallet_profile.dart';

import 'package:gamezone/ProfilePages/add_account.dart';
import 'package:gamezone/ProfilePages/contact_us.dart';
import 'package:gamezone/ProfilePages/edit_profile.dart';
import 'package:gamezone/ProfilePages/my_orders.dart';
import 'package:gamezone/ProfilePages/privacy.dart';
import 'package:gamezone/ProfilePages/sell_product.dart';
import 'package:gamezone/ProfilePages/user_profile.dart';
import 'package:gamezone/Tabs/tab_page.dart';
import 'package:gamezone/constants/routes.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        loginScreenRoute: (context) => const LoginScreen(),
        registerScreenRoute: (context) => const RegisterScreen(),
        verifyEmailScreenRoute: (context) => const EmailVerificationScreen(),
        mainPageScreenRoute: (context) => const TabPage(),
        editProfilePageScreenRoute: (context) => const EditProfile(),
        contactPageScreenRoute: (context) => const ContactPage(),
        orderPageScreenRoute: (context) => const MyOrderPage(),
        onSellPageScreenRoute: (context) => const OnSellPage(),
        privacyPageScreenRoute: (context) => const PrivacyPage(),
        accountPageScreenRoute: (context) => const AddAccountPage(),
        userProfilePageScreenRoute: (context) => const UserProfilePage(),
        sellMainPageScreenRoute: (context) => const SellMain(),
        walletProfilePageScreenRoute: (context) => const WalletProfile(),
        sellingPageScreenRoute: (context) => const SellingPage(),
        gameWalletPageScreenRoute: (context) => const GameWallet(),
      },
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const TabPage();
              } else {
                return const LoginScreen();
              }
            } else {
              return const RegisterScreen();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
