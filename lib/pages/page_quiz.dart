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
import 'package:my_quran/pages/tajwid.dart';
import 'package:my_quran/utils/colors.dart';
import 'package:http/http.dart' as http;

class Jawaban {
  String? opsi;
  String? jawaban;
  Jawaban({this.opsi, this.jawaban});
}

class SoalClass {
  String? namaGambar;
  String? namaSoal;
  String? jawabanBenar;
  List<Jawaban>? listJawaban;
  SoalClass(
      this.namaGambar, this.namaSoal, this.jawabanBenar, this.listJawaban);
}

class PageQuiz extends StatefulWidget {
  static String? routeName = "/PageQuiz";

  @override
  State<PageQuiz> createState() => _PageQuizState();
}

class _PageQuizState extends State<PageQuiz> with TickerProviderStateMixin {
  int selectedIndex = 3;
  StreamController<DateTime>? _streamControllera;
  final GlobalKey<State<PageQuiz>> _animationLimiterKeya = GlobalKey();
  late AnimationController _controller;

  late Animation<double> _FadeAnimationImageSuratS;
  late Animation<Offset> _PositionAnimationImagev;
  late Animation<Offset> _PositionKategoris;

  Timer? _timer;
  late Future<List<Doa>> listDoa;

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

  void _animateToTajwid() {
    // Check the status of the AnimationController and start/stop the animation accordingly
    if (_controller.status == AnimationStatus.completed ||
        _controller.status == AnimationStatus.forward) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    Future.delayed(Duration(milliseconds: 2400), () {
      Navigator.of(context).popAndPushNamed(PageTajwid.routeName.toString());
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
    List<SoalClass> listSoal = [
      SoalClass(
        "https://i.ibb.co/mR17C5C/1.jpg",
        "Berdasarkan gambar, Idgham Maal ghunnah berlaku apabila ...",
        "B",
        [
          Jawaban(opsi: "A", jawaban: "Nun Sakinah bertemu Nun"),
          Jawaban(opsi: "B", jawaban: "Nun Sakinah bertemu Lam"),
          Jawaban(opsi: "C", jawaban: "Tanwin bertemu Lam"),
          Jawaban(opsi: "D", jawaban: "Nun Sakinah bertemu Ba"),
        ],
      ),
      SoalClass(
        "https://i.ibb.co/pb8ZLKw/2.jpg",
        "Dua contoh di atas merujuk kepada",
        "C",
        [
          Jawaban(opsi: "A", jawaban: "Idgham Maal Ghunnah"),
          Jawaban(opsi: "B", jawaban: "Iqlab"),
          Jawaban(opsi: "C", jawaban: "Idgham Bila ghunnah"),
          Jawaban(opsi: "D", jawaban: "Izhar Halqi"),
        ],
      ),
      SoalClass(
        "https://i.ibb.co/CsKRhLq/3.jpg",
        "Berdasarkan gambar, ....... bertemu Ro",
        "A",
        [
          Jawaban(opsi: "A", jawaban: "Tanwin"),
          Jawaban(opsi: "B", jawaban: "Alif"),
          Jawaban(opsi: "C", jawaban: "Nun Sakinah"),
          Jawaban(opsi: "D", jawaban: "Nun Mati"),
        ],
      ),
      SoalClass(
        "https://i.ibb.co/SfsxQJp/4.jpg",
        "Kedua-dua contoh Idgham Maal Ghunnah ini adalah sama...",
        "B",
        [
          Jawaban(opsi: "A", jawaban: "Nun sakinah bertemu Mim"),
          Jawaban(opsi: "B", jawaban: "Tanwin Kasrotain bertemu Mim"),
          Jawaban(opsi: "C", jawaban: "Tanwin Fathatain bertemu Mim"),
          Jawaban(opsi: "D", jawaban: "Syaddah bertemu Mim"),
        ],
      ),
    ];

    bool showHasilJawaban = false;
    String? selectedJawaban;
    bool isJawabanBenar = false;
    List<String> listItem = ["Surat", "Doa", "Tajwid", "Quiz"];
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
                              child: TextComponent.TextTittle("Quiz Tajwid")),
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
                                  physics: PageScrollPhysics(),
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
                                                  else if (selectedIndex == 2)
                                                    {_animateToTajwid()}
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
                        ...listSoal
                            .map((soal) =>
                                SoalWidget(soal, onJawabanSelected: (value) {
                                  setState(() {
                                    selectedJawaban = value;
                                  });
                                }))
                            .toList(),
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
}

class HasilJawaban extends StatelessWidget {
  final List<SoalClass> listSoal;
  final String? selectedJawaban;

  HasilJawaban(this.listSoal, this.selectedJawaban);

  @override
  Widget build(BuildContext context) {
    int jawabanBenar = 0;
    int jawabanSalah = 0;

    for (var soal in listSoal) {
      if (soal.jawabanBenar == selectedJawaban) {
        jawabanBenar++;
      } else {
        jawabanSalah++;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jawaban Benar: $jawabanBenar'),
        Text('Jawaban Salah: $jawabanSalah'),
      ],
    );
  }
}

class SoalWidget extends StatefulWidget {
  final SoalClass soal;
  final ValueChanged<String?> onJawabanSelected;

  SoalWidget(this.soal, {required this.onJawabanSelected});

  @override
  _SoalWidgetState createState() => _SoalWidgetState();
}

class _SoalWidgetState extends State<SoalWidget> {
  String? selectedJawaban;
  bool showHasilJawaban = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          widget.soal.namaGambar!,
          width: 200,
          height: 200,
        ),
        SizedBox(height: 10),
        Text(
          widget.soal.namaSoal!,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Column(
          children: widget.soal.listJawaban!.map((jawaban) {
            return Row(
              children: [
                Radio<String>(
                  value: jawaban.opsi!,
                  groupValue: selectedJawaban,
                  onChanged: (value) {
                    setState(() {
                      selectedJawaban = value;
                      widget.onJawabanSelected(value);
                      showHasilJawaban = true;
                    });
                  },
                ),
                SizedBox(width: 5),
                Text(jawaban.jawaban!),
              ],
            );
          }).toList(),
        ),
        if (showHasilJawaban)
          Text(
            selectedJawaban == widget.soal.jawabanBenar
                ? 'Jawaban Anda Benar!'
                : 'Jawaban Anda Salah!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selectedJawaban == widget.soal.jawabanBenar
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        Divider(),
      ],
    );
  }
}
