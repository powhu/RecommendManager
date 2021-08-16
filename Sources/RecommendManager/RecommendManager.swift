import UIKit
import StoreKit

struct App {
    var name: String
    var info: String
    var icon: UIImage
    var urlSceme: String
    var appId: String
    var isInstalled: Bool {
        UIApplication.shared.canOpenURL(URL(string: "\(urlSceme)://")!)
    }
    var itemsUrl: URL {
        return URL(string: "itms-apps://itunes.apple.com/app/id\(appId)?mt=8")!
    }
    var openAppUrl: URL {
        return URL(string: "\(urlSceme)://")!
    }
    
    static let yidget = App(name: "Yidget",
                            info: NSLocalizedString("Yidget: Transparent widget", bundle: .module, comment: ""),
                            icon: UIImage(named: "yidget", in: .module, with: nil)!,
                            urlSceme: "yidget",
                            appId: "1532848312")
    static let yome2x = App(name: "Yome2x",
                            info: NSLocalizedString("Yome2x: Waifu2x for iOS", bundle: .module, comment: ""),
                            icon: UIImage(named: "yome2x", in: .module, with: nil)!,
                            urlSceme: "yome2x",
                            appId: "1511677178")
    static let yahaLive = App(name: "YahaLive",
                              info: NSLocalizedString("YahaLive: Live wallper creator", bundle: .module, comment: ""),
                              icon: UIImage(named: "yahayome", in: .module, with: nil)!,
                              urlSceme: "com.moriran.YahaYome",
                              appId: "1205848268")
    static let tweetFly = App(name: "TweetFly",
                              info: NSLocalizedString("TweetFly: Make your Twitter posts more fun!", bundle: .module, comment: ""),
                              icon: UIImage(named: "tweetfly", in: .module, with: nil)!,
                              urlSceme: "tweetfly",
                              appId: "1515218388")
    static let sengaChan = App(name: "SengaChan",
                               info: NSLocalizedString("SengaChan: Anime to Sketch", bundle: .module, comment: ""),
                               icon: UIImage(named: "sengachan", in: .module, with: nil)!,
                               urlSceme: "SengaChan",
                               appId: "1566769001")
    static let ycon = App(name: "Ycon",
                               info: NSLocalizedString("Ycon: Icon Customizer", bundle: .module, comment: ""),
                               icon: UIImage(named: "ycon", in: .module, with: nil)!,
                               urlSceme: "ycon",
                               appId: "1580644229")
}

class RecommendAppManager {
    
    static let shared = RecommendAppManager()
    private(set) var presentCount = 0
    private lazy var storeViewController = SKStoreProductViewController()
    var maxPresentCount = 2
    
    let apps = [
        App.ycon,
        App.yome2x,
        App.yidget,
        App.yahaLive,
        App.sengaChan,
        App.tweetFly
    ]
    
    var recommendApps: [App] {
        return apps.filter { !$0.isInstalled }
    }
    
    func presntOverlay(in scene: UIWindowScene, app: App) {
        guard maxPresentCount > presentCount else { return }
        let config = SKOverlay.AppConfiguration(appIdentifier: app.appId, position: .bottom)
        let overlay = SKOverlay(configuration: config)
        overlay.present(in: scene)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            SKOverlay.dismiss(in: scene)
        }
        presentCount += 1
    }
    
    func randomPresentOverlay(in scene: UIWindowScene) {
        guard let app = recommendApps.randomElement() else { return }
        presntOverlay(in: scene, app: app)
    }
    
    func dismissOverlay(in scene: UIWindowScene) {
        SKOverlay.dismiss(in: scene)
    }
    
    func presentStore(in viewController: UIViewController, app: App) {
        storeViewController
            .loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: app.appId]) { [weak viewController, unowned self] succeed, _ in
                if succeed {
                    viewController?.present(self.storeViewController, animated: true)
                } else {
                    UIApplication.shared.open(app.itemsUrl, options: [:])
                }
        }
    }
}
