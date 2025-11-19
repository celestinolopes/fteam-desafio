import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)
    
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    let batteryChannel = FlutterMethodChannel(name: "com.example.fteamapp/battery",
                                              binaryMessenger: controller.binaryMessenger)
    
    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard call.method == "getBatteryLevel" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self.receiveBatteryLevel(result: result)
    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func receiveBatteryLevel(result: @escaping FlutterResult) {
     #if targetEnvironment(simulator)
    // No Simulator, retorna um valor simulado (75%) para fins de teste
    result(75)
    return
    #endif
    
     let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      let batteryLevel = device.batteryLevel
      let batteryState = device.batteryState
      
      // Verifica se o nível é válido (entre 0.0 e 1.0)
      if batteryLevel < 0.0 || batteryLevel > 1.0 || batteryState == UIDevice.BatteryState.unknown {
        result(FlutterError(code: "UNAVAILABLE",
                            message: "Nível da bateria não disponível.",
                            details: nil))
      } else {
        let level = Int(batteryLevel * 100)
        result(level)
      }
    }
  }
}
