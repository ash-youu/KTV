//
//  HomeRecentWatchItemCell.swift
//  KTV
//
//  Created by 유연수 on 2024/08/12.
//

import UIKit

class HomeRecentWatchItemCell: UICollectionViewCell {
    
    static let identifier: String = "\(HomeRecentWatchItemCell.self)"
    static let itemSize: CGSize = .init(width: 84, height: 148)
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    private var imageTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setThumbnailImageView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetView()
    }
    
    private func setThumbnailImageView() {
        thumbnailImageView.layer.cornerRadius = 42
        thumbnailImageView.layer.borderWidth = 2
        thumbnailImageView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
    }
    
    private func resetView() {
        imageTask?.cancel()
        imageTask = nil
        thumbnailImageView.image = nil
        dateLabel.text = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    func setData(_ data: Home.Recent) {
        imageTask = thumbnailImageView.loadImage(url: data.imageUrl)
        
        let dateFormatter = DateFormatter().convertDateStyle()
        dateLabel.text = dateFormatter.string(from: .init(timeIntervalSince1970: data.timeStamp))
        
        titleLabel.text = data.title
        subtitleLabel.text = data.channel
    }
}
