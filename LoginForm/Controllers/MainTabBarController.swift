//
//  MainTabBarController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 07.03.2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let firstViewController = tableController()
                
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        let secondViewController = tableStepController()

        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        let tabBarList = [firstViewController, secondViewController]

        viewControllers = tabBarList
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
