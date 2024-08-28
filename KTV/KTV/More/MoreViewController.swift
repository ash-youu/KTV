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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 48
        tableView.register(
            UINib(nibName: MoreTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: MoreTableViewCell.identifier)
    }

    @IBAction func closeDidTap(_ sender: UIButton) {
        dismiss(animated: false)
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
