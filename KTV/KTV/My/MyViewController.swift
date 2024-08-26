//
//  MyViewController.swift
//  KTV
//
//  Created by 유연수 on 2024/08/23.
//

import UIKit

class MyViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       configureView()
    }
    
    private func configureView() {
        profileImageView.layer.cornerRadius = 5
    }
    
    @IBAction func bookmarkDidTap(_ sender: UIButton) {
        performSegue(withIdentifier: "bookmark", sender: self)
    }
    
    @IBAction func favoriteDidTap(_ sender: UIButton) {
        performSegue(withIdentifier: "favorite", sender: self)
    }
}
