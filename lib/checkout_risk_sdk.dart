// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'checkout_risk_sdk_platform_interface.dart';
import 'risk_env.dart';
export 'checkout_risk_sdk_method_channel.dart';

class CheckoutRiskSdk {
  Future<String?> getRiskDeviceId(
      {required String publicKey, required RiskEnvironment environment}) {
    return CheckoutRiskSdkPlatform.instance
        .getRiskDeviceId(environment: environment, publicKey: publicKey);
  }
}
