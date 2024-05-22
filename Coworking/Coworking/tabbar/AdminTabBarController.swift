//
//  AdminTabBarController.swift
//  Coworking
//
//  Created by Ramzan on 16.05.2024.
//

import Foundation
import UIKit

class AdminTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let adminVC = AdminViewController()
        adminVC.title = "Admin"
        let adminViewController = UINavigationController(rootViewController: adminVC)
        adminViewController.tabBarItem = UITabBarItem(title: "Admin", image: UIImage(systemName: "person.fill"), tag: 0)

        let myProfileVC = MyProfileViewController()
        myProfileVC.title = "My Profile"
        let myProfileNavigationController = UINavigationController(rootViewController: myProfileVC)
        myProfileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)

        let allCarsVC = AdminAllCarsViewController()
        allCarsVC.title = "All Cars"
        let allCarsViewController = UINavigationController(rootViewController: allCarsVC)
        allCarsViewController.tabBarItem = UITabBarItem(title: "All Cars", image: UIImage(systemName: "car"), tag: 2)

        let adminOrderVC = AdminOrdersViewController()
        adminOrderVC.title = "Orders"
        let adminOrdersViewController = UINavigationController(rootViewController: adminOrderVC)
        adminOrdersViewController.tabBarItem = UITabBarItem(title: "Orders", image: UIImage(systemName: "list.bullet"), tag: 3)

        viewControllers = [adminViewController, myProfileNavigationController, allCarsViewController, adminOrdersViewController]


       
        
        
        viewControllers = [adminViewController,myProfileNavigationController,allCarsViewController,adminOrdersViewController]
    }
}
