//
//  HomeVideoCell.swift
//  KTV
//
//  Created by 유연수 on 2024/08/08.
//

import UIKit

class HomeVideoCell: UITableViewCell {
    
    static let identifier: String = "\(HomeVideoCell.self)"
    static let height: CGFloat = 320
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumnailImageView: UIImageView!
    @IBOutlet weak var hotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var channelSubtitleLabel: UILabel!
    
    private var thumbnailTask: Task<Void, Never>?
    private var channelThumbnailTask: Task<Void, Never>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setContainerView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetView()
    }
    
    private func setContainerView() {
        containerView.layer.cornerRadius = 10
        containerView.layer.borderColor = UIColor(named: "stroke-light")?.cgColor
        containerView.layer.borderWidth = 1
        containerView.clipsToBounds = true
    }
    
    private func resetView() {
        thumbnailTask?.cancel()
        thumbnailTask = nil
        thumnailImageView.image = nil
        channelThumbnailTask?.cancel()
        channelThumbnailTask = nil
        channelImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        channelTitleLabel.text = nil
        channelSubtitleLabel.text = nil
    }
    
    func setData(_ data: Home.Video) {
        hotImageView.isHidden = !data.isHot
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        channelTitleLabel.text = data.channel
        channelSubtitleLabel.text = data.channelDescription
        thumbnailTask = thumnailImageView.loadImage(url: data.imageUrl)
        channelThumbnailTask = channelImageView.loadImage(url: data.channelThumbnailURL)
    }
}
