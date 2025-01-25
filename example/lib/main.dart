import 'package:checkout_risk_sdk/risk_env.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:checkout_risk_sdk/checkout_risk_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _deviceId = 'none';
  final _checkoutRiskSdkPlugin = CheckoutRiskSdk();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      deviceId = await _checkoutRiskSdkPlugin.getRiskDeviceId(
              environment: RiskEnvironment.fromPublicKey("your-public-key"), publicKey: "your-public-key") ??
          'Failed to get device id.';
    } on PlatformException {
      deviceId = 'Failed to get device id.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout Risk Plugin example app'),
        ),
        body: Center(
          child: Text('device id: $_deviceId\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: initPlatformState,
          child: const Icon(Icons.upload_rounded),
        ),
      ),
    );
  }
}
