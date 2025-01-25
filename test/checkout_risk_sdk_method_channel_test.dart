import 'package:checkout_risk_sdk/risk_env.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checkout_risk_sdk/checkout_risk_sdk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelCheckoutRiskSdk platform = MethodChannelCheckoutRiskSdk();
  const MethodChannel channel = MethodChannel('checkout_risk_sdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return 'device-id';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(
        await platform.getRiskDeviceId(
            publicKey: "test-key", environment: RiskEnvironment.sandbox),
        'device-id');
  });
}
