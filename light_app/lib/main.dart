import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// const հեռացված
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Light App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

// const հեռացված
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLedOn = false;

  void toggleLed() {
    setState(() {
      isLedOn = !isLedOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LED Control'), // const հանված
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LED is ${isLedOn ? "ON" : "OFF"}', // const հանված
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // const հանված
            ElevatedButton(
              onPressed: toggleLed,
              child: Text(isLedOn ? 'Turn OFF' : 'Turn ON'), // const հանված
            ),
          ],
        ),
      ),
    );
  }
}