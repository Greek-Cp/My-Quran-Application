import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_quran/component/button.dart';
import 'package:my_quran/component/text.dart';
import 'package:my_quran/model/controller_response.dart';
import 'package:my_quran/model/response_doa.dart';
import 'package:my_quran/model/responses_juz.dart';
import 'package:my_quran/pages/doa.dart';
import 'package:my_quran/pages/home.dart';
import 'package:my_quran/pages/item_list/list_juz.dart';
import 'package:my_quran/pages/page_quiz.dart';
import 'package:my_quran/utils/colors.dart';
import 'package:http/http.dart' as http;

class TajwidClass {
  String namaHukum;
  String isiPenjelasan;
  String contohHuruf;
  String urlBacaan;
  TajwidClass(
      {required this.namaHukum,
      required this.isiPenjelasan,
      required this.contohHuruf,
      required this.urlBacaan});
}

class PageTajwid extends StatefulWidget {
  static String? routeName = "/PageTajwid";

  @override
  State<PageTajwid> createState() => _PageTajwidState();
}

class _PageTajwidState extends State<PageTajwid> with TickerProviderStateMixin {
  List<String> listItem = ["Surat", "Doa", "Tajwid", "Quiz"];
  List<TajwidClass> tajwidList = [
    TajwidClass(
        namaHukum: "Izhar Halqi",
        isiPenjelasan:
            "Izhar secara bahasa artinya jelas dan izhar halqi adalah hukum bacaan apabila nun mati atau tanwin bertemu dgn salah satu huruf izhar halqi. Adapun halqi sendiri berarti tenggorokan, maka cara mengucapkannya harus jelas juga, huruf-huruf tersebut antara lain alif atau hamzah(ء), kha’ (خ), ‘ain (ع), ha’ (ح) , ghain (غ), dan ha’ (ﮬ). Contoh bacaannya adalah  : نَارٌ حَامِيَةٌ",
        contohHuruf: "ء،خ،ع،ح،غ،ه",
        urlBacaan: "https://sndup.net/qxhh/d"),
    TajwidClass(
        namaHukum: "Idgham Bigunnah",
        isiPenjelasan:
            "Idgham Bighunnah artinya melebur disertai dengungan atau yang berarti memasukkan salah satu huruf nun mati atau tanwin kedalam huruf sesudahnya dan lafal dari idgham bigunnah tersebut haruslah mendengung jika bertemu empat huruf berikut yakni : nun (ن), mim (م), wawu (و) dan ya’ (ي). Contoh bacaan idgham bigunnah : مُّمَدَّدَةٍ عَمَدٍ فِيْ",
        contohHuruf: "ي،ن،م،و",
        urlBacaan: "http://sndup.net/wz5g/d"),
    TajwidClass(
        namaHukum: "Idgham Billaghunnah",
        isiPenjelasan:
            "Idgham Bilaghunnah artinya melebur tanpa dengung atau memasukkan huruf nun mati atau tanwin kedalam huruf sesudahnya tanpa disertai suara mendengung. Hukum bacaan tersebut berlaku jika nun atau tanwin bertemu huruf berikut lam dan ra’. Contoh bacaannya :  لَمْ مَنْ Meskipun demikian hukum ini tidak berlaku apabila nun mati atau tanwin serta huruf tersebut tidak ada dalam satu kata contohnya  اَدُّنْيَا. Jika demikian nun atau tanwin tetap harus dibaca dengan jelas..",
        contohHuruf: "ل،ر",
        urlBacaan: "https://sndup.net/x8hd/d"),
    TajwidClass(
        namaHukum: "Iqlab",
        isiPenjelasan:
            "Iqlab adalah suatu hukum bacaan Al Quran yang terjadi apabila nun mati atau tanwin bertemu dengan satu huruf saja yaitu huruf  ba’ (ب). Di dalam bacaan ini, bacaan nun mati atau tanwin tidak lagi dibaca sebagai nun atau tanwin berubah menjadi bunyi huruf mim (م). Contoh bacaan iqlab : لَيُنۢبَذَنَّ",
        contohHuruf: "ب",
        urlBacaan: "https://sndup.net/s57f/d"),
    TajwidClass(
        namaHukum: "Ikhfa Hakiki",
        isiPenjelasan:
            "Ikhfa memiliki arti menyamarkan, hukum bacaan ini berlaku apabila huruf nun mati atau tanwin bertemu dgn huruf-huruf ikhfa yakni  ta’(ت), tha’ (ث), jim (ج), dal (د), dzal (ذ), zai (ز), sin (س), syin (ش), sod (ص), dhod (ض), , fa’ (ف), qof (ق), dan huruf  kaf (ك). Jika bertemu dengan huruf-huruf tersebut  maka nun mati atau tanwin tersebut  harus dibaca samar atau antara bacaan Izhar dan bacaan Idgham.  Contoh bacaan ikhfa haqiqi: نَقْعًا فَوَسَطْنَ",
        contohHuruf: "ت،ث،ج،د،ذ،ز،س،ش،ص،ض،ف،ق،ك",
        urlBacaan: "http://sndup.net/v9pw/d"),
  ];
  int selectedIndex = 2;
  StreamController<DateTime>? _streamControllera;
  final GlobalKey<State<PageTajwid>> _animationLimiterKeya = GlobalKey();
  late AnimationController _controller;

