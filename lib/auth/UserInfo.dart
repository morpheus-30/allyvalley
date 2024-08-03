import 'dart:convert';

import 'package:allyvalley/NetworkHelper.dart';
import 'package:allyvalley/colors.dart';
import 'package:allyvalley/constants.dart';
import 'package:allyvalley/screens/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserInfoScreen extends StatefulWidget {
  String userEmail;
  String userName;
  String bluetoothAddress = "";
  UserInfoScreen({required this.userEmail, required this.userName});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  List interests = [];
  String age = '';
  String gender = '';
  List languages = [];
  String profession = '';
  int phoneNumber = 0;
  String about = "";
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let us get to know you better!',
              style: TextStyle(fontFamily: 'Spotify', fontSize: 40),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Bluetooth Address',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontFamily: 'Spotify', fontSize: 25),
                ),
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('How to get your bluetooth address?'),
                            content: Text(
                                '1. Go to settings\n2. Click on About Phone\n3. Click on Status\n4. Click on Bluetooth Address\n5. Copy the address and paste it here'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ok'))
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  widget.bluetoothAddress = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Bluetooth Address',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'What are your interests?',
              textAlign: TextAlign.left,
              style: TextStyle(fontFamily: 'Spotify', fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownMenu(
              width: 300,
              onSelected: (value) {
                String textToBeAdded = value ?? "";

                if (value == "Other") {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Please Specify"),
                          content: TextField(
                            onChanged: (valu) {
                              textToBeAdded = valu;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Other",
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                textToBeAdded = value ?? "";
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  if (interests.contains(textToBeAdded))
                                    interests.remove(textToBeAdded);
                                  interests.add(textToBeAdded);
                                });
                                Navigator.pop(context);
                              },
                              child: const Text("Submit"),
                            ),
                          ],
                        );
                      });
                } else {
                  setState(() {
                    if (interests.contains(textToBeAdded))
                      interests.remove(textToBeAdded);
                    interests.add(textToBeAdded);
                  });
                }
              },
              hintText: "Interests",
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                  value: "Sports",
                  label: "Sports",
                ),
                DropdownMenuEntry(value: "Music", label: "Music"),
                DropdownMenuEntry(value: "Art", label: "Art"),
                DropdownMenuEntry(value: "Gaming", label: "Gaming"),
                DropdownMenuEntry(value: "Reading", label: "Reading"),
                DropdownMenuEntry(value: "Cooking", label: "Cooking"),
                DropdownMenuEntry(
                    value: "Other", label: "Other (Please Specify)"),
              ],
            ),
            Wrap(
              children: [
                for (var interest in interests)
                  if (interest != "Other")
                    Chip(
                      label: Text(interest),
                      onDeleted: () {
                        setState(() {
                          interests.remove(interest);
                        });
                      },
                    )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text("Tell us something about yourself",
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: 'Spotify', fontSize: 25)),
            SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  about = value;
                });
              },
              maxLength: 200,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Bio (up to 200 characters)",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("What's your age?",
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: 'Spotify', fontSize: 25)),
            SizedBox(
              height: 20,
            ),
            DropdownMenu(
              width: 300,
              onSelected: (value) {
                setState(() {
                  age = value ?? "";
                });
              },
              hintText: "Age",
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: "Under 18", label: "Under 18"),
                DropdownMenuEntry(value: "18-24", label: "18-24"),
                DropdownMenuEntry(value: "25-34", label: "25-34"),
                DropdownMenuEntry(value: "35-44", label: "35-44"),
                DropdownMenuEntry(value: "45-54", label: "45-54"),
                DropdownMenuEntry(value: "55-64", label: "55-64"),
                DropdownMenuEntry(value: "65+", label: "65+"),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text("What's your gender?",
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: 'Spotify', fontSize: 25)),
            SizedBox(
              height: 20,
            ),
            DropdownMenu(
              width: 300,
              onSelected: (value) {
                setState(() {
                  gender = value ?? "";
                });
              },
              hintText: "Gender",
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: "Female", label: "Female"),
                DropdownMenuEntry(value: "Male", label: "Male"),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text("What languages do you speak?",
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: 'Spotify', fontSize: 25)),
            SizedBox(
              height: 20,
            ),
            DropdownMenu(
              width: 300,
              onSelected: (value) {
                String textToBeAdded = value ?? "";

                if (value == "Other") {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Please Specify"),
                          content: TextField(
                            onChanged: (valu) {
                              textToBeAdded = valu;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Other",
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                textToBeAdded = value ?? "";
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  if (languages.contains(textToBeAdded))
                                    languages.remove(textToBeAdded);
                                  languages.add(textToBeAdded);
                                });
                                Navigator.pop(context);
                              },
                              child: const Text("Submit"),
                            ),
                          ],
                        );
                      });
                } else {
                  setState(() {
                    if (languages.contains(textToBeAdded))
                      languages.remove(textToBeAdded);
                    languages.add(textToBeAdded);
                  });
                }
              },
              hintText: "Languages",
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: "English", label: "English"),
                DropdownMenuEntry(value: "Hindi", label: "Hindi"),
                DropdownMenuEntry(value: "Spanish", label: "Spanish"),
                DropdownMenuEntry(value: "French", label: "French"),
                DropdownMenuEntry(value: "German", label: "German"),
                DropdownMenuEntry(
                    value: "Other", label: "Other (Please Specify)"),
              ],
            ),
            Wrap(
              children: [
                for (var language in languages)
                  if (language != "Other")
                    Chip(
                      label: Text(language),
                      onDeleted: () {
                        setState(() {
                          languages.remove(language);
                        });
                      },
                    )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text("What's your profession?",
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: 'Spotify', fontSize: 25)),
            SizedBox(
              height: 20,
            ),
            DropdownMenu(
              width: 300,
              onSelected: (value) {
                setState(() {
                  profession = value ?? "";
                });
              },
              hintText: "Profession",
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: "Student", label: "Student"),
                DropdownMenuEntry(value: "Working", label: "Working"),
                DropdownMenuEntry(value: "Unemployed", label: "Unemployed"),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text("What's your phone number?",
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: 'Spotify', fontSize: 25)),
            SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 10,
              onChanged: (value) {
                setState(() {
                  phoneNumber = int.parse(value);
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone Number',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kgreenBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: () {
                  if (interests.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Please select atleast one interest'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ok'))
                            ],
                          );
                        });
                  } else if (languages.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Please select atleast one language'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ok'))
                            ],
                          );
                        });
                  } else if (profession.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Please select your profession'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ok'))
                            ],
                          );
                        });
                  } else if (phoneNumber == 0) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Please enter your phone number'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ok'))
                            ],
                          );
                        });
                  } else if (phoneNumber < 1000000000 ||
                      phoneNumber > 9999999999) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Please enter a valid phone number'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ok'))
                            ],
                          );
                        });
                  } else if (gender.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Please select your gender'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                  }else if(widget.bluetoothAddress==""){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Please enter your bluetooth address'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                  } 
                  
                  else {
                    Map<String, dynamic> data = {
                      "email": widget.userEmail,
                      "name": widget.userName,
                      "age": age,
                      "gender": gender,
                      "profession": profession,
                      "language": languages,
                      "interests": interests,
                      "phone": "${phoneNumber}",
                      "about": about,
                      "status": "offline",
                      "bluetooth": widget.bluetoothAddress,
                    };

                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.userEmail)
                        .set(data);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Spotify',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
