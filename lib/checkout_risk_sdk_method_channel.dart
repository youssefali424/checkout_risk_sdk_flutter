import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'checkout_risk_sdk_platform_interface.dart';
import 'risk_env.dart';

/// An implementation of [CheckoutRiskSdkPlatform] that uses method channels.
class MethodChannelCheckoutRiskSdk extends CheckoutRiskSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('checkout_risk_sdk');

  static void registerWith() {
    CheckoutRiskSdkPlatform.instance = MethodChannelCheckoutRiskSdk();
  }

  @override
  Future<String?> getRiskDeviceId(
      {required String publicKey, required RiskEnvironment environment}) async {
    try {
      final result =
          await methodChannel.invokeMethod<String>('getRiskDeviceId', {
        'key': publicKey,
        'environment': environment.name,
      });
      return result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
