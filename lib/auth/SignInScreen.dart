import 'package:allyvalley/auth/UserInfo.dart';
import 'package:allyvalley/colors.dart';
import 'package:allyvalley/screens/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  Future<Map?> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
    print(userCredential.additionalUserInfo?.isNewUser);
    return {
      'newUser': userCredential.additionalUserInfo?.isNewUser,
      'displayName': userCredential.user?.displayName,
      'email': userCredential.user?.email,
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        bool? newUser;
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, bottom: 200),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 300,
                        child: Text('Oops you are not signed in!',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              color: kdarkGreenBlue,
                              fontFamily: 'Spotify',
                            )),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20,right: 20, bottom: 200),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kgreenBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Spotify',
                            ),
                          ),
                          onPressed: () async {
                            Map? user = await signInWithGoogle();
                            bool exists = false;
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(user?['email'])
                                .get()
                                .then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {
                                exists = true;
                              }
                            });
                            if (exists==false) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserInfoScreen(
                                    userEmail: user?['email'],
                                    userName: user?['displayName'],
                                  ),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return HomeScreen();
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
