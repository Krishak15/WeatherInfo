import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherinfo/models/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel weatherModel = WeatherModel();
  int? temperature;
  String? weatherCondition;
  String? country;
  int? humidity;
  String? city;
  String? description;

  locData() async {
    var weatherData = await weatherModel.getLocationWeather();
    setState(() {
      weatherCondition = weatherData['weather'][0]['main'];
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      country = weatherData['sys']['country'];
      humidity = weatherData['main']['humidity'];
      city = weatherData['name'];
      description = weatherData['weather'][0]['description'];
      print(weatherData);
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    locData();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 450,
                width: w,
                decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    image: DecorationImage(
                        image: AssetImage("assets/clouds.jpg"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(30)),
                child: Stack(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlurryContainer(
                        blur: 3,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(31),
                            bottomRight: Radius.circular(31)),
                        child: Container(
                          height: 140,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "$weatherCondition",
                                    style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 40,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$city',
                                    style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 25,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '$country',
                                    style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 25,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Text.rich(TextSpan(
                                  text: '$temperature',
                                  style: GoogleFonts.alata(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: " \u2103",
                                        style: GoogleFonts.alata(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green.shade100,
                                        )),
                                  ])),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 300,
              width: 350,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white54),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Humidity $humidity",
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w200,
                        fontSize: 40,
                        color: Colors.green.shade700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "$description",
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w400,
                        fontSize: 40,
                        color: Color.fromARGB(255, 0, 147, 183)),
                  ),
                  //  SizedBox(
                  //   height: 15,
                  // ),
                  // Text(
                  //   "$description",
                  //   style: GoogleFonts.outfit(
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 40,
                  //       color: Color.fromARGB(255, 0, 147, 183)),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
