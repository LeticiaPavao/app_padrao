import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AgitadorDetector extends StatefulWidget {
  const AgitadorDetector({super.key});

  @override
  State<AgitadorDetector> createState() => _AgitadorDetectorState();
}

class _AgitadorDetectorState extends State<AgitadorDetector> {
  Color _backgroundColor = Colors.white;
  StreamSubscription<UserAccelerometerEvent>? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = userAccelerometerEventStream().listen((event) {
      final acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (acceleration > 15) {
        setState(() {
          _backgroundColor =
              Colors.primaries[DateTime.now().second % Colors.primaries.length];
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(title: const Text('Detector de Movimento')),
      body: const Center(
        child: Text('Agite o dispositivo!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
