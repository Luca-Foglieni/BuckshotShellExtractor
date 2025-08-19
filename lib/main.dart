import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // locks app in vertical orientation
  ]);
  runApp(ChangeNotifierProvider(create: (_) => ShellOrderState(), child: MyApp()));
}

// global app theme
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buckshot Shell Extractor',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(20, 4, 1, 1),
        tooltipTheme: TooltipThemeData(textStyle: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white)),
        textTheme: TextTheme(
          headlineSmall: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          headlineMedium: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          headlineLarge: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          bodyLarge: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          bodyMedium: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          bodySmall: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          displayLarge: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          displayMedium: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          displaySmall: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          labelLarge: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          labelMedium: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          labelSmall: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          titleLarge: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          titleMedium: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
          titleSmall: TextStyle(fontFamily: 'VCR_OSD_MONO', color: Colors.white),
        ),

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const ModeSelectionScreen(title: 'BUCKSHOT SHELL EXTRACTOR'),
    );
  }
}

// global variables and functions
class ShellOrderState extends ChangeNotifier {
  final random = Random();

  // modes
  bool dealerLessMode = true;
  bool automaticMode = true;

  // extracted number of shells
  int _shellNumber = 0;

  final List<bool> _shellSequence = [];

  // number of the type of the shells
  int _nLives = 0;
  int _nBlanks = 0;

  final List<int> _shellHiddenSequence = [];

  bool _oneLive = false;
  bool _oneBlank = false;

  double _shellNumberOpacity = 0;

  int _burnedShell = -1;

  int _lastShell = -1;

  int itemsNumber = 0;

  String _dealerSpeechBubble = '';

  Timer? _resetTimer;

  void _reload() {
    _shellNumber = 2 + random.nextInt(7);
    _lastShell = -1;

    do {
      _shellSequence.clear();
      _shellHiddenSequence.clear();
      _oneLive = false;
      _oneBlank = false;
      _nLives = 0;
      _nBlanks = 0;
      for (var i = 0; i < _shellNumber; i++) {
        _shellSequence.add(random.nextBool());
        if (_shellSequence.elementAt(i)) {
          _nLives++;
        } else {
          _nBlanks++;
        }

        if (_shellSequence.elementAt(i) == true && _oneLive == false) {
          _oneLive = true;
        }

        if (_shellSequence.last == false && _oneBlank == false) {
          _oneBlank = true;
        }
      }
    } while (_oneLive == false || _oneBlank == false);

    for (var i = 0; i < _nLives; i++) {
      _shellHiddenSequence.add(1);
    }

    for (var i = 0; i < _nBlanks; i++) {
      _shellHiddenSequence.add(0);
    }

    for (var i = _nBlanks + _nLives; i < 8; i++) {
      _shellHiddenSequence.add(-1);
    }

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

  void resetSequence() {
    _dealerSpeechBubble = '';
    _shellNumberOpacity = 0;
    _shellSequence.clear();
    _lastShell = -1;
  }

  void _burnerPhonePrediction() {
    if (_shellSequence.length <= 2) {
      _dealerSpeechBubble = 'HOW UNFORTUNATE...';
      _resetDealerSpeechBubble(3);
      return;
    }

    _burnedShell = random.nextInt(_shellSequence.length);
  }

  void _eject() {
    if (_shellSequence.isNotEmpty) {
      if (_shellSequence[0]) {
        _lastShell = 1;
      } else {
        _lastShell = 0;
      }
      _shellSequence.removeAt(0);
      _burnedShell = -1;
    } else {
      _lastShell = -1;
    }
  }

  void _coinFlip() {
    bool coin = random.nextBool();
    if (coin) {
      _dealerSpeechBubble = 'HEADS.';
    } else {
      _dealerSpeechBubble = 'TAILS.';
    }
    _resetDealerSpeechBubble(3);
  }

  void _inverter() {
    if (_shellSequence.isNotEmpty) {
      _shellSequence[0] = !_shellSequence[0];
    }
  }

  void _resetDealerSpeechBubble(int delay) {
    _resetTimer?.cancel();
    _resetTimer = Timer(Duration(seconds: delay), () {
      _dealerSpeechBubble = ' ';
    });
  }
}

// mode selection screen
class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({super.key, required this.title});

  final String title;

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  late final Widget _dealerPage = DealerPage();
  late final Widget _itemsTablePage = ItemsTablePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(10, 10, 10, 1),
        title: Text(widget.title),
        titleTextStyle: TextStyle(fontSize: 22, fontFamily: 'VCR_OSD_MONO'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                'PLEASE SIGN THE WAIVER.',
                style: TextStyle(fontSize: 3000, color: Colors.white),
                maxLines: 1,
              ),

