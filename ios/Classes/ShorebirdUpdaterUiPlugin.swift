import Flutter
import UIKit

public class ShorebirdUpdaterUiPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "shorebird_updater_ui", binaryMessenger: registrar.messenger())
        let instance = ShorebirdUpdaterUiPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "restartApp" {
            restartApp()
            result("App Restarted")
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func restartApp() {
        guard let window = UIApplication.shared.delegate?.window ?? nil else { return }
        let rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
