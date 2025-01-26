package com.example.clean_one

import android.graphics.Color
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.widget.Toast
import com.paymob.paymob_sdk.PaymobSdk
import com.paymob.paymob_sdk.domain.model.CreditCard
import com.paymob.paymob_sdk.domain.model.SavedCard
import com.paymob.paymob_sdk.ui.PaymobSdkListener

class MainActivity: FlutterActivity(), MethodCallHandler, PaymobSdkListener {
    private val CHANNEL = "paymob_sdk_flutter"
    private var SDKResult: MethodChannel.Result? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        flutterEngine?.dartExecutor?.binaryMessenger?.let {
            MethodChannel(it, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "payWithPaymob") {
                    SDKResult = result
                    callNativeSDK(call)
                } else {
                    result.notImplemented()
                }
            }
        }
    }
    // Function to call native PaymobSDK
    private fun callNativeSDK(call: MethodCall) {
        val arguments = call.arguments as? Map<String, Any>
        val publicKey = call.argument<String>("publicKey")
        val clientSecret = call.argument<String>("clientSecret")
        var buttonBackgroundColor: Int? = null
        var buttonTextColor: Int? = null
        val appName = call.argument<String>("appName")
        val buttonBackgroundColorData = call.argument<Number>("buttonBackgroundColor")?.toInt() ?: 0
        val buttonTextColorData = call.argument<Number>("buttonTextColor")?.toInt() ?: 0

   
        if (buttonTextColorData != null){
            buttonTextColor = Color.argb(
                (buttonTextColorData shr 24) and 0xFF,  // Alpha
                (buttonTextColorData shr 16) and 0xFF,  // Red
                (buttonTextColorData shr 8) and 0xFF,   // Green
                buttonTextColorData and 0xFF            // Blue
            )
        }
        Log.d("color", buttonTextColor.toString())
        if (buttonBackgroundColorData != null){
            buttonBackgroundColor = Color.argb(
                (buttonBackgroundColorData shr 24) and 0xFF,  // Alpha
                (buttonBackgroundColorData shr 16) and 0xFF,  // Red
                (buttonBackgroundColorData shr 8) and 0xFF,   // Green
                buttonBackgroundColorData and 0xFF            // Blue
            )
        }
        val paymobsdk = PaymobSdk.Builder(
            context = this@MainActivity,
            clientSecret = clientSecret.toString(),
            publicKey = publicKey.toString(),
            paymobSdkListener = this,
        ).setButtonBackgroundColor(buttonBackgroundColor ?: Color.BLACK)
            .setButtonTextColor(buttonTextColor ?: Color.WHITE)
            .setAppName(appName)
            
            
        .build()
        paymobsdk.start()
        return
    }
    //PaymobSDK Return Values
    override fun onSuccess() {
        //If The Payment is Accepted
        SDKResult?.success("Successfull")
    }
    override fun onFailure() {
        //If The Payment is declined
        SDKResult?.success("Rejected")
    }
    override fun onPending() {
        //If The Payment is pending
        SDKResult?.success("Pending")
    }
     override fun onMethodCall(call: MethodCall, result: Result) {
    }
}