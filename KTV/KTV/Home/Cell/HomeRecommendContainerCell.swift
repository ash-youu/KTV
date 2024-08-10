//
//  HomeRecommendContainerCell.swift
//  KTV
//
//  Created by 유연수 on 2024/08/10.
//

import UIKit

protocol HomeRecommendContainerCellDelegate: AnyObject {
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int)
}

class HomeRecommendContainerCell: UITableViewCell {

    static let identifier: String = "\(HomeRecommendContainerCell.self)"
    
    static var height: CGFloat {
        let top: CGFloat = 84 - 6 // cell의 상단 여백
        let bottom: CGFloat = 68 - 6 // cell의 하단 여백
        let footerInset: CGFloat = 51 // container -> footer 까지의 여백
        return HomeRecommendItemCell.height * 5 + top + bottom + footerInset
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var foldButton: UIButton!
    
    weak var delegate: HomeRecommendContainerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
        setupTableView()
    }
    
    private func configureView() {
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
    }
    
    private func setupTableView() {
        tableView.rowHeight = HomeRecommendItemCell.height
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: HomeRecommendItemCell.identifier, bundle: .main),
            forCellReuseIdentifier: HomeRecommendItemCell.identifier
        )
    }
    
    @IBAction func foldButtonDidTap(_ sender: UIButton) {
    }
}
 
extension HomeRecommendContainerCell: UITableViewDelegate { }

extension HomeRecommendContainerCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: HomeRecommendItemCell.identifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.homeRecommendContainerCell(self, didSelectItemAt: indexPath.row)
    }
}
