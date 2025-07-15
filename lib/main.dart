import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // locks app in vertical orientation
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
  late final Widget _itemExtractorPage = ItemExtractor();
  //to fix, the state of the items page is not saved when you go back to the homepage

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

    _resetTimer?.cancel();
    // _resetDealerSpeechBubble(120);
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

  void _coinFlip() {
    bool coin = random.nextBool();
    setState(() {
      if (coin) {
        _dealerSpeechBubble = 'HEADS.';
      } else {
        _dealerSpeechBubble = 'TAILS.';
      }
    });
    _resetDealerSpeechBubble(3);
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
        backgroundColor: Color.fromRGBO(10, 10, 10, 1),
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
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                '$_shellNumber',
                style: TextStyle(
                  fontSize: 70,
                  color: Color.fromRGBO(255, 255, 255, _shellNumberOpacity),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 17.5, 0),
                child: Column(
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
                            padding: const EdgeInsets.all(0),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 2, 4, 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text((index + 1).toString()),
                                  SizedBox(width: 5),
                                  Image.asset(
                                    _shellSequence[index]
                                        ? 'assets/images/shellExtraction/live.png'
                                        : 'assets/images/shellExtraction/blank.png',
                                    // height: 30,
                                    width: 90,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'reload',
              onPressed: _reload,
              tooltip: 'RELOAD',
              backgroundColor: Color.fromRGBO(255, 255, 253, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/shellExtraction/reload.png'),
              ),
            ),
          ),
          Positioned(
            bottom: 64,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'eject',
              onPressed: _eject,
              tooltip: 'EJECT',
              backgroundColor: Color.fromRGBO(255, 255, 253, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/shellExtraction/eject.png'),
              ),
            ),
          ),
          Positioned(
            bottom: 128,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'burnerPhone',
              onPressed: _burnerPhonePrediction,
              tooltip: 'BURNER PHONE',
              backgroundColor: Color.fromRGBO(255, 255, 253, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/shellExtraction/burnerPhone.png',
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 192,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'coinFlip',
              onPressed: _coinFlip,
              tooltip: 'COIN FLIP',
              backgroundColor: Color.fromRGBO(255, 255, 253, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/shellExtraction/coin.png'),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 30,
            child: FloatingActionButton(
              heroTag: 'gotoCardsPage',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => _itemExtractorPage),
                );
              },
              tooltip: 'ITEMS PAGE',
              backgroundColor: Color.fromRGBO(255, 255, 253, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/shellExtraction/beer.png'),
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
  double playerInventoryWidth = 160;

  final random = Random();

  List<int> p1items = [0, 0, 0, 0, 0, 0, 0, 0];
  List<int> p2items = [0, 0, 0, 0, 0, 0, 0, 0];
  List<int> p3items = [0, 0, 0, 0, 0, 0, 0, 0];
  List<int> p4items = [0, 0, 0, 0, 0, 0, 0, 0];

  bool p1alive = true;
  bool p2alive = true;
  bool p3alive = true;
  bool p4alive = true;

  List<bool> p1charges = [true, true, true, true, true, true];
  List<bool> p2charges = [true, true, true, true, true, true];
  List<bool> p3charges = [true, true, true, true, true, true];
  List<bool> p4charges = [true, true, true, true, true, true];

  int itemsAddedP1 = 0;
  int itemsAddedP2 = 0;
  int itemsAddedP3 = 0;
  int itemsAddedP4 = 0;

  List<bool> adrenalinePointer = [];

  int handcuffsTrigger = 0;

  int distinctItems = 10;

  double chargeIconSize = 25;

  bool turnDirectionClockwise = true;

  void itemsGenerator(int numberOfItems) {
    //function that actually add the number of items selected in the inventory (list) of every player

    itemsAddedP1 = 0;
    itemsAddedP2 = 0;
    itemsAddedP3 = 0;
    itemsAddedP4 = 0;

    setState(() {
      for (var i = 0; i < 8; i++) {
        if (p1items.elementAt(i) == 0 &&
            itemsAddedP1 < numberOfItems &&
            !(p1charges.every((element) => element == false))) {
          p1items[i] = (1 + random.nextInt(distinctItems));
          itemsAddedP1++;
        }
        if (p2items.elementAt(i) == 0 &&
            itemsAddedP2 < numberOfItems &&
            !(p2charges.every((element) => element == false))) {
          p2items[i] = (1 + random.nextInt(distinctItems));
          itemsAddedP2++;
        }
        if (p3items.elementAt(i) == 0 &&
            itemsAddedP3 < numberOfItems &&
            !(p3charges.every((element) => element == false))) {
          p3items[i] = (1 + random.nextInt(distinctItems));
          itemsAddedP3++;
        }
        if (p4items.elementAt(i) == 0 &&
            itemsAddedP4 < numberOfItems &&
            !(p4charges.every((element) => element == false))) {
          p4items[i] = (1 + random.nextInt(distinctItems));
          itemsAddedP4++;
        }
      }
    });
  }

  IconButton insertCardImage(List<int> p, List<bool> pCharges, int index) {
    //function that renders the inventory of the players

    const int inverter = 1;
    const int beer = 2;
    const int cigarettePack = 3;
    const int adrenaline = 4;
    const int burnerPhone = 5;
    const int handsaw = 6;
    const int handcuffs = 7;
    const int expiredMedicine = 8;
    const int magnifyingGlass = 9;
    const int remote = 10;

    const double imageHeight = 60;
    const double imageWidth = 60;

    switch (p[index]) {
      case inverter:
        return IconButton(
          tooltip: 'INVERTER',
          onPressed:
              () => setState(() {
                if (adrenalinePointer != pCharges) {
                  p[index] = 0;
                  adrenalinePointer = [];
                }
              }),

          icon: Image.asset(
            'assets/images/items/inverter.png',
            height: imageHeight,
            width: imageWidth,
          ),
        );

      case beer:
        return IconButton(
          tooltip: 'BEER',
          onPressed:
              () => setState(() {
                if (adrenalinePointer != pCharges) {
                  p[index] = 0;
                  adrenalinePointer = [];
                }
              }),

          icon: Image.asset(
            'assets/images/items/beer.png',
            height: imageHeight,
            width: imageWidth,
          ),
        );
      case cigarettePack:
        return IconButton(
          tooltip: 'CIGARETTE PACK',
          onPressed:
              () => setState(() {
                if (adrenalinePointer != pCharges) {
                  p[index] = 0;

                  if (adrenalinePointer.isEmpty) {
                    addCharges(pCharges, 1);
                  } else {
                    addCharges(adrenalinePointer, 1);
                  }
                  adrenalinePointer = [];
                }
              }),

          icon: Image.asset(
            'assets/images/items/cigarettePack.png',
            height: imageHeight,
            width: imageWidth,
          ),
        );
      case adrenaline:
        return IconButton(
          tooltip: 'ADRENALINE',
          onPressed:
              () => setState(() {
                if (adrenalinePointer.isEmpty) {
                  adrenalinePointer = pCharges;
                  p[index] = 0;
                }
              }),

          icon: Image.asset(
            'assets/images/items/adrenaline.png',
            height: imageHeight,
            width: imageWidth,
          ),
        );
      case burnerPhone:
        return IconButton(
          tooltip: 'BURNER PHONE',
          onPressed:
              () => setState(() {
                if (adrenalinePointer != pCharges) {
                  p[index] = 0;
                  adrenalinePointer = [];
                }
              }),

          icon: Image.asset(
            'assets/images/items/burnerPhone.png',
            height: imageHeight,
            width: imageWidth,
          ),
        );
      case handsaw:
        return IconButton(
          tooltip: 'HANDSAW',
          onPressed:
              () => setState(() {
                if (adrenalinePointer != pCharges) {
                  p[index] = 0;
                  adrenalinePointer = [];
                }
              }),

          icon: Image.asset(
            'assets/images/items/handsaw.png',
            height: imageHeight,
            width: imageWidth,
          ),
        );
      case handcuffs:
        return IconButton(
          tooltip: 'HANDCUFFS',
          onPressed:
              () => setState(() {
                if (adrenalinePointer != pCharges) {
                  p[index] = 0;
                  adrenalinePointer = [];
                }
              }),

          icon: Image.asset(
            'assets/images/items/handcuffs.png',
            height: imageHeight,
            width: imageWidth,
          ),
        );
      case expiredMedicine:
        return IconButton(
          tooltip: 'EXPIRED MEDICINE',
          onPressed:
              () => setState(() {
                if (adrenalinePointer != pCharges) {
                  p[index] = 0;

                  if (adrenalinePointer.isEmpty) {
                    if (random.nextBool()) {
                      addCharges(pCharges, 2);
                    } else {
                      removeCharges(pCharges, 1);
                    }
                  } else {
                    if (random.nextBool()) {
                      addCharges(adrenalinePointer, 2);
                    } else {
                      removeCharges(adrenalinePointer, 1);
                    }
                  }
                  adrenalinePointer = [];
                }
              }),

          icon: Image.asset(
            'assets/images/items/expiredMedicine.png',
            height: imageHeight,
            width: imageWidth,
          ),
        );
      case magnifyingGlass:
        return IconButton(
          tooltip: 'MAGNIFYING GLASS',
          onPressed:
              () => setState(() {
                if (adrenalinePointer != pCharges) {
                  p[index] = 0;

                  adrenalinePointer = [];
                }
              }),

          icon: Image.asset(
            'assets/images/items/magnifyingGlass.png',
            height: imageHeight,
            width: imageWidth,
          ),
        );
      case remote:
        return IconButton(
          tooltip: 'REMOTE',
          onPressed:
              () => setState(() {
                if (adrenalinePointer != pCharges) {
                  p[index] = 0;
                  if (turnDirectionClockwise) {
                    turnDirectionClockwise = false;
                  } else {
                    turnDirectionClockwise = true;
                  }
                  adrenalinePointer = [];
                }
              }),

          icon: Image.asset(
            'assets/images/items/remote.png',
            height: imageHeight,
            width: imageWidth,
          ),
        );
      default:
        return IconButton(
          onPressed: () => {},

          icon: Image.asset(
            'assets/images/items/itemSpace.png',
            height: imageHeight,
            width: imageWidth,
          ),
        );
    }
  }

  GestureDetector insertPlayerCharges(List<bool> pCharges, int index) {
    if (pCharges.elementAt(index) == true) {
      return GestureDetector(
        onTap:
            () => setState(() {
              removeCharges(pCharges, 1);
            }),
        child: Image.asset(
          'assets/images/items/charge.png',
          height: chargeIconSize,
          width: chargeIconSize,
        ),
      );
    } else {
      return GestureDetector(
        onTap:
            () => setState(() {
              addCharges(pCharges, 1);
            }),
        child: Image.asset(
          'assets/images/items/itemSpace.png',
          height: chargeIconSize,
          width: chargeIconSize,
        ),
      );
    }
  }

  void addCharges(List<bool> pCharges, int nCharges) {
    int counter = 0;

    setState(() {
      for (int i = 0; i < pCharges.length; i++) {
        // print(i);
        if (counter == nCharges) {
          break;
        }
        if (pCharges.elementAt(i) == false) {
          pCharges[i] = true;
          counter++;
        }
      }
    });
  }

  void removeCharges(List<bool> pCharges, int nCharges) {
    int counter = 0;

    setState(() {
      for (int i = 5; i >= 0; i--) {
        // print(i);
        if (counter == nCharges) {
          break;
        }
        if (pCharges.elementAt(i) == true) {
          pCharges[i] = false;
          counter++;
        }
      }
    });
  }

  void fullCharges(List<bool> pCharges) {
    for (var i = 0; i < pCharges.length; i++) {
      pCharges[i] = true;
    }
  }

  void emptyCharges(List<bool> pCharges) {
    for (var i = 0; i < pCharges.length; i++) {
      pCharges[i] = false;
    }
  }

  void invertCharges(List<bool> pCharges) {
    if (pCharges.every((element) => element == false)) {
      fullCharges(pCharges);
    } else {
      emptyCharges(pCharges);
    }
  }

  Image turnDirectionRenderer() {
    const double turnDirectionSize = 45;

    if (turnDirectionClockwise) {
      return Image.asset(
        'assets/images/items/turnsDirectionClockwise.png',
        height: turnDirectionSize,
      );
    } else {
      return Image.asset(
        'assets/images/items/turnsDirectionCounterClockwise.png',
        height: turnDirectionSize,
      );
    }
  }

  handcuffsHandler() {
    if (handcuffsTrigger != 0) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          GestureDetector(
            onTap: handcuffsHandler(),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey, width: 2),
                    bottom: BorderSide(color: Colors.grey, width: 2),
                  ),
                  // color: Colors.blueGrey,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onLongPress:
                            () => setState(() {
                              invertCharges(p1charges);
                            }),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(p1charges.length, (index) {
                            return insertPlayerCharges(p1charges, index);
                          }),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: playerInventoryWidth,
                      child: Wrap(
                        children: List.generate(p1items.length, (index) {
                          return insertCardImage(p1items, p1charges, index);
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey, width: 2),
                  bottom: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onLongPress:
                          () => setState(() {
                            invertCharges(p2charges);
                          }),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(p2charges.length, (index) {
                          return insertPlayerCharges(p2charges, index);
                        }),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: playerInventoryWidth,
                    child: Wrap(
                      children: List.generate(p2items.length, (index) {
                        return insertCardImage(p2items, p2charges, index);
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                  child: turnDirectionRenderer(),
                ),
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FloatingActionButton(
                        heroTag: '1Items',
                        backgroundColor: Colors.grey,
                        onPressed:
                            () => setState(() {
                              itemsGenerator(1);
                            }),
                        child: Text(
                          'I',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FloatingActionButton(
                        heroTag: '2Items',
                        backgroundColor: Colors.grey,
                        onPressed: () => itemsGenerator(2),
                        child: Text(
                          'II',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FloatingActionButton(
                        heroTag: '3Items',
                        backgroundColor: Colors.grey,
                        onPressed: () => itemsGenerator(3),
                        child: Text(
                          'III',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FloatingActionButton(
                        heroTag: '4Items',
                        backgroundColor: Colors.grey,
                        onPressed: () => itemsGenerator(4),
                        child: Text(
                          'IV',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 2),
                  right: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: playerInventoryWidth,
                    child: Wrap(
                      children: List.generate(p3items.length, (index) {
                        return insertCardImage(p3items, p3charges, index);
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onLongPress:
                          () => setState(() {
                            invertCharges(p3charges);
                          }),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(p3charges.length, (index) {
                          return insertPlayerCharges(p3charges, index);
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey, width: 2),
                  top: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: playerInventoryWidth,
                    child: Wrap(
                      children: List.generate(p4items.length, (index) {
                        return insertCardImage(p4items, p4charges, index);
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onLongPress:
                          () => setState(() {
                            invertCharges(p4charges);
                          }),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(p4charges.length, (index) {
                          return insertPlayerCharges(p4charges, index);
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
