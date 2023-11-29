//
//  TabBarViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/6/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController()

        let firstVC = UINavigationController(rootViewController: CommunityViewController())
        let secondVC = UINavigationController(rootViewController: homeVC)
        let thirdVC = SettingViewController()
        
        firstVC.title = "Community"
        secondVC.title = "Home"
        thirdVC.title = "Setting"
        
        // 탭 바 컨트롤러에 ViewController들을 추가합니다.
        self.viewControllers = [firstVC, secondVC, thirdVC]
        self.selectedIndex = 1
    }

}
