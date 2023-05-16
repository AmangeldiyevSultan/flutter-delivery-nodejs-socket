import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let envFile = Bundle.main.path(forResource: ".env", ofType: nil)
    DotEnv.withOptions(override: true, allowEmptyValues: true).load(filepath: envFile)
    let apiKey = DotEnv.env["GMAP_API_KEY"]
    GMSServices.provideAPIKey(apiKey)  
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
