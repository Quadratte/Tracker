import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let trackerVC = TrackerViewController()
        let statisticsVC = StatisticsViewController()
        
        trackerVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle"),
            tag: 0
        )
        
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare"),
            tag: 1
        )
        
        let trackerNC = NavigationController(rootViewController: trackerVC)
        let statisticsNC = NavigationController(rootViewController: statisticsVC)
        
        let controllers = [trackerNC, statisticsNC]
        setViewControllers(controllers, animated: true)
    }
}
