import 'package:allyvalley/auth/SignInScreen.dart';
import 'package:allyvalley/auth/UserInfo.dart';
import 'package:allyvalley/colors.dart';
import 'package:allyvalley/screens/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return Scaffold(
              body: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 300,
                          height: 300,
                        ),
                        Text(
                          'AllyValley',
                          style: TextStyle(
                            fontSize: 60,
                            color: kdarkGreenBlue,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Spotify',
                            letterSpacing: -3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text('Get Started',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Spotify',
                              )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kgreenBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen()));
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            bool exists = true;
            // FirebaseFirestore.instance
            //     .collection('users')
            //     .doc(snapshot.data.email)
            //     .get()
            //     .then((DocumentSnapshot documentSnapshot) {
            //   if (documentSnapshot.exists) {
            //     exists = true;
            //   }
            // });
            return exists ? HomeScreen() : UserInfoScreen(
              userEmail: snapshot.data.email,
              userName: snapshot.data.displayName,

            );
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
