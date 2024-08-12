//
//  HomeRankingItemCell.swift
//  KTV
//
//  Created by 유연수 on 2024/08/12.
//

import UIKit

class HomeRankingItemCell: UICollectionViewCell {

    static let identifier: String = "\(HomeRankingItemCell.self)"
    
    @IBOutlet weak var ThumbnailImageView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        numberLabel.text = nil
    }

    func setRank(_ rank: Int) {
        numberLabel.text = "\(rank + 1)"
    }
}
