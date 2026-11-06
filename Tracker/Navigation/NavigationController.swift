import UIKit

final class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = .black
    }
}
