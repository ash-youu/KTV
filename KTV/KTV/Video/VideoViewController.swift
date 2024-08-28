//
//  VideoViewController.swift
//  KTV
//
//  Created by 유연수 on 2024/08/28.
//

import UIKit

class VideoViewController: UIViewController {

    // MARK: - 제어 패널
    @IBOutlet weak var portraitControlPannel: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - scrollView
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!

    @IBOutlet weak var channelThumbnailImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    
    @IBOutlet weak var recommendTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    private var contentSizeObservation: NSKeyValueObservation?
    
    private let viewModel = VideoViewModel()
    private var isControlPannelHidden: Bool = true {
        didSet {
            portraitControlPannel.isHidden = isControlPannelHidden
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.convertDateVideoViewStyle()
        
        return dateFormatter
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        channelThumbnailImageView.layer.cornerRadius = 14
        setupRecommendTableView()
        bindViewModel()
        viewModel.request()
    }
    
    private func bindViewModel() {
        viewModel.dataChangeHandler = { [weak self] in
            self?.setupData($0)
        }
    }
    
    private func setupData(_ video: Video) {
        titleLabel.text = video.title
        channelThumbnailImageView.loadImage(url: video.channelImageUrl)
        channelNameLabel.text = video.channel
        updateDateLabel.text = VideoViewController.dateFormatter.string(
            from: Date(timeIntervalSince1970: video.uploadTimestamp)
        )
        playCountLabel.text = "재생수 \(video.playCount)"
        favoriteButton.setTitle("\(video.favoriteCount)", for: .normal)
        recommendTableView.reloadData()
    }
    
    @IBAction func commentDidTap(_ sender: UIButton) {
    }
}

extension VideoViewController {
    @IBAction func toggleControlPannel(_ sender: UITapGestureRecognizer) {
        isControlPannelHidden.toggle()
    }
    
    @IBAction func closeDidTap(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func rewindDidTap(_ sender: UIButton) {
    }
    
    @IBAction func playDidTap(_ sender: UIButton) {
    }
    
    @IBAction func fastforwardDidTap(_ sender: UIButton) {
    }
    
    @IBAction func moreDidTap(_ sender: UIButton) {
        let vc = MoreViewController()
        present(vc, animated: false)
    }
    
    @IBAction func expandDidTap(_ sender: UIButton) {
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupRecommendTableView() {
        recommendTableView.delegate = self
        recommendTableView.dataSource = self
        recommendTableView.rowHeight = VideoListItemCell.height
        recommendTableView.register(
            UINib(nibName: VideoListItemCell.identifier, bundle: nil),
            forCellReuseIdentifier: VideoListItemCell.identifier)
        
        contentSizeObservation = recommendTableView.observe(
            \.contentSize,
             changeHandler: { [weak self] tableView, _ in
                 self?.tableViewHeightConstraint.constant = tableView.contentSize.height
             }
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.video?.recommends.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: VideoListItemCell.identifier,
            for: indexPath
        )
        
        if let cell = cell as? VideoListItemCell,
           let data = viewModel.video?.recommends[indexPath.row] {
            cell.setData(data, rank: data.videoId - 1)
        }
        
        return cell
    }
}
