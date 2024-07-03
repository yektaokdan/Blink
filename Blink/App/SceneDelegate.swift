import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        window.rootViewController = createTabbar()
        window.overrideUserInterfaceStyle = .dark
        configureNavigationBar()
        self.window = window
    }
    
    func configureNavigationBar(){
        UINavigationBar.appearance().tintColor = .appPink
    }
    
    func createHomeNC() -> UINavigationController {
        let homeVC = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(systemName: "house"), tag: 1)

        // Logo'yu navigation bar'a eklemek için bir UIImageView oluşturun.
        let logoImage = UIImage(named: "letter-b") // Burada logo dosyanızın adını yazın.
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit

        // TitleView olarak ayarlayın.
        homeVC.navigationItem.titleView = imageView

        return UINavigationController(rootViewController: homeVC)
    }

    func createNewsNC() -> UINavigationController {
        let newsVC = NewsVC()
        newsVC.tabBarItem = UITabBarItem(title: "Haberler", image: UIImage(systemName: "newspaper"), tag: 0)
        return UINavigationController(rootViewController: newsVC)
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.tabBarItem = UITabBarItem(title: "Arama", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createTabbar() -> UITabBarController {
        let tabbar = UITabBarController()
        UITabBar.appearance().tintColor = .appPink
        tabbar.viewControllers = [createNewsNC(), createHomeNC(), createSearchNC()]
        return tabbar
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
