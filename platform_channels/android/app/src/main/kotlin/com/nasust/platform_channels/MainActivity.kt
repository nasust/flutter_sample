package com.nasust.platform_channels

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.PluginRegistry

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        PlatformPlugin.registerWith(this.registrarFor("com.nasust.platform_channels.PlatformPlugin"))
    }
}

class PlatformPlugin(private val context: Context) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler, PluginRegistry.ActivityResultListener {
    companion object {
        private const val METHOD_CHANNEL = "com.nasust.platform_channels/method"
        private const val EVENT_CHANNEL = "com.nasust.platform_channels/event"

        fun registerWith(registrar: PluginRegistry.Registrar) {
            val channel = MethodChannel(registrar.messenger(), METHOD_CHANNEL)
            val instance = PlatformPlugin(registrar.activity()!!)

            channel.setMethodCallHandler(instance)

            val eventChannel = EventChannel(registrar.messenger(), EVENT_CHANNEL)
            eventChannel.setStreamHandler(instance)

            registrar.addActivityResultListener(instance)
        }
    }

    var mEventSink: EventChannel.EventSink? = null

    override fun onMethodCall(call: MethodCall?, result: MethodChannel.Result?) {
        Log.d("PlatformPlugin" , call?.toString() )
        when (call!!.method) {
            "helloWorld" -> {
                result?.success("Hello World Method Android")
                mEventSink?.success("Hello World Event Android")
            }
            else -> {
                result?.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {

        return false
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        mEventSink = events
    }

    override fun onCancel(arguments: Any?) {

    }


}