import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlankScreen extends StatefulWidget {
  const BlankScreen({super.key});

  @override
  State<BlankScreen> createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {
  static const platform = MethodChannel('com.example.fteamapp/battery');
  int _batteryLevel = 0;
  String _errorMessage = '';
  Timer? _batteryTimer;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
    // Atualiza o nível da bateria a cada 2 segundos
    _batteryTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _getBatteryLevel();
    });
  }

  @override
  void dispose() {
    _batteryTimer?.cancel();
    super.dispose();
  }

  Future<void> _getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      setState(() {
        _batteryLevel = result;
        _errorMessage = '';
      });
    } on PlatformException catch (e) {
      setState(() {
        _errorMessage =
            "Erro ao obter nível da bateria: ${e.message ?? 'Erro desconhecido'}";
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Erro inesperado: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nível da Bateria'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.battery_std, size: 100, color: Colors.green),
            const SizedBox(height: 24),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Column(
                children: [
                  Text(
                    '$_batteryLevel%',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: _batteryLevel / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _batteryLevel > 20 ? Colors.green : Colors.red,
                      ),
                      minHeight: 20,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _getBatteryLevel,
              icon: const Icon(Icons.refresh),
              label: const Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
