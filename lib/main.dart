import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _roll = 'NA'; // Initialize with an empty string
  String _pitch = 'NA'; // Initialize with an empty string

  String _roll1 = 'NA'; // Initialize with an empty string
  String _pitch1 = 'NA'; // Initialize with an empty string

  String _roll2 = 'NA'; // Initialize with an empty string
  String _pitch2 = 'NA'; // Initialize with an empty string

  Future<String>? _future;
  String? _data;

  @override
  void initState() {
    super.initState();
    subscribeToSSE();
  }

  // Subscribe to web server events update roll and pitch
  void subscribeToSSE() {
    SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      // Get from web server
      url:
          'http://192.168.0.179/events', // change the IP address to the IP address that your ESP32 uses
      // Personal Hotspot
      // url: 'http://192.168.43.109/events',
      header: {},
    ).listen(
      (event) {
        // Parse the event data
        final eventData = jsonDecode(event.data!);
        setState(() {
          // Update roll and pitch values
          _roll = eventData['roll'] ?? '';
          _pitch = eventData['pitch'] ?? '';

          _roll1 = eventData['roll1'] ?? '';
          _pitch1 = eventData['pitch1'] ?? '';

          _roll2 = eventData['roll2'] ?? '';
          _pitch2 = eventData['pitch2'] ?? '';
        });
      },
    );
  }

  // Calibrate roll and pitch
  Future<String> calibrateSensor(String sensor) async {
    final response = await http.get(Uri.parse(
        'http://192.168.0.179/$sensor')); // change the IP address to the IP address that your ESP32 uses
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to calibrate");
    }

    // Personal Hotspot
    // final response = await http.get(Uri.parse('http://192.168.43.109/$sensor'));
  }

  // Debugging function for testing only!
  // Remove it when deploy
  void sayHi() {
    print("You pressed a button!");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'King Post Roll & Pitch',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('King Post Roll & Pitch'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Center(
          child: Column(
            children: [
              Card(
                child: _SampleCard(
                  cardTitle: 'AVERAGE',
                  roll: _roll,
                  pitch: _pitch,
                ),
              ),
              Card(
                child: _SampleCard(
                  cardTitle: 'SENSOR 1',
                  roll: _roll1,
                  pitch: _pitch1,
                ),
              ),
              Card(
                child: _SampleCard(
                  cardTitle: 'SENSOR 2',
                  roll: _roll2,
                  pitch: _pitch2,
                ),
              ),
              SizedBox(height: 20),
              _future == null
                  ? _data == null
                      ? Text('Press the button to calibrate')
                      : Text('$_data')
                  : FutureBuilder<String>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _data = snapshot.data;
                              _future = null;
                            });
                          });
                          return SizedBox.shrink();
                        } else {
                          return Text('Unknown state');
                        }
                      },
                    ),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          tooltip: 'Calibrate',
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              label: 'Sensor 1',
              onTap: () => {_future = calibrateSensor('calibrate1')},
            ),
            SpeedDialChild(
              label: 'Sensor 2',
              onTap: () => {_future = calibrateSensor('calibrate2')},
            ),
          ],
        ),
      ),
    );
  }
}

class _SampleCard extends StatelessWidget {
  _SampleCard(
      {required this.cardTitle, required this.roll, required this.pitch});

  String cardTitle;
  String roll;
  String pitch;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            cardTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('Roll: $roll'),
          Text('Pitch: $pitch'),
        ],
      ),
    );
  }
}

void main() => runApp(const MyApp());
