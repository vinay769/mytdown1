import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytdown1/screens/homescreen.dart';
import 'package:mytdown1/screens/splashscreen.dart';


late Size mq;
void main(){
  runApp(const mytdown());
}
class mytdown extends StatefulWidget {
  const mytdown({super.key});

  @override
  State<mytdown> createState() => _mytdownState();
}

class _mytdownState extends State<mytdown> {

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle(systemNavigationBarColor: Colors.lightBlue);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splashScreen(),
    );
  }
}