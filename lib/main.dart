import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_quran/model/controller_response.dart';
import 'package:my_quran/model/response_doa.dart';
import 'package:my_quran/pages/baca_surat.dart';
import 'package:my_quran/pages/doa.dart';
import 'package:my_quran/pages/home.dart';
import 'package:my_quran/pages/intro.dart';
import 'package:my_quran/pages/jadwal_sholat.dart';
import 'package:my_quran/pages/page_quiz.dart';
import 'package:my_quran/pages/tajwid.dart';
import 'package:my_quran/pages/uji.dart';
import 'package:my_quran/utils/colors.dart';
import 'package:provider/provider.dart';

import 'httpovveride.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return ChangeNotifierProvider<ControllerAPI>(
      create: (context) => ControllerAPI(),
      child: MaterialApp(
        title: 'Islam App',
        theme: ThemeData(
          primarySwatch: MaterialColor(
            ColorApp.colorPurpler.value,
            <int, Color>{
              50: Color.fromRGBO(149, 67, 255, 0.1),
              100: Color.fromRGBO(149, 67, 255, 0.2),
              200: Color.fromRGBO(149, 67, 255, 0.3),
              300: Color.fromRGBO(149, 67, 255, 0.4),
              400: Color.fromRGBO(149, 67, 255, 0.5),
              500: Color.fromRGBO(149, 67, 255, 0.6),
              600: Color.fromRGBO(149, 67, 255, 0.7),
              700: Color.fromRGBO(149, 67, 255, 0.8),
              800: Color.fromRGBO(149, 67, 255, 0.9),
              900: Color.fromRGBO(149, 67, 255, 1.0),
            },
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: Intro.routingName.toString(),
        routes: {
          Intro.routingName.toString(): (context) => Intro(),
          Home.routeName.toString(): (context) => Home(),
          MyWidget.routeName.toString(): (context) => MyWidget(),
          PageDoa.routeName.toString(): (context) => PageDoa(),
          BacaSurat.routeName.toString(): (context) => BacaSurat(),
          JadwalSholat.routeName.toString(): (context) => JadwalSholat(),
          PageTajwid.routeName.toString(): (context) => PageTajwid(),
          PageQuiz.routeName.toString(): (context) => PageQuiz()
        },
      ),
    );
  }
}
