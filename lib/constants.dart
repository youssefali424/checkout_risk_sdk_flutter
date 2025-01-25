class CheckoutConstants {
  static const sandboxBaseUrl = "https://api.sandbox.checkout.com";
  static const liveBaseUrl = "https://api.checkout.com";
  static const sandboxRiskJsLink =
      "https://risk.sandbox.checkout.com/cdn/risk/1/risk.js";
  static const liveRiskJsLink = "https://risk.checkout.com/cdn/risk/1/risk.js";
  static final mbcLivePublicKeyRegex =
      RegExp(r"^pk_?(\w{8})-(\w{4})-(\w{4})-(\w{4})-(\w{12})$");
  static final nasLivePublicKeyRegex =
      RegExp(r"^pk_?[a-z2-7]{26}[a-z2-7*#$=]$");
}
