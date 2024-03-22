import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    private func setupViewControllers() {
        let timeSettingVC = TimeSettingViewController()
        timeSettingVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))

        let catsHistoryVC = UIViewController() // Замените UIViewController на ваш контроллер истории котов
        catsHistoryVC.tabBarItem = UITabBarItem(title: "История", image: UIImage(systemName: "clock"), selectedImage: UIImage(systemName: "clock.fill"))
        catsHistoryVC.view.backgroundColor = .white

        viewControllers = [timeSettingVC, catsHistoryVC]
    }
}
