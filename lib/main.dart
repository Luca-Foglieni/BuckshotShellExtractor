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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_shellNumber',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            Column(
              children: List.generate(_shellSequence.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _shellSequence[index] = !_shellSequence[index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      _shellSequence[index]
                          ? 'assets/images/live.png'
                          : 'assets/images/blank.png',
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextRound,
        tooltip: 'Next Round',
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/reload.png'),
        ),
      ),
    );
  }
}
