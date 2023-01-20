// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ffi';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weatherinfo/models/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription? internetConnection;
  bool isOffline = false;

  askPermission() async {
    print("Asking Permision");
    PermissionStatus status = await Permission.location.request();
    if (await Permission.location.isDenied) {
      return openAppSettings();
    }

    // if (status.isDenied == true) {
    //   Permission.location.request();
    // } else {
    //
    // }
  }

  connectionChecker() {
    internetConnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isOffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isOffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isOffline = false;
        });
      }
    });
  }

  void checkPermissionStatus() async {
    var status = await Permission.locationWhenInUse.status;
    if (status != PermissionStatus.granted) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            "Location Permission Denied",
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600, color: Colors.red),
          ),
          content: Text("Allow location permission to use the app.",
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w400,
              )),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (await Permission.location.isDenied) {
                  final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        "Permission not granted!!",
                        style: GoogleFonts.outfit(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      duration: Duration(seconds: 2));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  final snackBar = SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        "Permission granted!!",
                        style: GoogleFonts.outfit(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      duration: Duration(seconds: 2));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                checkPermissionStatus();
                locData();
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.all(14),
                child: Text(
                  "Close",
                  style: GoogleFonts.outfit(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                askPermission();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.all(14),
                child: Text(
                  "Allow",
                  style: GoogleFonts.outfit(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      );
    } else {}
  }

  WeatherModel weatherModel = WeatherModel();
  int? temperature;
  String? weatherCondition;
  String? country;
  int? humidity;
  String? city;
  String? description;
  double? windspeed;
  int? sealvl;
  String cdate1 = DateFormat("EEEEE, MMMM, dd").format(DateTime.now());

  locData() async {
    var weatherData = await weatherModel.getLocationWeather();

    setState(() {
      weatherCondition = weatherData['weather'][0]['main'];
      double temp = weatherData['main']['temp'];
      sealvl = weatherData['main']['sea_level'];
      temperature = temp.toInt();
      country = weatherData['sys']['country'];
      humidity = weatherData['main']['humidity'];
      city = weatherData['name'];
      description = weatherData['weather'][0]['description'];
      windspeed = weatherData['wind']['speed'];
      print(weatherData);
      print(windspeed);
    });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    locData();
    askPermission();
    connectionChecker();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    locData();
    askPermission();
    connectionChecker();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    connectionChecker();
    // TODO: implement initState
    checkPermissionStatus();
    super.initState();
    askPermission();
    locData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    internetConnection!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        header: WaterDropMaterialHeader(
          color: Colors.green,
          backgroundColor: Colors.white,
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 600,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        stops: [0.6, 0.1, 1],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.black,
                          Colors.transparent
                        ],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset(
                      'assets/clouds.jpg',
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 550,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            color: Colors.transparent,
                            height: h,
                            width: w,
                            // decoration: BoxDecoration(
                            //
                            //   image: DecorationImage(
                            //       image: AssetImage("assets/clouds.jpg"),
                            //       fit: BoxFit.cover),
                            // ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 90),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    '$city',
                                    style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 40,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    cdate1,
                                    style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 25,
                                        color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 40, bottom: 40),
                                    child: Text.rich(TextSpan(
                                        text: ' $temperature',
                                        style: GoogleFonts.comfortaa(
                                            fontSize: 90,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "\u00B0",
                                              style: GoogleFonts.comfortaa(
                                                fontSize: 90,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              )),
                                        ])),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "$weatherCondition",
                                            style: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 45,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "$description",
                                        style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),

                            //  Stack(
                            //   children: [
                            //   Column(
                            //     mainAxisAlignment: MainAxisAlignment.end,
                            //     children: [
                            //       BlurryContainer(
                            //         blur: 3,
                            //         child: Container(
                            //           height: 140,
                            //           child: Text("")),

                            //       ),
                            //     ],
                            //   ),
                            // ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlurryContainer(
                          blur: 7,
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Humidity",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  "$humidity",
                                  style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BlurryContainer(
                          blur: 7,
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Wind Speed",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  "$windspeed",
                                  style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BlurryContainer(
                          blur: 7,
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Sea Level",
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  "$sealvl",
                                  style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