  late Animation<double> _FadeAnimationImageSuratS;
  late Animation<Offset> _PositionAnimationImagev;
  late Animation<Offset> _PositionKategoris;

  Timer? _timer;
  late Future<List<Doa>> listDoa;
  List<String> namaHukum = [
    "Izhar Halqi",
    "Idgham Bigunnah",
    "Idgham Billaghunnah",
    "Iqlab",
    "Ikhfa Hakiki"
  ];

  List<String> isiPenjelasan = [
    "Izhar secara bahasa artinya jelas dan izhar halqi adalah hukum bacaan apabila nun mati atau tanwin bertemu dgn salah satu huruf izhar halqi. Adapun halqi sendiri berarti tenggorokan, maka cara mengucapkannya harus jelas juga, huruf-huruf tersebut antara lain alif atau hamzah(ء), kha’ (خ), ‘ain (ع), ha’ (ح) , ghain (غ), dan ha’ (ﮬ). Contoh bacaannya adalah  : نَارٌ حَامِيَةٌ",
    "Idgham Bighunnah artinya melebur disertai dengungan atau yang berarti memasukkan salah satu huruf nun mati atau tanwin kedalam huruf sesudahnya dan lafal dari idgham bigunnah tersebut haruslah mendengung jika bertemu empat huruf berikut yakni : nun (ن), mim (م), wawu (و) dan ya’ (ي). Contoh bacaan idgham bigunnah : مُّمَدَّدَةٍ عَمَدٍ فِيْ",
    "Idgham Bilaghunnah artinya melebur tanpa dengung atau memasukkan huruf nun mati atau tanwin kedalam huruf sesudahnya tanpa disertai suara mendengung. Hukum bacaan tersebut berlaku jika nun atau tanwin bertemu huruf berikut lam dan ra’. Contoh bacaannya :  لَمْ مَنْ Meskipun demikian hukum ini tidak berlaku apabila nun mati atau tanwin serta huruf tersebut tidak ada dalam satu kata contohnya  اَدُّنْيَا. Jika demikian nun atau tanwin tetap harus dibaca dengan jelas..",
    "Iqlab adalah suatu hukum bacaan Al Quran yang terjadi apabila nun mati atau tanwin bertemu dengan satu huruf saja yaitu huruf  ba’ (ب). Di dalam bacaan ini, bacaan nun mati atau tanwin tidak lagi dibaca sebagai nun atau tanwin berubah menjadi bunyi huruf mim (م). Contoh bacaan iqlab : لَيُنۢبَذَنَّ",
    "Ikhfa memiliki arti menyamarkan, hukum bacaan ini berlaku apabila huruf nun mati atau tanwin bertemu dgn huruf-huruf ikhfa yakni  ta’(ت), tha’ (ث), jim (ج), dal (د), dzal (ذ), zai (ز), sin (س), syin (ش), sod (ص), dhod (ض), , fa’ (ف), qof (ق), dan huruf  kaf (ك). Jika bertemu dengan huruf-huruf tersebut  maka nun mati atau tanwin tersebut  harus dibaca samar atau antara bacaan Izhar dan bacaan Idgham.  Contoh bacaan ikhfa haqiqi: نَقْعًا فَوَسَطْنَ"
  ];

