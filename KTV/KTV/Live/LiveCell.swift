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
    @IBOutlet weak var channelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        liveLabel.layer.cornerRadius = 5
        liveLabel.clipsToBounds = true
        imageView.layer.cornerRadius = 5
    }
    
    func setData(_ data: Live.Item) {
        imageView.loadImage(url: data.thumbnailUrl)
        titleLabel.text = data.title
        channelLabel.text = data.channel
    }
}
