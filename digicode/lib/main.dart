import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(ParkingApp());
}

class ParkingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ParkingScreen(),
    );
  }
}

class ParkingScreen extends StatefulWidget {
  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  List<bool> occupied = [false, false, false];
  int? selectedSpot;
  List<DateTime?> endTime = [null, null, null];
  List<bool> blinkVisible = [true, true, true];

  Timer? timer;
  final List<int> durationOptions = [2, 5, 7]; // րոպեներ

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        checkTime();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void reserveSpot(int index, int minutes) {
    setState(() {
      endTime[index] = DateTime.now().add(Duration(minutes: minutes));
      occupied[index] = true;
      selectedSpot = null;
      blinkVisible[index] = true;
    });
  }

  void checkTime() {
    final now = DateTime.now();
    for (int i = 0; i < endTime.length; i++) {
      if (endTime[i] != null) {
        final diff = endTime[i]!.difference(now).inSeconds;

        if (diff <= 0) {
          occupied[i] = false;
          endTime[i] = null;
          blinkVisible[i] = true;
        } else if (diff <= 10) {
          blinkVisible[i] = !blinkVisible[i];
        } else {
          blinkVisible[i] = true;
        }
      }
    }
  }

  int availableSpots() => occupied.where((o) => !o).length;

  Color getSpotColor(int index) {
    if (!occupied[index]) return Colors.green;
    if (endTime[index] != null &&
        endTime[index]!.difference(DateTime.now()).inSeconds <= 10) {
      return blinkVisible[index] ? Colors.red : Colors.transparent;
    }
    return Colors.red;
  }

  String remainingTime(int index) {
    if (endTime[index] == null) return "0:00";
    final diff = endTime[index]!.difference(DateTime.now());
    if (diff.isNegative) return "0:00";
    final minutes = diff.inMinutes;
    final seconds = diff.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Park Smart",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Available Spots Container
            Container(
              margin: EdgeInsets.only(bottom: 30),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                "Available Spots: ${availableSpots()}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            // Parking Spots Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 120,
                        icon: Icon(
                          Icons.directions_car,
                          color: getSpotColor(index),
                        ),
                        onPressed: occupied[index]
                            ? null
                            : () {
                                setState(() {
                                  selectedSpot =
                                      selectedSpot == index ? null : index;
                                });
                              },
                      ),
                      Text(
                        "Spot ${index + 1}\n${occupied[index] ? 'Occupied' : 'Free'}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (occupied[index] && endTime[index] != null)
                        Text(
                          "Remaining: ${remainingTime(index)}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: 30),
            if (selectedSpot != null)
              Wrap(
                spacing: 10,
                children: durationOptions.map((minutes) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () => reserveSpot(selectedSpot!, minutes),
                    child: Text(
                      "$minutes min",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}