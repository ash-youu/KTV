//
//  HomeRecentWatchItemCell.swift
//  KTV
//
//  Created by 유연수 on 2024/08/12.
//

import UIKit

class HomeRecentWatchItemCell: UICollectionViewCell {

    static let identifier: String = "\(HomeRecentWatchItemCell.self)"
    static let height: CGFloat = 209
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailImageView.layer.cornerRadius = 42
        thumbnailImageView.layer.borderWidth = 2
        thumbnailImageView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
    }
}
