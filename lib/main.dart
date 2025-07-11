import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
        primaryColor: Color.fromRGBO(20, 4, 1, 1),
        tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
          bodyLarge: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          bodyMedium: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
          bodySmall: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          displayLarge: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
          displaySmall: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
          labelLarge: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
          labelMedium: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
          labelSmall: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
          titleSmall: TextStyle(
            fontFamily: 'VCR_OSD_MONO',
            color: Colors.white,
          ),
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
  final random = Random();

  int _shellNumber = 0;
  final List<bool> _shellSequence = [];

  bool _oneLive = false;
  bool _oneBlank = false;

  double _shellNumberOpacity = 0;

  int? _burnedShell;

  int itemsNumber = 0;

  String _dealerSpeechBubble = 'PLEASE SIGN THE WAIVER.';

  Timer? _resetTimer;

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

    if (itemsNumber == 1) {
      _dealerSpeechBubble = '$itemsNumber ITEM EACH.';
    } else {
      _dealerSpeechBubble = '$itemsNumber ITEMS EACH.';
    }
    _shellNumberOpacity = 1;

    _resetDealerSpeechBubble(20);
  }

  void _burnerPhonePrediction() {
    HapticFeedback.mediumImpact();
    if (_shellSequence.length <= 2) {
      setState(() {
        _dealerSpeechBubble = 'HOW UNFORTUNATE...';
      });
      _resetDealerSpeechBubble(3);
      return;
    }

    setState(() {
      _burnedShell = random.nextInt(_shellSequence.length);
    });
  }

  void _eject() {
    HapticFeedback.mediumImpact();
    if (_shellSequence.isEmpty) return;

    setState(() {
      _shellSequence.removeAt(0);
      _burnedShell = -1;
    });
  }

  void _resetDealerSpeechBubble(int delay) {
    _resetTimer?.cancel();
    _resetTimer = Timer(Duration(seconds: delay), () {
      setState(() {
        _dealerSpeechBubble = ' ';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(5, 5, 5, 1),
        title: Text(widget.title),
        titleTextStyle: TextStyle(fontFamily: 'VCR_OSD_MONO', fontSize: 22),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40),
              Text(
                _dealerSpeechBubble,
                style: TextStyle(
                  color: Colors.white,
                  // fontFamily: 'VCR_OSD_MONO',
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '$_shellNumber',
                style: TextStyle(
                  // fontFamily: 'VCR_OSD_MONO',
                  fontSize: 70,
                  color: Color.fromRGBO(255, 255, 255, _shellNumberOpacity),
                ),
              ),

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
          Positioned(
            bottom: 300,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'gotoCardsPage',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemExtractor()),
                );
              },
              tooltip: 'gotoCardsPage',
              backgroundColor: Color.fromRGBO(255, 255, 253, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // child: Image.asset('assets/images/burnerPhone.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemExtractor extends StatefulWidget {
  const ItemExtractor({super.key});

  @override
  State<ItemExtractor> createState() => _ItemExtractorState();
}

class _ItemExtractorState extends State<ItemExtractor> {
  final random = Random();

  List<int> p1 = [];
  List<int> p2 = [];
  List<int> p3 = [];
  List<int> p4 = [];

  void _itemGenerator1() {
    itemsGenerator(1);
  }

  void _itemsGenerator2() {
    itemsGenerator(2);
  }

  void _itemsGenerator3() {
    itemsGenerator(3);
  }

  void _itemsGenerator4() {
    itemsGenerator(4);
  }

  void itemsGenerator(int numberOfItems) {
    //funzione che aggiunge effettivamente il numero di oggetti selezionato all'inventario (list) di ogni giocatore
    setState(() {
      int itemsLimit = 8;
      int distinctItems = 10;

      for (var i = 0; i < numberOfItems; i++) {
        if (p1.length < itemsLimit) {
          p1.add(1 + random.nextInt(distinctItems));
        }
        if (p2.length < itemsLimit) {
          p2.add(1 + random.nextInt(distinctItems));
        }
        if (p3.length < itemsLimit) {
          p3.add(1 + random.nextInt(distinctItems));
        }
        if (p4.length < itemsLimit) {
          p4.add(1 + random.nextInt(distinctItems));
        }
      }
    });
  }

  Image insertCardImage(List<int> p, int index) {
    const int inverter = 1;
    const int beer = 2;
    const int sigarettePack = 3;
    const int adrenaline = 4;
    const int burnerPhone = 5;
    const int handsaw = 6;
    const int handcuffs = 7;
    const int expiredMedice = 8;
    const int magnifyingGlass = 9;
    const int remote = 10;

    const double imageHeight = 70;

    switch (p[index]) {
      case inverter:
        return Image.asset(
          'assets/images/cards/inverter.png',
          height: imageHeight,
        );
      case beer:
        return Image.asset('assets/images/cards/beer.png', height: imageHeight);
      case sigarettePack:
        return Image.asset(
          'assets/images/cards/sigarettePack.png',
          height: imageHeight,
        );
      case adrenaline:
        return Image.asset(
          'assets/images/cards/adrenaline.png',
          height: imageHeight,
        );
      case burnerPhone:
        return Image.asset(
          'assets/images/cards/burnerPhone.png',
          height: imageHeight,
        );
      case handsaw:
        return Image.asset(
          'assets/images/cards/handsaw.png',
          height: imageHeight,
        );
      case handcuffs:
        return Image.asset(
          'assets/images/cards/handcuffs.png',
          height: imageHeight,
        );
      case expiredMedice:
        return Image.asset(
          'assets/images/cards/expiredMedicine.png',
          height: imageHeight,
        );
      case magnifyingGlass:
        return Image.asset(
          'assets/images/cards/magnifyingGlass.png',
          height: imageHeight,
        );
      case remote:
        return Image.asset(
          'assets/images/cards/remote.png',
          height: imageHeight,
        );
      default:
        return Image.asset('assets/images/eject.png', height: 50, width: 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(5, 5, 5, 1),
        title: Text('ITEMS EXTRACTOR'),
        titleTextStyle: TextStyle(fontFamily: 'VCR_OSD_MONO', fontSize: 22),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 120,
              child: Wrap(
                children: List.generate(p1.length, (index) {
                  return insertCardImage(p1, index);
                }),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: 120,
              child: Wrap(
                children: List.generate(p2.length, (index) {
                  return insertCardImage(p2, index);
                }),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Wrap(
              children: [
                FloatingActionButton(
                  heroTag: '1Items',
                  onPressed: _itemGenerator1,
                  child: Text('1'),
                ),
                FloatingActionButton(
                  heroTag: '2Items',
                  onPressed: _itemsGenerator2,
                  child: Text('2'),
                ),
                FloatingActionButton(
                  heroTag: '3Items',
                  onPressed: _itemsGenerator3,
                  child: Text('3'),
                ),
                FloatingActionButton(
                  heroTag: '4Items',
                  onPressed: _itemsGenerator4,
                  child: Text('4'),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 120,
              child: Wrap(
                children: List.generate(p3.length, (index) {
                  return insertCardImage(p3, index);
                }),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 120,
              child: Wrap(
                children: List.generate(p4.length, (index) {
                  return insertCardImage(p4, index);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
