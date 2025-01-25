package com.youssefali.checkout_risk_sdk

import android.content.Context
import android.util.Log
import com.checkout.risk.PublishDataResult
import com.checkout.risk.Risk
import com.checkout.risk.RiskConfig
import com.checkout.risk.RiskEnvironment
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlin.coroutines.CoroutineContext

/** CheckoutRiskSdkPlugin */
class CheckoutRiskSdkPlugin : FlutterPlugin, MethodCallHandler, CoroutineScope {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var mContext: Context? = null
    private lateinit var job: Job
    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main + job

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("checkout_risk_sdk", "onAttachedToEngine")
        mContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "checkout_risk_sdk")
        job = Job()
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d("checkout_risk_sdk", "onMethodCall ${call.method}")
        if (call.method == "getRiskDeviceId") {
            val key = call.argument<String>("key")
            val env = call.argument<String>("environment")
            if (key == null || env == null) {
                result.error("Error wrong values arguments", "key $key environment ${env}", "");
            } else {
                getRiskSdkDeviceId(key, env, result)
            }
        } else {
            result.notImplemented()
        }
    }

    private fun getRiskSdkDeviceId(publicKey: String, env: String, result: Result) {
        // Example usage of package
        val yourConfig = RiskConfig(
            publicKey = publicKey,
            environment = if (env == "sandbox") RiskEnvironment.SANDBOX else RiskEnvironment.PRODUCTION
        )
// Initialise the package with the getInstance method early-on
        launch {
            val riskInstance =
                Risk.getInstance(
                    mContext!!,
                    yourConfig,
                ).let {
                    it ?: run {
                        null
                    }
                }
            if (riskInstance != null) {
                riskInstance.publishData().let {
                    if (it is PublishDataResult.Success) {
                        println("Device session ID: ${it.deviceSessionId}")
                        result.success(it.deviceSessionId);
                    } else {
                        result.error("Failure couldn't publish data", "", "");
                    }
                }
            } else
                result.error("Couldn't configure risk", "", "");
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        job.cancel()
        mContext = null
        channel.setMethodCallHandler(null)
    }

}
