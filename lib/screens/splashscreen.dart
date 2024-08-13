import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytdown1/screens/homescreen.dart';

import '../main.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  static const double sTime = 3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // time for splash screen

    if (sTime ==
        Timer.periodic(const Duration(seconds: 3), (_) {

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => homePage()));

        })) ;

    /*Future.delayed(Duration(seconds: 2),
    () { SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color(0XFF76ABAE)));;,Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => homePage()));}

  }*/
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Let Go 🚀",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0xffFFDFD6)),
          ),
        ),
        backgroundColor: Color(0XFFB692C2),
      ),
      body: Stack(
        children: [

          Positioned(
            child: Image.asset('images/mytdownlogo.png'),
            top: mq.height * .20,
            width: mq.width * .35,
            right: mq.width * .33,
          ),
          Positioned(
            bottom: mq.height * .20,
            width: mq.width,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color:Color(0xff694F8E),),
                SizedBox(height: 100,),
                Text(
                  "Made With Hands 👋",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff694F8E)),
                ),

              // Add CircularProgressIndicator here
              ],
            ),
          ),


        ],
      ),
    );
  }
}
