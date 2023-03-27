import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase
    FirebaseApp.configure()
    
    GeneratedPluginRegistrant.register(with: self)
    // TODO: Add your API key
    GMSServices.provideAPIKey("AIzaSyAb2LHshhIMMR9p7_7O-19hGOR2zlKyoxY")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
