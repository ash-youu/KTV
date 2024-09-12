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
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet var playerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var landscapeControlPannel: UIView!
    @IBOutlet weak var landscapePlayButton: UIButton!
    @IBOutlet weak var landscapeTitleLabel: UILabel!
    @IBOutlet weak var landscapePlaytime: UILabel!
    
    @IBOutlet weak var seekbarView: SeekbarView!
    
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
    
    @IBOutlet weak var chattingView: ChattingView!
    
    private let viewModel = VideoViewModel()
    private var isControlPannelHidden: Bool = true {
        didSet {
            if isLandscape(size: view.frame.size) {
                landscapeControlPannel.isHidden = isControlPannelHidden
            } else {
                portraitControlPannel.isHidden = isControlPannelHidden
            }
        }
    }
    
    var isLiveMode: Bool = false
    
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

        playerView.delegate = self
        seekbarView.delegate = self
        channelThumbnailImageView.layer.cornerRadius = 14
        setupRecommendTableView()
        bindViewModel()
        viewModel.request()
        
        chattingView.delegate = self
        
        if isLiveMode {
            chattingView.isHidden = false
        } else {
            chattingView.isHidden = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        chattingView.isHidden = true
        
        view.layoutIfNeeded()
        switchControlPannel(size: size)
        playerViewBottomConstraint.isActive = isLandscape(size: size)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func isLandscape(size: CGSize) -> Bool {
        size.width > size.height
    }
    
    private func bindViewModel() {
        viewModel.dataChangeHandler = { [weak self] in
            self?.setupData($0)
        }
    }
    
    private func setupData(_ video: Video) {
        playerView.set(url: video.videoURL)
        playerView.play()
        
        titleLabel.text = video.title
        landscapeTitleLabel.text = video.title
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
        if isLiveMode {
            chattingView.isHidden = false
        }
    }
}

extension VideoViewController {
    private func switchControlPannel(size: CGSize) {
        // 패널을 표시해야하는 상황이면
        guard isControlPannelHidden == false else { return }
        
        // 가로 모드가 아니면 가로 모드 컨트롤 패널 표시
        landscapeControlPannel.isHidden = !isLandscape(size: size)
        // 가로 모드면 세로 모드 컨트롤 패널 숨김
        portraitControlPannel.isHidden = isLandscape(size: size)
    }
    
    // 컨테이너뷰를 탭하면 영상 컨트롤 패널을 숨김/표시하도록
    @IBAction func toggleControlPannel(_ sender: UITapGestureRecognizer) {
        isControlPannelHidden.toggle()
    }
    
    @IBAction func closeDidTap(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func rewindDidTap(_ sender: UIButton) {
        playerView.rewind()
    }
    
    @IBAction func playDidTap(_ sender: UIButton) {
        if playerView.isPlaying {
            playerView.pause()
        } else {
            playerView.play()
        }
        
        updatePlayButton(isPlaying: playerView.isPlaying)
    }
    
    @IBAction func fastforwardDidTap(_ sender: UIButton) {
        playerView.forward()
    }
    
    @IBAction func moreDidTap(_ sender: UIButton) {
        let vc = MoreViewController()
        present(vc, animated: false)
    }
    
    @IBAction func expandDidTap(_ sender: UIButton) {
        rotateScene(landscape: true)
    }
    
    @IBAction func shrinkDidTap(_ sender: UIButton) {
        rotateScene(landscape: false)
    }
    
    private func updatePlayButton(isPlaying: Bool) {
        let playImage = isPlaying ? UIImage(named: "small_pause") : UIImage(named: "small_play")
        
        playButton.setImage(playImage, for: .normal)
        
        let landscapePlayImage = isPlaying ? UIImage(named: "big_pause") : UIImage(named: "big_play")
        
        landscapePlayButton.setImage(landscapePlayImage, for: .normal)
    }
    
    private func rotateScene(landscape: Bool) {
        if #available(iOS 16.0, *) {
            view.window?.windowScene?.requestGeometryUpdate(
                .iOS(interfaceOrientations: landscape ? .landscapeRight : .portrait)
            )
        } else {
            let orientation: UIInterfaceOrientation = landscape ? .landscapeRight : .portrait
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

extension VideoViewController: PlayerViewDelegate {
    func playerViewReadyToPlay(_ playerView: PlayerView) {
        seekbarView.setTotalPlayTime(playerView.totalPlayTime)
        updatePlayButton(isPlaying: playerView.isPlaying)
        updatePlayTime(0, totalPlayTime: playerView.totalPlayTime)
    }
    
    func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double) {
        seekbarView.setPlayTime(playTime, playableTime: playableTime)
        updatePlayTime(playTime, totalPlayTime: playerView.totalPlayTime)
    }
    
    func playerViewDidFinishToPlay(_ playerView: PlayerView) {
        // 재생이 끝나면 시간을 0으로 초기화
        playerView.seek(to: 0)
        updatePlayButton(isPlaying: false)
    }
    
    private func updatePlayTime(_ playTime: Double, totalPlayTime: Double) {
        guard let playTimeText = DateComponentsFormatter.playTimeFormatter.string(from: playTime),
              let totalPlayTimeText = DateComponentsFormatter.playTimeFormatter.string(from: totalPlayTime) else {
            landscapePlaytime.text = nil
            return
        }
        
        landscapePlaytime.text = "\(playTimeText) / \(totalPlayTimeText)"
    }
}

extension VideoViewController: SeekbarViewDelegate {
    func seekbar(_ seekbar: SeekbarView, seekToPercent percent: Double) {
        playerView.seek(to: percent)
    }
}

extension VideoViewController: ChattingViewDelegate {
    func liveChattingViewCloseDidTap(_ chattingView: UIView) {
        chattingView.isHidden = true
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
