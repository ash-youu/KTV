//
//  PlayerView.swift
//  KTV
//
//  Created by 유연수 on 2024/08/30.
//

import UIKit
import AVFoundation

protocol PlayerViewDelegate: AnyObject {
    
    func playerViewReadyToPlay(_ playerView: PlayerView)
    func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double)
    func playerViewDidFinishToPlay(_ playerView: PlayerView)
}

class PlayerView: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    weak var delegate: PlayerViewDelegate?
    
    // 재생 시간 추적
    private var playObservation: Any?
    
    // 재생 상태 추적
    private var statusObservation: NSKeyValueObservation?
    
    var avPlayerLayer: AVPlayerLayer? {
        self.layer as? AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            avPlayerLayer?.player
        } set {
            // set 메서드가 여러번 호출되어도 하나의 플레이어만 설정되도록 처리
            if let oldPlayer = avPlayerLayer?.player {
                unsetPlayer(player: oldPlayer)
            }
                
            avPlayerLayer?.player = newValue
            
            if let player = newValue {
                self.setup(player: player)
            }
        }
    }
    
    // 재생중 여부
    var isPlaying: Bool {
        guard let player else {
            return false
        }
        
        return player.rate != 0
    }
    
    // 총 재생시간
    var totalPlayTime: Double {
        player?.currentItem?.duration.seconds ?? 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNotification()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNotification()
    }
    
    func set(url: URL) {
        player = AVPlayer(
            // 재생되는 영상들의 아이템 단위
            playerItem: AVPlayerItem(
                asset: AVURLAsset(url: url)
            )
        )
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func seek(to percent: Double) {
        player?.seek(
            to: CMTime(seconds: percent * totalPlayTime, preferredTimescale: 1)
        )
    }
    
    func forward(to secods: Double = 10) {
        guard let currentTime = player?.currentItem?.currentTime().seconds else { return }
        
        player?.seek(
            to: CMTime(seconds: currentTime + secods, preferredTimescale: 1)
        )
    }
    
    func rewind(to secods: Double = 10) {
        guard let currentTime = player?.currentItem?.currentTime().seconds else { return }
        
        player?.seek(
            to: CMTime(seconds: currentTime - secods, preferredTimescale: 1)
        )
    }
}

extension PlayerView {
    private func setup(player: AVPlayer) {
        playObservation = player.addPeriodicTimeObserver(
            // 0.5초마다 observing 되도록
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 10),
            queue: .main,
            using: { [weak self] time in
                guard let self else { return }
                
                guard let currentItem = player.currentItem,
                      currentItem.status == .readyToPlay,
                      // 현재 재생 가능한 time range를 가져오기
                      let timeRange = (currentItem.loadedTimeRanges as? [CMTimeRange])?.first else { return }
                
                let playTime = time.seconds
                let playableTime = timeRange.start.seconds + timeRange.duration.seconds
                
                self.delegate?.playerView(self, didPlay: playTime, playableTime: playableTime)
            }
        )
        
        statusObservation = player.currentItem?.observe(
            \.status,
             changeHandler: { [weak self] item, _ in
                 guard let self else { return }
                 
                 switch item.status {
                 case .readyToPlay:
                     self.delegate?.playerViewReadyToPlay(self)
                 case .failed, .unknown:
                     print("failed to play \(item.error?.localizedDescription ?? "")")
                 // OS 업데이트로 알 수 없는 케이스가 추가되어 발생하는 경우
                 @unknown default:
                     print("failed to play \(item.error?.localizedDescription ?? "")")
                 }
             }
        )
    }
    
    private func unsetPlayer(player: AVPlayer) {
        statusObservation?.invalidate()
        statusObservation = nil
        
        if let playObservation {
            player.removeTimeObserver(playObservation)
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didPlayToEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }
    
    @objc private func didPlayToEnd(_ notification: Notification) {
        delegate?.playerViewDidFinishToPlay(self)
    }
}
