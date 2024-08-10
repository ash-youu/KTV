//
//  TabBarViewController.swift
//  KTV
//
//  Created by 유연수 on 2024/08/10.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // 화면 회전 관련 설정 (회전 불가 설정)
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
