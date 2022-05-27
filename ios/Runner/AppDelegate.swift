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
    GMSServices.provideAPIKey("AIzaSyBPZEzgCu_1VreQPng2GBhggN_IPrQqKig")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
  }
}
