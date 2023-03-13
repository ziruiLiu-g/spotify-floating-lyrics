import Cocoa
import FlutterMacOS
import bitsdojo_window_macos
import window_manager

class MainFlutterWindow: BitsdojoWindow {
// class MainFlutterWindow: NSWindow {
  override func bitsdojo_window_configure() -> UInt {
    return BDW_CUSTOM_FRAME
  }

  override func awakeFromNib() {

    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    super.awakeFromNib()
  }
}

// class MainFlutterWindow: NSWindow {
//
//   override func awakeFromNib() {
//     let flutterViewController = FlutterViewController.init()
//     let windowFrame = self.frame
//     self.contentViewController = flutterViewController
//     self.setFrame(windowFrame, display: true)
//
//     RegisterGeneratedPlugins(registry: flutterViewController)
//   }
// }
