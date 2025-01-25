import 'constants.dart';

enum RiskEnvironment {
  sandbox,
  prod;

  static RiskEnvironment fromPublicKey(String key) {
    var isLive = CheckoutConstants.mbcLivePublicKeyRegex.hasMatch(key) ||
        CheckoutConstants.nasLivePublicKeyRegex.hasMatch(key);
    return isLive ? RiskEnvironment.prod : RiskEnvironment.sandbox;
  }
}
