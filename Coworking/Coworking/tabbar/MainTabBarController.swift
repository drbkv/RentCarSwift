


import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myProfileVC = MyProfileViewController()
              myProfileVC.title = "My Profile"
              let myProfileNavigationController = UINavigationController(rootViewController: myProfileVC)
              myProfileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 0)

              let allCarsVC = AllCarsViewController()
              allCarsVC.title = "All Cars"
              let allCarsViewController = UINavigationController(rootViewController: allCarsVC)
              allCarsViewController.tabBarItem = UITabBarItem(title: "All Cars", image: UIImage(systemName: "car"), tag: 1)

              let freeCarsVC = FreeCarsViewController()
              freeCarsVC.title = "Free Cars"
              let freeCarsViewController = UINavigationController(rootViewController: freeCarsVC)
              freeCarsViewController.tabBarItem = UITabBarItem(title: "Free Cars", image: UIImage(systemName: "car.fill"), tag: 2)
        
       
        
        

        viewControllers = [myProfileNavigationController,allCarsViewController,freeCarsViewController]
    }
}
