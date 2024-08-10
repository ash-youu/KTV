//
//  HomeRecommendItemCell.swift
//  KTV
//
//  Created by 유연수 on 2024/08/10.
//

import UIKit

class HomeRecommendItemCell: UITableViewCell {

    static let height: CGFloat = 71
    static let identifier: String = "\(HomeRecommendItemCell.self)"
    
    @IBOutlet weak var thumbnailContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playTimeBGView: UIView!
    @IBOutlet weak var playTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    private func configureView() {
        thumbnailContainerView.layer.cornerRadius = 5
        rankLabel.layer.cornerRadius = 5
        rankLabel.clipsToBounds = true
        playTimeBGView.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
