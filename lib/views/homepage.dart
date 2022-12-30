import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                height: 500,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    image: DecorationImage(
                        image: AssetImage("assets/summer.png"),
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
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sunny",
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
                                    "Calicut, Kerala",
                                    style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 25,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Text.rich(TextSpan(
                                  text: "35",
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
                                          color: Colors.white,
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
            )
          ],
        ),
      ),
    );
  }
}
