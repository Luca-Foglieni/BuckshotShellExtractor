import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buckshot Shell Extractor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const MyHomePage(title: 'Buckshot Shell Extractor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _shellNumber = 0;
  final List<bool> _shellSequence = [];

  bool _oneLive = false;
  bool _oneBlank = false;

  int? _evidenziataIndex;

  final random = Random();

  void _nextRound() {
    setState(() {
      _shellNumber = 2 + random.nextInt(7);

      do {
        _shellSequence.clear();
        _oneLive = false;
        _oneBlank = false;
        for (var i = 0; i < _shellNumber; i++) {
          _shellSequence.add(random.nextBool());

          if (_shellSequence.elementAt(i) == true && _oneLive == false) {
            _oneLive = true;
          }

          if (_shellSequence.last == false && _oneBlank == false) {
            _oneBlank = true;
          }
        }
      } while (_oneLive == false || _oneBlank == false);
    });

    _evidenziataIndex = -1;
  }

  void _burnerPhonePrediction() {
    if (_shellSequence.length <= 2) {
      print("How Unfortunate..");
      SnackBar(
        content: Text(
          'Messaggio mostrato!',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2), // quanto dura
      );
      return;
    }

    setState(() {
      _evidenziataIndex = random.nextInt(_shellSequence.length);
    });
  }

  void _eject() {
    if (_shellSequence.isEmpty) return;
    _shellSequence.removeAt(0);
    _evidenziataIndex = -1;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(5, 5, 3, 1),
        title: Text(widget.title),
        titleTextStyle: TextStyle(fontFamily: 'VCR_OSD_MONO', fontSize: 22),
      ),
      body: Container(
        color: Color.fromRGBO(5, 5, 3, 1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_shellNumber',
                style: TextStyle(
                  fontFamily: 'VCR_OSD_MONO',
                  fontSize: 70,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: List.generate(_shellSequence.length, (index) {
                  final bool evidenziata = index == _evidenziataIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _shellSequence[index] = !_shellSequence[index];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              evidenziata
                                  ? Border.all(color: Colors.red, width: 5)
                                  : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          _shellSequence[index]
                              ? 'assets/images/live.png'
                              : 'assets/images/blank.png',
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'nextRound',
              onPressed: _nextRound,
              tooltip: 'Next Round',
              backgroundColor: Color.fromRGBO(255, 255, 253, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/reload.png'),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'Eject',
              onPressed: _eject,
              tooltip: 'Eject',
              backgroundColor: Color.fromRGBO(255, 255, 253, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/eject.png'),
              ),
            ),
          ),
          Positioned(
            bottom: 146,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'burnerPhone',
              onPressed: _burnerPhonePrediction,
              tooltip: 'Burner Phone Prediction',
              backgroundColor: Color.fromRGBO(255, 255, 253, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/burnerPhone.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
