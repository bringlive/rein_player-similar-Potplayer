import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private static let FILE_CHANNEL = "com.reinplayer/file_handler"
  private var pendingFilePaths: [String] = []
  
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    
    // Send any pending files that were opened before Flutter was ready
    if !pendingFilePaths.isEmpty {
      sendFilesToFlutter(filePaths: pendingFilePaths)
      pendingFilePaths.removeAll()
    }
  }
  
  override func application(_ application: NSApplication, open urls: [URL]) {
    let filePaths = urls.map { $0.path }
    
    // Try to send immediately if Flutter is ready
    if let controller = mainFlutterWindow?.contentViewController as? FlutterViewController {
      let fileChannel = FlutterMethodChannel(
        name: AppDelegate.FILE_CHANNEL,
        binaryMessenger: controller.engine.binaryMessenger
      )
      fileChannel.invokeMethod("openFiles", arguments: filePaths)
    } else {
      // Flutter not ready yet, store for later
      pendingFilePaths.append(contentsOf: filePaths)
    }
  }
  
  private func sendFilesToFlutter(filePaths: [String]) {
    if let controller = mainFlutterWindow?.contentViewController as? FlutterViewController {
      let fileChannel = FlutterMethodChannel(
        name: AppDelegate.FILE_CHANNEL,
        binaryMessenger: controller.engine.binaryMessenger
      )
      fileChannel.invokeMethod("openFiles", arguments: filePaths)
    }
  }
}
