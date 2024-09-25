//
//  MoreViewController.swift
//  KTV
//
//  Created by 유연수 on 2024/08/29.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let moreViewModel = MoreViewModel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCornerRadius()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 48
        tableView.register(
            UINib(nibName: MoreTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: MoreTableViewCell.identifier)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupCornerRadius()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { [weak self] _ in
            self?.setupCornerRadius()
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func setupCornerRadius() {
        let path = UIBezierPath(
            roundedRect: headerView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 13, height: 13)
            )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        headerView.layer.mask = maskLayer
    }
    
    @IBAction func closeDidTap(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreViewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreTableViewCell.identifier, for: indexPath) as? MoreTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setItem(
            moreViewModel.items[indexPath.row],
            separatorHidden: indexPath.row == moreViewModel.items.count - 1
        )
        
        return cell
    }
}
