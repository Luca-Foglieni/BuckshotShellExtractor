import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // blocca in verticale
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buckshot Shell Extractor',
      theme: ThemeData(
        tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const MyHomePage(title: 'BUCKSHOT SHELL EXTRACTOR'),
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

  int? _burnedShell;

  int itemsNumber = 0;

  final random = Random();

  void _reload() {
    HapticFeedback.lightImpact();
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

    _burnedShell = -1;

    itemsNumber = 1 + random.nextInt(4);

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$itemsNumber ITEMS EACH.',
            style: TextStyle(fontFamily: 'VCR_OSD_MONO', fontSize: 22),
          ),
          duration: Duration(seconds: 2), //snackbar duration
        ),
      );
  }

  void _burnerPhonePrediction() {
    HapticFeedback.mediumImpact();
    if (_shellSequence.length <= 2) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'HOW UNFORTUNATE...',
              style: TextStyle(fontFamily: 'VCR_OSD_MONO', fontSize: 22),
            ),
            duration: Duration(seconds: 2), //snackbar duration
          ),
        );
      return;
    }

    setState(() {
      _burnedShell = random.nextInt(_shellSequence.length);
    });
  }

  void _eject() {
    HapticFeedback.mediumImpact();
    if (_shellSequence.isEmpty) return;
    _shellSequence.removeAt(0);
    _burnedShell = -1;

    setState(() {});
  }

  // void _diceRoll() {
  //   HapticFeedback.mediumImpact();
  //   if (_shellSequence.length <= 2) {
  //     ScaffoldMessenger.of(context)
  //       ..removeCurrentSnackBar()
  //       ..showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             'HOW UNFORTUNATE...',
  //             style: TextStyle(fontFamily: 'VCR_OSD_MONO', fontSize: 22),
  //           ),
  //           duration: Duration(seconds: 2), //snackbar duration
  //         ),
  //       );
  //     return;
  //   }

  //   setState(() {
  //     _burnedShell = random.nextInt(_shellSequence.length);
  //   });
  // }

  // void _coinFlip() {
  //   HapticFeedback.mediumImpact();
  //   if (_shellSequence.length <= 2) {
  //     ScaffoldMessenger.of(context)
  //       ..removeCurrentSnackBar()
  //       ..showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             'HOW UNFORTUNATE...',
  //             style: TextStyle(fontFamily: 'VCR_OSD_MONO', fontSize: 22),
  //           ),
  //           duration: Duration(seconds: 2), //snackbar duration
  //         ),
  //       );
  //     return;
  //   }

  //   setState(() {
  //     _burnedShell = random.nextInt(_shellSequence.length);
  //   });
  // }

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
                  final bool burnedShell = index == _burnedShell;

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
                              burnedShell
                                  ? Border.all(
                                    color: Colors.deepPurpleAccent,
                                    width: 8,
                                  )
                                  : null,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            _shellSequence[index]
                                ? 'assets/images/live.png'
                                : 'assets/images/blank.png',
                            height: 30, // aumenta l'altezza
                            width: 90, // aumenta la larghezza
                            fit:
                                BoxFit
                                    .contain, // oppure BoxFit.cover o BoxFit.fill
                          ),
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
              heroTag: 'reload',
              onPressed: _reload,
              tooltip: 'RELOAD',
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
              heroTag: 'eject',
              onPressed: _eject,
              tooltip: 'EJECT',
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
              tooltip: 'BURNER PHONE',
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


          // Positioned(
          //   bottom: 212,
          //   right: 16,
          //   child: FloatingActionButton(
          //     heroTag: 'diceRoll',
          //     onPressed: _diceRoll,
          //     tooltip: 'DICE ROLL',
          //     backgroundColor: Color.fromRGBO(255, 255, 253, 1),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Image.asset('assets/images/dice.png'),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   bottom: 278,
          //   right: 16,
          //   child: FloatingActionButton(
          //     heroTag: 'coinFlip',
          //     onPressed: _coinFlip,
          //     tooltip: 'COIN FLIP',
          //     backgroundColor: Color.fromRGBO(255, 255, 253, 1),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Image.asset('assets/images/coin.png'),
          //     ),
          //   ),
          // ),