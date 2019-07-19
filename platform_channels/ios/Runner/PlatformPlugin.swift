//
//  PlatformPlugin.swift
//  Runner
//
//  Created by Hideki Mori on 2019/07/17.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

public class PlatformPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

    private static let METHOD_CHANNEL = "com.nasust.platform_channels/method"
    private static let EVENT_CHANNEL = "com.nasust.platform_channels/event"

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: METHOD_CHANNEL, binaryMessenger: registrar.messenger())
        let stream = FlutterEventChannel(name: EVENT_CHANNEL, binaryMessenger: registrar.messenger())

        let instance = PlatformPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        stream.setStreamHandler(instance)
        
        registrar.addApplicationDelegate(instance)
    }

    private var eventSink: FlutterEventSink?

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        NSLog(call.method);
        if call.method == "helloWorld" {
            result("Hello World Method iOS")
            self.eventSink?("Hello World Event iOS");
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }

    public func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return true
    }
}

