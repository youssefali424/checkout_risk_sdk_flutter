import Flutter
import UIKit

public class CheckoutRiskSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "checkout_risk_sdk", binaryMessenger: registrar.messenger())
    let instance = CheckoutRiskSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getRiskDeviceId":
      if let args = call.arguments as? Dictionary<String, Any>,
          let publicKey = args["key"] as? String,
          let env = args["environment"] as? String {
          print("riskSdk args \(publicKey) \(env)")
          // please check the "as" above  - wasn't able to test
          // handle the method
          self.getRiskSdkDeviceId(publicKey: publicKey, env: env, flutterResult: result)
      } else {
          result(FlutterError.init(code: "wrong arguments", message: "key or environment wrong data", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func getRiskSdkDeviceId(publicKey: String, env: String, flutterResult: @escaping FlutterResult){
    let yourConfig = RiskConfig(publicKey: publicKey, environment: env == "sandbox" ? RiskEnvironment.sandbox : RiskEnvironment.production)

    // Initialize early-on in your app
    self.riskSDK = Risk.init(config: yourConfig)

    self.riskSDK?.configure { configurationResult in
        switch configurationResult {
        case .failure(let errorResponse):
            print("riskSdk "+errorResponse.localizedDescription)
            flutterResult(FlutterError(code: "Error",
                                message: "Error configuring risk sdk",
                                details: nil))
        case .success():
            self.riskSDK!.publishData { result in
                switch result {
                case .success(let response):
                    flutterResult(response.deviceSessionId)
                case .failure(let errorResponse):
                    flutterResult(FlutterError(code: "Error",
                                        message: errorResponse.localizedDescription,
                                        details: nil))
                }
            }
        }
    }
}
}
