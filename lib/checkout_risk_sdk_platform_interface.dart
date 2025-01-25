import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'checkout_risk_sdk_method_channel.dart';
import 'risk_env.dart';

abstract class CheckoutRiskSdkPlatform extends PlatformInterface {
  /// Constructs a CheckoutRiskSdkPlatform.
  CheckoutRiskSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static CheckoutRiskSdkPlatform _instance = MethodChannelCheckoutRiskSdk();

  /// The default instance of [CheckoutRiskSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelCheckoutRiskSdk].
  static CheckoutRiskSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CheckoutRiskSdkPlatform] when
  /// they register themselves.
  static set instance(CheckoutRiskSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getRiskDeviceId(
      {required String publicKey, required RiskEnvironment environment}) {
    throw UnimplementedError('getRiskDeviceId() has not been implemented.');
  }
}


