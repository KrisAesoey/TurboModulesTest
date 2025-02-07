import React
import ReactAppDependencyProvider
import React_RCTAppDelegate
import UIKit
import RTNCalculator

@main
class AppDelegate: RCTAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication
      .LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    self.moduleName = "TurboModulesTest"
    self.dependencyProvider = RCTAppDependencyProvider()

    // You can add your custom initial props in the dictionary below.
    // They will be passed down to the ViewController used by React Native.
    self.initialProps = [:]

    UIApplication.shared.shortcutItems = [
      UIApplicationShortcutItem(
        type: "Kentorama", localizedTitle: "Kent var her!"),
      UIApplicationShortcutItem(
        type: "Kristorama", localizedTitle: "Kristoffer var her!"),
    ]

    return super.application(
      application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) {
    //self.quickActions.performAction(action: shortcutItem)

    // RNShortcuts.performAction(for: shortcutItem, completionHandler: completionHandler)
  }

  override func sourceURL(for bridge: RCTBridge) -> URL? {
    self.bundleURL()
  }

  override func bundleURL() -> URL? {
    #if DEBUG
      RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
    #else
      Bundle.main.url(forResource: "main", withExtension: "jsbundle")
    #endif
  }
}
