import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    //MARK: Google Maps setup
    GMSServices.provideAPIKey("AIzaSyAOs8RWZcuMlvrR9lrWH4-rV7_U2Oj0y-Q")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
  }
}
