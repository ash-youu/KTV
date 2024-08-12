//
//  LoginViewController.swift
//  KTV
//
//  Created by 유연수 on 2024/07/27.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    // 화면 회전 관련 설정 (회전 불가 설정)
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoginButton()
    }

    private func configureLoginButton() {
        loginButton.layer.cornerRadius = 19
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(named: "main-brown")?.cgColor
    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        self.view.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
    }
}