              SizedBox(height: 40),

              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            context.read<ShellOrderState>().resetSequence();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => _dealerPage));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('DEALER', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          setState(() {
                            context.read<ShellOrderState>().dealerLessMode =
                                !context.read<ShellOrderState>().dealerLessMode;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3000)),
                        ),
                        child: Text(
                          context.read<ShellOrderState>().dealerLessMode ? 'NO' : 'YES',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.read<ShellOrderState>().resetSequence();
                      context.read<ShellOrderState>().automaticMode = true;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => _itemsTablePage));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('AUTOMATIC TABLE', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.read<ShellOrderState>().resetSequence();
                      context.read<ShellOrderState>().automaticMode = false;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => _itemsTablePage));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('MANUAL TABLE', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// dealer page
class DealerPage extends StatefulWidget {
  const DealerPage({super.key});

  @override
  State<DealerPage> createState() => _DealerPageState();
}

class _DealerPageState extends State<DealerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(10, 10, 10, 1),
        title: Text('DEALER'),
        titleTextStyle: TextStyle(fontSize: 22, fontFamily: 'VCR_OSD_MONO'),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40),
              Text(
                context.read<ShellOrderState>()._dealerSpeechBubble,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                '${context.read<ShellOrderState>()._shellNumber}',
                style: TextStyle(
                  fontSize: 70,
                  color: Color.fromRGBO(255, 255, 255, context.read<ShellOrderState>()._shellNumberOpacity),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 17.5, 0),
                child: Column(
                  children: List.generate(context.read<ShellOrderState>()._shellSequence.length, (index) {
                    final bool burnedShell = index == context.read<ShellOrderState>()._burnedShell;

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: burnedShell ? Border.all(color: Colors.deepPurpleAccent, width: 8) : null,
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
                                  context.read<ShellOrderState>()._shellSequence[index]
                                      ? 'assets/images/shellExtraction/live.png'
                                      : 'assets/images/shellExtraction/blank.png',
                                  width: 90,
                                  fit: BoxFit.contain,
                                ),
                              ],
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
          // right side
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'reload',
              onPressed:
                  () => setState(() {
                    HapticFeedback.selectionClick();
                    context.read<ShellOrderState>()._reload();
                  }),
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
              onPressed:
                  () => setState(() {
                    HapticFeedback.heavyImpact();
                    context.read<ShellOrderState>()._eject();
                  }),
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
              onPressed:
                  () => setState(() {
                    HapticFeedback.selectionClick();
                    context.read<ShellOrderState>()._burnerPhonePrediction();
                  }),
              tooltip: 'BURNER PHONE',
              backgroundColor: Color.fromRGBO(255, 255, 253, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/shellExtraction/burnerPhone.png'),
              ),
            ),
          ),
          Positioned(
            bottom: 192,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'inverter',
              onPressed:
                  () => setState(() {
                    HapticFeedback.selectionClick();
                    context.read<ShellOrderState>()._inverter();
                  }),
              tooltip: 'INVERTER',
              backgroundColor: Color.fromRGBO(255, 255, 253, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/shellExtraction/inverter.png'),
              ),
            ),
          ),
          Positioned(
            bottom: 256,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'coinFlip',
              onPressed:
                  () => setState(() {
                    HapticFeedback.selectionClick();
                    context.read<ShellOrderState>()._coinFlip();
                  }),
              tooltip: 'COIN FLIP',
              backgroundColor: Color.fromRGBO(255, 255, 253, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/shellExtraction/coin.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// dealerless mode for 4 or less players
class ItemsTablePage extends StatefulWidget {
  const ItemsTablePage({super.key});

  @override
  State<ItemsTablePage> createState() => _ItemsTableState();
}

class _ItemsTableState extends State<ItemsTablePage> {
  double playerInventoryWidth = 165;

  final random = Random();

  List<int> p1items = [0, 0, 0, 0, 0, 0, 0, 0];
  List<int> p2items = [0, 0, 0, 0, 0, 0, 0, 0];
  List<int> p3items = [0, 0, 0, 0, 0, 0, 0, 0];
  List<int> p4items = [0, 0, 0, 0, 0, 0, 0, 0];

  List<bool> p1charges = [true, true, true, true, true, true];
  List<bool> p2charges = [true, true, true, true, true, true];
  List<bool> p3charges = [true, true, true, true, true, true];
  List<bool> p4charges = [true, true, true, true, true, true];

  int itemsAddedP1 = 0;
  int itemsAddedP2 = 0;
  int itemsAddedP3 = 0;
  int itemsAddedP4 = 0;

  //tracks who uses the adrenaline to correcly make them use healing items
  int adrenalineCaster = 0;
  List<bool> adrenalinePointerPCharges = [];
  List<int> adrenalinePointerPItems = [];

  static const Color statusNothing = Colors.transparent;
  static const Color statusAdrenaline = Color.fromRGBO(255, 235, 59, 0.4);

  //handcuffs variables
  bool handcuffsTrigger = false;

  int nHandcuffsSender = 0;

  List<int> handcuffedPlayers = [0, 0, 0, 0]; //each int represent a player from 1 to 4

  static const Color handcuffedColor = Color.fromRGBO(138, 138, 138, 1);
  static const Color intermediateHandcuffsColor = Color.fromRGBO(80, 80, 80, 1);
  static const Color notHandcuffedColor = Colors.transparent;

  Color p1color = notHandcuffedColor;
  Color p2color = notHandcuffedColor;
  Color p3color = notHandcuffedColor;
  Color p4color = notHandcuffedColor;

  static const Color statusHandcuffs = Color.fromRGBO(3, 168, 244, 0.4);

  // snackbar variables
  String shellSnackBarText = '';
  static const Color snackBarColor = Color.fromRGBO(20, 20, 20, 1);

  //number of different items
  int distinctItems = 10;

  // charge icon size
  double chargeIconSize = 25;

  //game turn direction
  bool turnDirectionClockwise = true;

  static const Color iconButtonHighlightColor = Colors.grey;

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

  //function that renders the inventory of the players
  IconButton insertItems(List<int> pItems, List<bool> pCharges, int playerNumber, int index) {
    bool dealerLessMode = context.read<ShellOrderState>().dealerLessMode;
    bool automaticMode = context.read<ShellOrderState>().automaticMode;

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

    switch (pItems[index]) {
      case inverter:
        return IconButton(
          // tooltip: 'INVERTER\n\nSWAPS THE POLARITY OF THE CURRENT SHELL IN THE CHAMBER.',
          onLongPress:
              () => setState(() {
                if (automaticMode) {
                  if ((isAlive(pCharges) || adrenalinePointerPCharges.isNotEmpty) &&
                      (context.read<ShellOrderState>()._shellSequence.isNotEmpty || !dealerLessMode)) {
                    if (useItem(pItems, index, pCharges)) {
                      if (dealerLessMode) {
                        context.read<ShellOrderState>()._inverter();
                      }
                    }
                  }
                } else {
                  // manual mode
                  useItem(pItems, index, pCharges);
                }
              }),
          onPressed: () => itemTooltipSnackbar(1),
          icon: Image.asset('assets/images/items/inverter.png', height: imageHeight, width: imageWidth),
          highlightColor: iconButtonHighlightColor,
        );

      case beer:
        return IconButton(
          // tooltip: 'BEER\n\nRACKS THE SHOTGUN. EJECTS CURRENT SHELL.',
          onLongPress:
              () => setState(() {
                if (automaticMode) {
                  if ((isAlive(pCharges) || adrenalinePointerPCharges.isNotEmpty) &&
                      (context.read<ShellOrderState>()._shellSequence.isNotEmpty || !dealerLessMode)) {
                    if (useItem(pItems, index, pCharges)) {
                      if (dealerLessMode) {
                        shellSnackBarText = 'EJECTED';
                        shellEjectingSnackbar();
                        context.read<ShellOrderState>()._eject();
                      }
                    }
                  }
                } else {
                  // manual mode
                  useItem(pItems, index, pCharges);
                }
              }),
          onPressed: () => itemTooltipSnackbar(2),
          icon: Image.asset('assets/images/items/beer.png', height: imageHeight, width: imageWidth),
          highlightColor: iconButtonHighlightColor,
        );

      case cigarettePack:
        return IconButton(
          // tooltip: 'CIGARETTE PACK\n\nTAKES THE EDGE OFF. REGAIN 1 CHARGE.',
          onLongPress:
              () => setState(() {
                if (automaticMode) {
                  if ((isAlive(pCharges) || adrenalinePointerPCharges.isNotEmpty) &&
                      (context.read<ShellOrderState>()._shellSequence.isNotEmpty || !dealerLessMode)) {
                    if (adrenalinePointerPCharges != pCharges) {
                      if (adrenalinePointerPCharges.isEmpty) {
                        addCharges(pCharges, 1);
                      } else {
                        addCharges(adrenalinePointerPCharges, 1);
                      }
                      useItem(pItems, index, pCharges);
                      adrenalinePointerPCharges = [];
                      adrenalinePointerPItems = [];
                      adrenalineCaster = 0;
                    }
                  }
                } else {
                  // manual mode
                  useItem(pItems, index, pCharges);
                }
              }),
          onPressed: () => itemTooltipSnackbar(3),
          icon: Image.asset('assets/images/items/cigarettePack.png', height: imageHeight, width: imageWidth),
          highlightColor: iconButtonHighlightColor,
        );

      case adrenaline:
        return IconButton(
          // tooltip: 'ADRENALINE\n\nSTEAL AN ITEM AND USE IT IMMEDIATELY.',
          onLongPress:
              () => setState(() {
                if (automaticMode) {
                  if ((isAlive(pCharges) || adrenalinePointerPCharges.isNotEmpty) &&
                      (context.read<ShellOrderState>()._shellSequence.isNotEmpty || !dealerLessMode)) {
                    if (adrenalinePointerPCharges.isEmpty) {
                      bool foundSomethingOtherThanAdrenalineAndHandcuffs = false;
                      bool foundSomethingOtherThanAdrenaline = false;
                      for (int i = 0; i < pItems.length; i++) {
                        if ((p1items[i] != 4 && p1items[i] != 7 && p1items[i] != 0 && playerNumber != 1) ||
                            (p2items[i] != 4 && p2items[i] != 7 && p2items[i] != 0 && playerNumber != 2) ||
                            (p3items[i] != 4 && p3items[i] != 7 && p3items[i] != 0 && playerNumber != 3) ||
                            (p4items[i] != 4 && p4items[i] != 7 && p4items[i] != 0 && playerNumber != 4)) {
                          foundSomethingOtherThanAdrenalineAndHandcuffs = true;
                        }
                        if ((p1items[i] != 4 && p1items[i] != 0 && playerNumber != 1) ||
                            (p2items[i] != 4 && p2items[i] != 0 && playerNumber != 2) ||
                            (p3items[i] != 4 && p3items[i] != 0 && playerNumber != 3) ||
                            (p4items[i] != 4 && p4items[i] != 0 && playerNumber != 4)) {
                          foundSomethingOtherThanAdrenaline = true;
                        }
                        if (foundSomethingOtherThanAdrenalineAndHandcuffs && foundSomethingOtherThanAdrenaline) {
                          break;
                        }
                      }
                      if (foundSomethingOtherThanAdrenalineAndHandcuffs) {
                        adrenalinePointerPCharges = pCharges;
                        adrenalinePointerPCharges = pCharges;
                        adrenalinePointerPItems = pItems;
                        adrenalineCaster = playerNumber;
                        pItems[index] = 0;
                      } else if (foundSomethingOtherThanAdrenaline &&
                          (boolToInt(handcuffedPlayers.elementAt(0) != 0) +
                                  boolToInt(handcuffedPlayers.elementAt(1) != 0) +
                                  boolToInt(handcuffedPlayers.elementAt(2) != 0) +
                                  boolToInt(handcuffedPlayers.elementAt(3) != 0)) <
                              (boolToInt(isAlive(p1charges)) +
                                      boolToInt(isAlive(p2charges)) +
                                      boolToInt(isAlive(p3charges)) +
                                      boolToInt(isAlive(p4charges))) -
                                  1) {
                        adrenalinePointerPCharges = pCharges;
                        adrenalinePointerPItems = pItems;
                        adrenalineCaster = playerNumber;
                        HapticFeedback.heavyImpact();
                        pItems[index] = 0;
                      }
                    }
                  }
                } else {
                  // manual mode
                  useItem(pItems, index, pCharges);
                }
              }),
          onPressed: () => itemTooltipSnackbar(4),
          icon: Image.asset('assets/images/items/adrenaline.png', height: imageHeight, width: imageWidth),
          highlightColor: iconButtonHighlightColor,
        );

      case burnerPhone:
        return IconButton(
          // tooltip: 'BURNER PHONE\n\nA MYSTERIOUS VOICE GIVES YOU AN INSIGHT INTO THE FUTURE.',
          onLongPress:
              () => setState(() {
                if (automaticMode) {
                  if ((isAlive(pCharges) || adrenalinePointerPCharges.isNotEmpty) &&
                      (context.read<ShellOrderState>()._shellSequence.isNotEmpty || !dealerLessMode)) {
                    if (useItem(pItems, index, pCharges)) {
                      if (dealerLessMode) {
                        context.read<ShellOrderState>()._burnerPhonePrediction();
                        burnerPhoneSnackBar();
                      }
                    }
                  }
                } else {
                  // manual mode
                  useItem(pItems, index, pCharges);
                }
              }),
          onPressed: () => itemTooltipSnackbar(5),
          icon: Image.asset('assets/images/items/burnerPhone.png', height: imageHeight, width: imageWidth),
          highlightColor: iconButtonHighlightColor,
        );

      case handsaw:
        return IconButton(
          // tooltip: 'HANDSAW\n\nSHOTGUN DEALS 2 DAMAGE.',
          onLongPress:
              () => setState(() {
                if (automaticMode) {
                  if ((isAlive(pCharges) || adrenalinePointerPCharges.isNotEmpty) &&
                      (context.read<ShellOrderState>()._shellSequence.isNotEmpty || !dealerLessMode)) {
                    if (useItem(pItems, index, pCharges)) {}
                  }
                } else {
                  // manual mode
                  useItem(pItems, index, pCharges);
                }
              }),
          onPressed: () => itemTooltipSnackbar(6),
          icon: Image.asset('assets/images/items/handsaw.png', height: imageHeight, width: imageWidth),
          highlightColor: iconButtonHighlightColor,
        );

      case handcuffs:
        return IconButton(
          // tooltip: 'HANDCUFFS\n\nSELECTED OPPONENT SKIPS THEIR NEXT TURN.',
          onLongPress:
              () => setState(() {
                if (automaticMode) {
                  if ((isAlive(pCharges) || adrenalinePointerPCharges.isNotEmpty) &&
                      (context.read<ShellOrderState>()._shellSequence.isNotEmpty || !dealerLessMode)) {
                    if (adrenalinePointerPCharges != pCharges &&
                        (boolToInt(handcuffedPlayers.elementAt(0) != 0) +
                                boolToInt(handcuffedPlayers.elementAt(1) != 0) +
                                boolToInt(handcuffedPlayers.elementAt(2) != 0) +
                                boolToInt(handcuffedPlayers.elementAt(3) != 0)) <
                            (boolToInt(isAlive(p1charges)) +
                                    boolToInt(isAlive(p2charges)) +
                                    boolToInt(isAlive(p3charges)) +
                                    boolToInt(isAlive(p4charges))) -
                                1) {
                      pItems[index] = 0;
                      HapticFeedback.heavyImpact();
                      handcuffsTrigger = true;
                      if (adrenalineCaster != 0) {
                        nHandcuffsSender = adrenalineCaster;
                      } else {
                        nHandcuffsSender = playerNumber;
                      }
                      adrenalinePointerPCharges = [];
                      adrenalinePointerPItems = [];
                      adrenalineCaster = 0;
                    }
                  }
                } else {
                  // manual mode
                  useItem(pItems, index, pCharges);
                }
              }),
          onPressed: () => itemTooltipSnackbar(7),
          icon: Image.asset('assets/images/items/handcuffs.png', height: imageHeight, width: imageWidth),
          highlightColor: iconButtonHighlightColor,
        );

      case expiredMedicine:
        return IconButton(
          // tooltip: 'EXPIRED MEDICINE\n\n50% CHANCE OF GAINING 2 CHARGES. IF NOT, LOSE 1 CHARGE.',
          onLongPress:
              () => setState(() {
                if (automaticMode) {
                  if ((isAlive(pCharges) || adrenalinePointerPCharges.isNotEmpty) &&
                      (context.read<ShellOrderState>()._shellSequence.isNotEmpty || !dealerLessMode)) {
                    if (adrenalinePointerPCharges != pCharges) {
                      if (adrenalinePointerPCharges.isEmpty) {
                        if (random.nextBool()) {
                          addCharges(pCharges, 2);
                        } else {
                          removeCharges(pCharges, 1);
                        }
                      } else {
                        if (random.nextBool()) {
                          addCharges(adrenalinePointerPCharges, 2);
                        } else {
                          removeCharges(adrenalinePointerPCharges, 1);
                        }
                      }
                      useItem(pItems, index, pCharges);
                    }
                  }
                } else {
                  // manual mode
                  useItem(pItems, index, pCharges);
                }
              }),
          onPressed: () => itemTooltipSnackbar(8),
          icon: Image.asset('assets/images/items/expiredMedicine.png', height: imageHeight, width: imageWidth),
          highlightColor: iconButtonHighlightColor,
        );

      case magnifyingGlass:
        return IconButton(
          // tooltip: 'MAGNIFYING GLASS\n\nCHECK THE CURRENT ROUND IN THE CHAMBER.',
          onLongPress:
              () => setState(() {
                if (automaticMode) {
                  if ((isAlive(pCharges) || adrenalinePointerPCharges.isNotEmpty) &&
                      (context.read<ShellOrderState>()._shellSequence.isNotEmpty || !dealerLessMode)) {
                    if (useItem(pItems, index, pCharges)) {
                      if (dealerLessMode) {
                        shellSnackBarText = 'NEXT SHELL';
                        magnifyingGlassSnackBar();
                      }
                    }
                  }
                } else {
                  // manual mode
                  useItem(pItems, index, pCharges);
                }
              }),
          onPressed: () => itemTooltipSnackbar(9),
          icon: Image.asset('assets/images/items/magnifyingGlass.png', height: imageHeight, width: imageWidth),
          highlightColor: iconButtonHighlightColor,
        );

      case remote:
        return IconButton(
          // tooltip: 'REMOTE\n\nSWAPS THE CURRENT TURN ORDER.',
          onLongPress:
              () => setState(() {
                if (automaticMode) {
                  if ((isAlive(pCharges) || adrenalinePointerPCharges.isNotEmpty) &&
                      (context.read<ShellOrderState>()._shellSequence.isNotEmpty || !dealerLessMode)) {
                    if (useItem(pItems, index, pCharges)) {
                      if (turnDirectionClockwise) {
                        turnDirectionClockwise = false;
                      } else {
                        turnDirectionClockwise = true;
                      }
                    }
                  }
                } else {
                  // manual mode
                  useItem(pItems, index, pCharges);
                }
              }),
          onPressed: () => itemTooltipSnackbar(10),
          icon: Image.asset('assets/images/items/remote.png', height: imageHeight, width: imageWidth),
          highlightColor: iconButtonHighlightColor,
        );

      default:
        return IconButton(
          onPressed: () => {},
          icon: Image.asset('assets/images/items/itemSpace.png', height: imageHeight, width: imageWidth),
        );
    }
  }

  // player charges handling functions
  GestureDetector insertPlayerCharges(List<bool> pCharges, int index) {
    if (pCharges.elementAt(index) == true) {
      return GestureDetector(
        onTap:
            () => setState(() {
              removeCharges(pCharges, 1);
            }),
        child: Image.asset('assets/images/items/charge.png', height: chargeIconSize, width: chargeIconSize),
      );
    } else {
      return GestureDetector(
        onTap:
            () => setState(() {
              addCharges(pCharges, 1);
            }),
        child: Image.asset('assets/images/items/itemSpace.png', height: chargeIconSize, width: chargeIconSize),
      );
    }
  }

  void addCharges(List<bool> pCharges, int nCharges) {
    int counter = 0;

    setState(() {
      for (int i = 0; i < pCharges.length; i++) {
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
        if (counter == nCharges) {
          break;
        }
        if (pCharges.elementAt(i) == true) {
          pCharges[i] = false;
          counter++;
        }
      }
      deadPlayerHandcuffsRemover();
    });
  }

  //TODO: find a better way to do this
  void deadPlayerHandcuffsRemover() {
    if (!isAlive(p1charges)) {
      handcuffsHandler(1, p1charges);
      handcuffsHandler(1, p1charges);
    }
    if (!isAlive(p2charges)) {
      handcuffsHandler(2, p2charges);
      handcuffsHandler(2, p2charges);
    }
    if (!isAlive(p3charges)) {
      handcuffsHandler(3, p3charges);
      handcuffsHandler(3, p3charges);
    }
    if (!isAlive(p4charges)) {
      handcuffsHandler(4, p4charges);
      handcuffsHandler(4, p4charges);
    }
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
    deadPlayerHandcuffsRemover();
  }

  void invertCharges(List<bool> pCharges) {
    if (pCharges.every((element) => element == false)) {
      fullCharges(pCharges);
    } else {
      emptyCharges(pCharges);
    }
  }

  bool isAlive(List<bool> pCharges) {
    for (bool charge in pCharges) {
      if (charge) {
        return true;
      }
    }
    return false;
  }

  Image turnDirectionRenderer() {
    const double turnDirectionSize = 45;

    if (turnDirectionClockwise) {
      return Image.asset('assets/images/items/turnsDirectionClockwise.png', height: turnDirectionSize);
    } else {
      return Image.asset('assets/images/items/turnsDirectionCounterClockwise.png', height: turnDirectionSize);
    }
  }

  bool useItem(List<int> pItems, int index, List<bool> pCharges) {
    if (adrenalinePointerPCharges != pCharges) {
      pItems[index] = 0;
      HapticFeedback.heavyImpact();
      adrenalinePointerPCharges = [];
      adrenalinePointerPItems = [];
      adrenalineCaster = 0;
      return true;
    } else {
      return false;
    }
  }

  void handcuffsHandler(int nReceiver, List<bool> pCharges) {
    setState(() {
      if (handcuffsTrigger &&
          nHandcuffsSender != nReceiver &&
          handcuffedPlayers[nReceiver - 1] < 1 &&
          isAlive(pCharges)) {
        handcuffsTrigger = false;
        switch (nReceiver) {
          case 1:
            p1color = handcuffedColor;
            handcuffedPlayers[0] = 2;
            break;
          case 2:
            p2color = handcuffedColor;
            handcuffedPlayers[1] = 2;
            break;
          case 3:
            p3color = handcuffedColor;
            handcuffedPlayers[2] = 2;
          case 4:
            p4color = handcuffedColor;
            handcuffedPlayers[3] = 2;
          default:
        }
      } else if (handcuffedPlayers[nReceiver - 1] == 2 &&
          handcuffsTrigger == false &&
          adrenalinePointerPCharges.isEmpty) {
        switch (nReceiver) {
          case 1:
            p1color = intermediateHandcuffsColor;
            handcuffedPlayers[0] = 1;
            break;
          case 2:
            p2color = intermediateHandcuffsColor;
            handcuffedPlayers[1] = 1;
            break;
          case 3:
            p3color = intermediateHandcuffsColor;
            handcuffedPlayers[2] = 1;
          case 4:
            p4color = intermediateHandcuffsColor;
            handcuffedPlayers[3] = 1;
          default:
        }
      } else if (handcuffedPlayers[nReceiver - 1] == 1 &&
          handcuffsTrigger == false &&
          adrenalinePointerPCharges.isEmpty) {
        switch (nReceiver) {
          case 1:
            p1color = notHandcuffedColor;
            handcuffedPlayers[0] = 0;
            break;
          case 2:
            p2color = notHandcuffedColor;
            handcuffedPlayers[1] = 0;
            break;
          case 3:
            p3color = notHandcuffedColor;
            handcuffedPlayers[2] = 0;
          case 4:
            p4color = notHandcuffedColor;
            handcuffedPlayers[3] = 0;
          default:
        }
      }
    });
  }

  Color statusBorderManager() {
    if (adrenalinePointerPCharges.isNotEmpty) {
      return statusAdrenaline;
    } else if (handcuffsTrigger) {
      return statusHandcuffs;
    } else {
      return statusNothing;
    }
  }

  Image renderLastShell() {
    if (context.read<ShellOrderState>()._lastShell == 1) {
      return Image.asset('assets/images/shellExtraction/live.png', width: 90, fit: BoxFit.contain);
    } else if (context.read<ShellOrderState>()._lastShell == 0) {
      return Image.asset('assets/images/shellExtraction/blank.png', width: 90, fit: BoxFit.contain);
    } else {
      return Image.asset('assets/images/items/itemSpace.png', width: 90, fit: BoxFit.contain);
    }
  }

  Image renderShell(int shellType) {
    if (shellType == 1) {
      return Image.asset('assets/images/shellExtraction/live.png', fit: BoxFit.contain);
    } else if (shellType == 0) {
      return Image.asset('assets/images/shellExtraction/blank.png', fit: BoxFit.contain);
    } else {
      return Image.asset('assets/images/items/itemSpace.png', fit: BoxFit.contain);
    }
  }

  List<Widget> magnifyingGlassItemsScreen() {
    if (context.read<ShellOrderState>()._shellSequence.isNotEmpty) {
      return [
        AutoSizeText(shellSnackBarText, style: TextStyle(fontSize: 3000, color: Colors.white), maxLines: 1),
        Image.asset(
          context.read<ShellOrderState>()._shellSequence.elementAt(0)
              ? 'assets/images/shellExtraction/live.png'
              : 'assets/images/shellExtraction/blank.png',
          fit: BoxFit.fitWidth,
        ),
      ];
    } else {
      return [AutoSizeText('THE CHAMBER IS EMPTY', style: TextStyle(color: Colors.white, fontSize: 3000), maxLines: 1)];
    }
  }

  List<Widget> burnerPhoneItemsScreen() {
    if (context.read<ShellOrderState>()._burnedShell != -1) {
      return [
        AutoSizeText(
          (context.read<ShellOrderState>()._burnedShell + 1).toString(),
          style: TextStyle(fontSize: 90, color: Colors.white),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Image.asset(
            context.read<ShellOrderState>()._shellSequence[context.read<ShellOrderState>()._burnedShell]
                ? 'assets/images/shellExtraction/live.png'
                : 'assets/images/shellExtraction/blank.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ];
    } else {
      return [
        Expanded(
          child: AutoSizeText(
            context.read<ShellOrderState>()._dealerSpeechBubble,
            style: TextStyle(color: Colors.white, fontSize: 3000),
            maxLines: 1,
          ),
        ),
      ];
    }
  }

  ElevatedButton switchReloadAndEject() {
    if (context.read<ShellOrderState>()._shellSequence.isEmpty) {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            context.read<ShellOrderState>()._reload();
            itemsGenerator(context.read<ShellOrderState>().itemsNumber);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: snackBarColor,
                content: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(70.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          context.read<ShellOrderState>()._dealerSpeechBubble,
                          style: TextStyle(fontSize: 3000),
                          maxLines: 1,
                        ),
                        SizedBox(height: 30),
                        ...List.generate(context.read<ShellOrderState>()._shellHiddenSequence.length, (index) {
                          return Expanded(
                            child: renderShell(context.read<ShellOrderState>()._shellHiddenSequence.elementAt(index)),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/shellExtraction/reload.png'),
        ),
      );
    } else {
      return ElevatedButton(
        // heroTag: 'ejectButton',
        onPressed: () {
          setState(() {
            shellSnackBarText = 'SHOT';
            shellEjectingSnackbar();
            context.read<ShellOrderState>()._eject();
          });
        },

        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/shellExtraction/eject.png'),
        ),
      );
    }
  }

  void shellEjectingSnackbar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: snackBarColor,
        content: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(shellSnackBarText, style: TextStyle(fontSize: 3000, color: Colors.white), maxLines: 1),
                Image.asset(
                  context.read<ShellOrderState>()._shellSequence.elementAt(0)
                      ? 'assets/images/shellExtraction/live.png'
                      : 'assets/images/shellExtraction/blank.png',
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void magnifyingGlassSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: snackBarColor,
        content: SizedBox(
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: magnifyingGlassItemsScreen()),
          ),
        ),
      ),
    );
  }

  void burnerPhoneSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: snackBarColor,
        content: SizedBox(
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText('THE VOICE TELLS YOU', style: TextStyle(fontSize: 3000, color: Colors.white), maxLines: 1),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: burnerPhoneItemsScreen()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void itemTooltipSnackbar(int itemType) {
    String itemName = '';
    String itemImagePath = '';
    String itemDescription = '';

    switch (itemType) {
      case 1:
        itemName = 'INVERTER';
        itemImagePath = 'assets/images/items/inverter.png';
        itemDescription = 'SWAPS THE POLARITY OF THE CURRENT SHELL IN THE CHAMBER.';
        break;
      case 2:
        itemName = 'BEER';
        itemImagePath = 'assets/images/items/beer.png';
        itemDescription = 'RACKS THE SHOTGUN. EJECTS CURRENT SHELL.';
        break;
      case 3:
        itemName = 'CIGARETTE PACK';
        itemImagePath = 'assets/images/items/cigarettePack.png';
        itemDescription = 'TAKES THE EDGE OFF. REGAIN 1 CHARGE.';
        break;
      case 4:
        itemName = 'ADRENALINE';
        itemImagePath = 'assets/images/items/adrenaline.png';
        itemDescription = 'STEAL AN ITEM AND USE IT IMMEDIATELY.';
        break;
      case 5:
        itemName = 'BURNER PHONE';
        itemImagePath = 'assets/images/items/burnerPhone.png';
        itemDescription = 'A MYSTERIOUS VOICE GIVES YOU AN INSIGHT INTO THE FUTURE.';
        break;
      case 6:
        itemName = 'HANDSAW';
        itemImagePath = 'assets/images/items/handsaw.png';
        itemDescription = 'SHOTGUN DEALS 2 DAMAGE.';
        break;
      case 7:
        itemName = 'HANDCUFFS';
        itemImagePath = 'assets/images/items/handcuffs.png';
        itemDescription = 'SELECTED OPPONENT SKIPS THEIR NEXT TURN.';
        break;
      case 8:
        itemName = 'EXPIRED MEDICINE';
        itemImagePath = 'assets/images/items/expiredMedicine.png';
        itemDescription = '50% CHANCE OF GAINING 2 CHARGES. IF NOT, LOSE 1 CHARGE.';
        break;
      case 9:
        itemName = 'MAGNIFYING GLASS';
        itemImagePath = 'assets/images/items/magnifyingGlass.png';
        itemDescription = 'CHECK THE CURRENT ROUND IN THE CHAMBER.';
        break;
      case 10:
        itemName = 'REMOTE';
        itemImagePath = 'assets/images/items/remote.png';
        itemDescription = 'SWAPS THE CURRENT TURN ORDER.';
        break;
      default:
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: snackBarColor,
        duration: Duration(days: 1),
        content: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AutoSizeText(itemName, style: TextStyle(fontSize: 200, color: Colors.white), maxLines: 1),
                Text(itemName, style: TextStyle(fontSize: 45, color: Colors.white)),
                SizedBox(height: 20),
                Image.asset(
                  itemImagePath,
                  height: MediaQuery.of(context).size.width / 1.5,
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
                SizedBox(height: 50),
                Text(itemDescription, style: TextStyle(fontSize: 20, color: Colors.white)),

                // AutoSizeText(itemDescription, style: TextStyle(fontSize: 20, color: Colors.white), maxLines: 2),

                // ElevatedButton(onPressed: () => {}, child: Text('USE')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> typeOfButtonHanlder() {
    // automatic dealerless mode
    if (context.read<ShellOrderState>().dealerLessMode && context.read<ShellOrderState>().automaticMode) {
      return [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(padding: const EdgeInsets.all(24.0), child: turnDirectionRenderer()),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(width: 150, height: 65, child: switchReloadAndEject()),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(padding: const EdgeInsets.all(4.0), child: renderLastShell()),
        ),
      ];
      // automatic mode with external dealer
    } else if (!context.read<ShellOrderState>().dealerLessMode && context.read<ShellOrderState>().automaticMode) {
      return [
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.fromLTRB(0, 0, 25, 0), child: turnDirectionRenderer()),
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
                      child: Text('I', style: TextStyle(fontSize: 22, color: Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FloatingActionButton(
                      heroTag: '2Items',
                      backgroundColor: Colors.grey,
                      onPressed: () => itemsGenerator(2),
                      child: Text('II', style: TextStyle(fontSize: 22, color: Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FloatingActionButton(
                      heroTag: '3Items',
                      backgroundColor: Colors.grey,
                      onPressed: () => itemsGenerator(3),
                      child: Text('III', style: TextStyle(fontSize: 22, color: Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FloatingActionButton(
                      heroTag: '4Items',
                      backgroundColor: Colors.grey,
                      onPressed: () => itemsGenerator(4),
                      child: Text('IV', style: TextStyle(fontSize: 22, color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ];

      // manual dealerless mode
    } else if (context.read<ShellOrderState>().dealerLessMode && !context.read<ShellOrderState>().automaticMode) {
      return [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Wrap(
              children: [
                IconButton(
                  onPressed: () => {shellSnackBarText = "NEXT SHELL", magnifyingGlassSnackBar()},
                  icon: Image.asset('assets/images/items/magnifyingGlass.png', width: 40),
                  highlightColor: Colors.grey,
                ),
                IconButton(
                  onPressed: () => {context.read<ShellOrderState>()._burnerPhonePrediction(), burnerPhoneSnackBar()},
                  icon: Image.asset('assets/images/items/burnerPhone.png', width: 40),
                  highlightColor: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(width: 120, height: 65, child: switchReloadAndEject()),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(padding: const EdgeInsets.all(4.0), child: renderLastShell()),
        ),
      ];

      //manual mode with external dealer
    } else if (!context.read<ShellOrderState>().dealerLessMode && !context.read<ShellOrderState>().automaticMode) {
      return [
        Align(
          alignment: Alignment.center,
          child: Wrap(
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
                  child: Text('I', style: TextStyle(fontSize: 22, color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: FloatingActionButton(
                  heroTag: '2Items',
                  backgroundColor: Colors.grey,
                  onPressed: () => itemsGenerator(2),
                  child: Text('II', style: TextStyle(fontSize: 22, color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: FloatingActionButton(
                  heroTag: '3Items',
                  backgroundColor: Colors.grey,
                  onPressed: () => itemsGenerator(3),
                  child: Text('III', style: TextStyle(fontSize: 22, color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: FloatingActionButton(
                  heroTag: '4Items',
                  backgroundColor: Colors.grey,
                  onPressed: () => itemsGenerator(4),
                  child: Text('IV', style: TextStyle(fontSize: 22, color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ];
    } else {
      return [Text('APOCRYPHAL BUTTON SEQUENCE')];
    }
  }

  int boolToInt(bool flag) {
    if (flag) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              //Player 1
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: p1color,
                    border: Border(
                      right: BorderSide(color: Colors.grey, width: 2),
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
                      GestureDetector(
                        onTap: () => handcuffsHandler(1, p1charges),
                        child: AbsorbPointer(
                          absorbing:
                              (handcuffsTrigger || handcuffedPlayers.elementAt(0) != 0) &&
                              adrenalinePointerPCharges.isEmpty,
                          child: SizedBox(
                            width: playerInventoryWidth,
                            child: Center(
                              child: Wrap(
                                children: List.generate(p1items.length, (index) {
                                  return insertItems(p1items, p1charges, 1, index);
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Player 2
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: p2color,
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
                      GestureDetector(
                        onTap: () => handcuffsHandler(2, p2charges),
                        child: AbsorbPointer(
                          absorbing:
                              (handcuffsTrigger || handcuffedPlayers.elementAt(1) != 0) &&
                              adrenalinePointerPCharges.isEmpty,
                          child: SizedBox(
                            width: playerInventoryWidth,
                            child: Center(
                              child: Wrap(
                                children: List.generate(p2items.length, (index) {
                                  return insertItems(p2items, p2charges, 2, index);
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // items buttons
              ...typeOfButtonHanlder(),

              //Player 3
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: p3color,
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 2),
                      right: BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => handcuffsHandler(3, p3charges),
                        child: AbsorbPointer(
                          absorbing:
                              (handcuffsTrigger || handcuffedPlayers.elementAt(2) != 0) &&
                              adrenalinePointerPCharges.isEmpty,
                          child: SizedBox(
                            width: playerInventoryWidth,
                            child: Center(
                              child: Wrap(
                                children: List.generate(p3items.length, (index) {
                                  return insertItems(p3items, p3charges, 3, index);
                                }),
                              ),
                            ),
                          ),
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

              //Player 4
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: p4color,
                    border: Border(
                      left: BorderSide(color: Colors.grey, width: 2),
                      top: BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => handcuffsHandler(4, p4charges),
                        child: AbsorbPointer(
                          absorbing:
                              (handcuffsTrigger || handcuffedPlayers.elementAt(3) != 0) &&
                              adrenalinePointerPCharges.isEmpty,
                          child: SizedBox(
                            width: playerInventoryWidth,
                            child: Center(
                              child: Wrap(
                                children: List.generate(p4items.length, (index) {
                                  return insertItems(p4items, p4charges, 4, index);
                                }),
                              ),
                            ),
                          ),
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
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: statusBorderManager(), width: 12),
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
