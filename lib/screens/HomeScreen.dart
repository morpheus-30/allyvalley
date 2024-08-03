import 'dart:convert';

import 'package:all_bluetooth/all_bluetooth.dart';
import 'package:allyvalley/NetworkHelper.dart';
import 'package:allyvalley/colors.dart';
import 'package:allyvalley/constants.dart';
import 'package:allyvalley/screens/ChatScreen.dart';
import 'package:allyvalley/screens/StartScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:mac_address/mac_address.dart';
import 'package:permission_handler/permission_handler.dart';

class NearbyDevice {
  String name;
  double distance;
  NearbyDevice({required this.name, required this.distance});
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
  List<DeviceTile> nearbydevices = [];
  List nearbyUsers = [];
  bool loading = false;
}

class _HomeScreenState extends State<HomeScreen> {
  bool status = false;

  Future<List<QueryDocumentSnapshot>> checkBluetoothRemoteId(String remoteId) async {
    bool exists = false;
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .where("bluetooth", isEqualTo: remoteId.toLowerCase()).get();
    if (doc.docs.isNotEmpty) {
      print(doc.docs[0]['bluetooth']);
    }
    return doc.docs;
  }

  

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              child: Image(
                image: NetworkImage(
                  FirebaseAuth.instance.currentUser!.photoURL!,
                ),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.displayName!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Spotify',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Spotify',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: kfadedGreenBlue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              FontAwesomeIcons.bars,
              color: Colors.white,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();
              NetworkHelper networkHelper = NetworkHelper();
              await networkHelper.postData(NGROKsetStatusUrl, {
                'Content-Type': 'application/json'
              }, {
                'status': false,
                'email': FirebaseAuth.instance.currentUser!.email
              });
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => StartScreen()));
            },
            icon: Icon(Icons.logout),
          ),
          Switch(
            activeTrackColor: kdarkGreenBlue,
            inactiveTrackColor: kfadedGreenBlue,
            value: status,
            onChanged: (value) async {
              setState(() {
                status = value;
              });
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .update({'status': status ? 'online' : 'offline'});
            },
          ),
        ],
        title: Text('Home'),
      ),
      body: status
          ? (widget.loading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kgreenBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () async {
                            // setState(() {
                            //   widget.loading = true;
                            // });
                            // Position position = await _determinePosition();
                            // print(position);
                            // NetworkHelper networkHelper = NetworkHelper();
                            // dynamic data = {
                            //   'email':
                            //       FirebaseAuth.instance.currentUser!.email,
                            //   'lat': position.latitude,
                            //   'lon': position.longitude
                            // };
                            // print(data);
                            // dynamic response = await networkHelper.postData(
                            //     NGROKgetNearbyUsersUrl,
                            //     {'Content-Type': 'application/json'},
                            //     data);
                            // dynamic jsonData = jsonDecode(response);
                            // print(jsonData['users']);

                            // List<dynamic> nearbyUsers = jsonData['users'];
                            // print(nearbyUsers);
                            // widget.nearbydevices.clear();
                            // for (int i = 0; i < nearbyUsers.length; i++) {
                            //   //calculate distance between current user and nearby user
                            //   double distance = Geolocator.distanceBetween(
                            //       position.latitude,
                            //       position.longitude,
                            //       nearbyUsers[i]['lat'],
                            //       nearbyUsers[i]['lon']);
                            //   setState(() {
                            //     widget.nearbydevices.add(DeviceTile(
                            //         name: nearbyUsers[i]["email"],
                            //         distance: distance));
                            //   });
                            // }
                            // print(widget.nearbydevices);
                            // location permission
                            // if (await FlutterBluePlus.isSupported == false) {
                            //   print("Bluetooth not supported by this device");
                            //   return;
                            // }


                            AllBluetooth allBluetooth = AllBluetooth();
                            // allBluetooth.stopDiscovery();
                            allBluetooth.startDiscovery();
                            // allBluetooth.streamBluetoothState.listen((event) {
                            //   print(event);
                            // });

                            allBluetooth.discoverDevices.listen((device) async {
                              print(device.address);
                              List<QueryDocumentSnapshot> users =  await checkBluetoothRemoteId(
                                  device.address);
                              if (users.isNotEmpty) {
                                if (!widget.nearbyUsers
                                    .contains(device.address)) {
                                  widget.nearbyUsers.add(device.address);
                                  widget.nearbydevices.add(DeviceTile(
                                    name: device.name,
                                    distance: device.address,
                                  ));
                                  setState(() {});
                                }
                              }
                            });
                            //4C:E0:DB:4D:02:43 Redmi note 11 ki
                          },
                          child: Text(
                            'Scan For Nearby Travellers',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Spotify',
                            ),
                          ),
                        ),
                      ),
                    ),
                    widget.nearbydevices.isEmpty
                        ? Center(
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: 10, left: 20, right: 10),
                              child: Text('No nearby travellers found :(',
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: kdarkGreenBlue,
                                    fontFamily: 'Spotify',
                                  )),
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 100,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: widget.nearbydevices.length,
                                  itemBuilder: (context, index) {
                                    return widget.nearbydevices[index];
                                  },
                                ),
                              ),
                            ],
                          ),
                  ],
                ))
          : Center(
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 10),
                child: Text(
                  'Turn on the switch to scan for nearby travellers',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: kdarkGreenBlue,
                    fontFamily: 'Spotify',
                  ),
                ),
              ),
            ),
    );
  }
}

class DeviceTile extends StatelessWidget {
  String name;
  String distance;
  DeviceTile({required this.name, required this.distance, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Card(
        child: ListTile(
          title: Text(name),
          subtitle: Text('Distance: $distance m'),
          trailing: IconButton(
            onPressed: () {
              AlertDialog alert = AlertDialog(
                title: Text('Proceed to text?'),
                content: Text('Do you want to text with this person?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    Name: name,
                                  )));
                    },
                    child: Text('Yes'),
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
            icon: Icon(Icons.message),
          ),
        ),
      ),
    );
  }
}