  List<String> contohHuruf = [
    "ء،خ،ع،ح،غ،ه",
    "ي،ن،م،و",
    "ل،ر",
    "ب",
    "ت،ث،ج،د،ذ،ز،س،ش،ص،ض،ف،ق،ك",
  ];
  void _animateToQuiz() {
    // Check the status of the AnimationController and start/stop the animation accordingly
    if (_controller.status == AnimationStatus.completed ||
        _controller.status == AnimationStatus.forward) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    Future.delayed(Duration(milliseconds: 2400), () {
      Navigator.of(context).popAndPushNamed(PageQuiz.routeName.toString());
    });
  }

  @override
  void initState() {
    listDoa = ControllerAPI.fetchDataDoa();
    super.initState();
    _streamControllera = StreamController<DateTime>();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _streamControllera?.add(DateTime.now());
    });
    _controller = AnimationController(
      duration: Duration(milliseconds: 2400),
      vsync: this,
    );

    _FadeAnimationImageSuratS =
        Tween<double>(begin: 0, end: 1).animate(_controller);
    _PositionAnimationImagev = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _PositionKategoris = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    playAnimation();
  }

  void _animate() {
    // Check the status of the AnimationController and start/stop the animation accordingly
    if (_controller.status == AnimationStatus.completed ||
        _controller.status == AnimationStatus.forward) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    Future.delayed(Duration(milliseconds: 2400), () {
      Navigator.of(context).popAndPushNamed(Home.routeName.toString());
    });
  }

  void _animateToDoa() {
    // Check the status of the AnimationController and start/stop the animation accordingly
    if (_controller.status == AnimationStatus.completed ||
        _controller.status == AnimationStatus.forward) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    Future.delayed(Duration(milliseconds: 2400), () {
      Navigator.of(context).popAndPushNamed(PageDoa.routeName.toString());
    });
  }

  @override
  void dispose() {
    _streamControllera?.close();
    _timer?.cancel();
    super.dispose();
  }

  void playAnimation() {
    _controller.forward();
  }

  void stopAnimation() {
    _controller.stop();
  }

  late AudioPlayer audioPlayer;
  double horizontalOffset = 50.0;
  int time = 375 + 100;
  @override
  Widget build(BuildContext context) {
    audioPlayer = AudioPlayer();
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 20),
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    left: -30,
                    top: 0,
                    child: FadeTransition(
                        opacity: _FadeAnimationImageSuratS,
                        child: SlideTransition(
                          position: _PositionKategoris,
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Positioned(
                                child: SizedBox(
                                    child: Image.asset(
                                  "assets/ic_tajwid.png",
                                  width: 340,
                                  height: 260,
                                  fit: BoxFit.fill,
                                )),
                              )),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        FadeTransition(
                          opacity: _FadeAnimationImageSuratS,
                          child: SlideTransition(
                              position: _PositionAnimationImagev,
                              child: TextComponent.TextTittle("Ilmu Tajwid")),
                        ),
                        FadeTransition(
                          opacity: _FadeAnimationImageSuratS,
                          child: SlideTransition(
                            position: _PositionAnimationImagev,
                            child: TextComponent.TextDescription(
                                "Belajar Tajwid",
                                colors: Colors.black),
                          ),
                        ),
                        FadeTransition(
                          opacity: _FadeAnimationImageSuratS,
                          child: StreamBuilder<DateTime>(
                            stream: _streamControllera?.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var formattedTime = DateFormat.Hms()
                                    .format(snapshot.data ?? DateTime.now());

                                return SlideTransition(
                                  position: _PositionAnimationImagev,
                                  child: TextComponent.TextTittle(
                                      "$formattedTime",
                                      colors: Colors.black),
                                );
                              } else {
                                return Text("Loading..");
                              }
                            },
                          ),
                        ),
                        FadeTransition(
                          opacity: _FadeAnimationImageSuratS,
                          child: SlideTransition(
                            position: _PositionAnimationImagev,
                            child: TextComponent.TextDescription(
                                "Ramadan 23,1444 AH",
                                colors: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 15, top: 40),
                            child: FadeTransition(
                              opacity: _FadeAnimationImageSuratS,
                              child: SlideTransition(
                                position: _PositionKategoris,
                                child: TextComponent.TextTittleJuz("Kategori",
                                    colors: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        FadeTransition(
                          opacity: _FadeAnimationImageSuratS,
                          child: SlideTransition(
                            position: _PositionAnimationImagev,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: listItem.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        side: BorderSide(
                                                            color:
                                                                selectedIndex ==
                                                                        index
                                                                    ? ColorApp
                                                                        .colorPurpler
                                                                    : Colors
                                                                        .black))),
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        selectedIndex == index
                                                            ? ColorApp
                                                                .colorPurpler
                                                            : Colors.white)),
                                            onPressed: () => {
                                                  print(index),
                                                  setState(() {
                                                    selectedIndex = index;
                                                    if (selectedIndex == 0) {
                                                      _animate();
                                                    }
                                                  }),
                                                  if (selectedIndex == 1)
                                                    {_animateToDoa()}
                                                  else if (selectedIndex == 3)
                                                    {_animateToQuiz()}
                                                },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                listItem[index],
                                                style: TextStyle(
                                                    color:
                                                        selectedIndex == index
                                                            ? Colors.white
                                                            : Colors.black),
                                              ),
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FutureBuilder<List<Doa>>(
                            future: listDoa,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Doa>? listData = snapshot.data;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: tajwidList!.length,
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 2375),
                                        child: SlideTransition(
                                            position: _PositionAnimationImagev,
                                            child: FadeTransition(
                                                opacity:
                                                    _FadeAnimationImageSuratS,
                                                child: cardJuz(
                                                    urlBacaan: tajwidList[index]
                                                        .urlBacaan,
                                                    noDoa: index.toString(),
                                                    namaDoa: tajwidList[index]
                                                        .namaHukum
                                                        .toString(),
                                                    doaArab: tajwidList[index]
                                                        .contohHuruf
                                                        .toString(),
                                                    doaLatin: tajwidList[index]
                                                        .isiPenjelasan))));
                                  },
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            })
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isPlay = false;

  late Source audioUrl;
  Widget cardJuz(
      {String? noDoa,
      String? namaDoa,
      String? doaArab,
      String? doaLatin,
      String? urlBacaan}) {
    late AnimationController animationControllerPlayButton;
    animationControllerPlayButton =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 5, color: ColorApp.colorPurpler),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Card(
            elevation: 5.0,
            color: Colors.white,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: InkWell(
              onTap: () {},
              splashColor: ColorApp.colorPurpler,
              child: Column(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 45, top: 15),
                        child: TextComponent.TextTittleJuz(
                          "${namaDoa}",
                          colors: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  "assets/ic_juz.png",
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Text(
                                      "${noDoa}",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Flexible(
                              child: TextComponent.TextDescription("${doaArab}",
                                  colors: ColorApp.colorPurpler),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 45, bottom: 15),
                        child: TextComponent.TextDescriptionJuz(
                          "${doaLatin}",
                          colors: ColorApp.colorGray,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.share_outlined,
                          ),
                          onPressed: () {},
                          color: ColorApp.colorPurpler,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (isPlay == false) {
                              isPlay = true;
                              audioUrl = UrlSource(urlBacaan.toString());
                              audioPlayer.play(audioUrl);
                              animationControllerPlayButton.forward();
                              audioPlayer.onPlayerComplete.listen((event) {
                                audioPlayer.stop();
                                animationControllerPlayButton.reverse();
                              });
                              audioPlayer.onPlayerStateChanged.listen((event) {
                                if (event == PlayerState.stopped) {
                                  animationControllerPlayButton.reverse();
                                } else if (event == PlayerState.paused) {
                                  animationControllerPlayButton.reverse();
                                }
                              });
                            } else if (isPlay == true) {
                              isPlay = false;
                              audioPlayer.pause();
                              animationControllerPlayButton.reverse();
                            }
                          },
                          child: AnimatedIcon(
                            icon: AnimatedIcons.play_pause,
                            progress: animationControllerPlayButton,
                            color: ColorApp.colorPurpler,
                          ),
                        ),
                        Icon(Icons.bookmark_outline,
                            color: ColorApp.colorPurpler)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
