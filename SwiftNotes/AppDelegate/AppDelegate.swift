import UIKit
import RealmSwift
import CleanroomLogger
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    let storyboards = StoryboardServiceImpl()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Don't setup views when testing
        if NSClassFromString("XCTestCase") != nil {
            return true
        }
        setupUiTesting()
        setupLogging()
        setupStyle()
        setupCoordinators()
        
        return true
    }

    func setupUiTesting() {
        guard ProcessInfo.processInfo.arguments.contains("testingResetAll") else { return }
        // we are UI testing the app - reset to initial state (delete realm databases)
        
        Log.warning?.message("UI Testing - resetting to initial state")
        if let realmURL = Realm.Configuration.defaultConfiguration.fileURL {
            let realmURLs = [
                realmURL,
                realmURL.appendingPathExtension("lock"),
                realmURL.appendingPathExtension("note"),
                realmURL.appendingPathExtension("management")
            ]
            for url in realmURLs {
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    Log.info?.message("Error deleting db item:", url.path)
                }
            }
        }
    
        // and disable animations
        UIView.setAnimationsEnabled(false)
    }
    
    static var loggingSetUp = false
    func setupLogging() {
        guard !AppDelegate.loggingSetUp, let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            Log.debug?.message("Logging was already set up")
            return
        }
        
        let logsDirectory = path.appendingPathComponent("logs", isDirectory: true)
        try? FileManager.default.createDirectory(at: logsDirectory, withIntermediateDirectories: true, attributes: nil)
        try? FileManager.default.setAttributes([FileAttributeKey.protectionKey: FileProtectionType.none], ofItemAtPath: logsDirectory.path)
        
        Log.enable(configuration: [XcodeLogConfiguration(minimumSeverity: .debug,
                                                         debugMode: false,
                                                         verboseDebugMode: false,
                                                         stdStreamsMode: .useAsFallback,
                                                         mimicOSLogOutput: true,
                                                         showCallSite: true,
                                                         filters: []),
                                   RotatingLogFileConfiguration(minimumSeverity: .debug,
                                                                daysToKeep: 7,
                                                                directoryPath: logsDirectory.path)])
        AppDelegate.loggingSetUp = true
        Log.debug?.message("Logging has been set up.")
    }
    
    func setupStyle() {
        UIFont.overrideInitialize()
        SVProgressHUD.setDefaultMaskType(.clear)
    }

    func setupCoordinators() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let router = AppDelegateRouter(window: window)
        let coordinator = AppCoordinator(router: router, storyboards: storyboards)
        appCoordinator = coordinator
        coordinator.present(animated: false, onDismissed: nil)
    }
}
