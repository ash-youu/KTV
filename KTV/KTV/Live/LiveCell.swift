//
//  LiveCell.swift
//  KTV
//
//  Created by 유연수 on 2024/09/09.
//

import UIKit

class LiveCell: UICollectionViewCell {

    static let height: CGFloat = 76
    static let identifier: String = "\(LiveCell.self)"
    
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        liveLabel.layer.cornerRadius = 5
        liveLabel.clipsToBounds = true
        imageView.layer.cornerRadius = 5
    }
}
