// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

// import 'package:web/web.dart' as web;
// import 'dart:html';
// import 'dart:js_util';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:js/js.dart';
// import 'package:js/js_util.dart';
import 'package:web/web.dart';

import 'checkout_risk_sdk_platform_interface.dart';
import 'constants.dart';
import 'risk_env.dart';

/// A web implementation of the CheckoutRiskSdkPlatform of the CheckoutRiskSdk plugin.
class CheckoutRiskSdkWeb extends CheckoutRiskSdkPlatform {
  /// Constructs a CheckoutRiskSdkWeb
  CheckoutRiskSdkWeb();

  static void registerWith(Registrar registrar) {
    CheckoutRiskSdkPlatform.instance = CheckoutRiskSdkWeb();
  }

  @override
  Future<String?> getRiskDeviceId(
      {required String publicKey, required RiskEnvironment environment}) async {
    var id = "checkout-risk-js";
    var riskJs = document.getElementById(id);
    if (riskJs == null) {
      var script = HTMLScriptElement();
      script.id = id;
      script.async = true;
      script.src = environment == RiskEnvironment.prod
          ? CheckoutConstants.liveRiskJsLink
          : CheckoutConstants.sandboxRiskJsLink;
      document.head?.append(script);
      riskJs = script;
      await riskJs.onLoad.first;
    }
    try {
      var risk = Risk.init(publicKey);
      var id = await risk.publishRiskData()?.toDart;
      return id?.toString();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}

// @JS()
// class Risk {
//   external static Risk init(String key);
//   external dynamic publishRiskData();
// }
extension type Risk._(JSObject _) implements JSObject {
  external static Risk init(String key);
  external JSPromise? publishRiskData();
}
