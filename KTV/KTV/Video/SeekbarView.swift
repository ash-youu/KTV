//
//  SeekbarView.swift
//  KTV
//
//  Created by 유연수 on 2024/09/05.
//

import UIKit

protocol SeekbarViewDelegate: AnyObject {
    func seekbar(_ seekbar: SeekbarView, seekToPercent percent: Double)
}

class SeekbarView: UIView {

    // 총 영상 길이
    @IBOutlet weak var totalPlayTimeView: UIView!
    private(set) var totalPlayTime: Double = 0
    
    // 재생 가능한 영상 길이
    @IBOutlet weak var playablePlayTimeView: UIView!
    @IBOutlet weak var playableTimeWidth: NSLayoutConstraint!
    private(set) var playableTime: Double = 0
    
    // 현재 영상 시청 시간
    @IBOutlet weak var currentPlayTimeView: UIView!
    @IBOutlet weak var playTimeWidth: NSLayoutConstraint!
    private(set) var currentPlayTime: Double = 0
    
    weak var delegate: SeekbarViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        totalPlayTimeView.layer.cornerRadius = 1
        playablePlayTimeView.layer.cornerRadius = 1
        currentPlayTimeView.layer.cornerRadius = 1
    }
    
    func setTotalPlayTime(_ totalPlayTime: Double) {
        self.totalPlayTime = totalPlayTime
        
        update()
    }
    
    func setPlayTime(_ playTime: Double, playableTime: Double) {
        self.currentPlayTime = playTime
        self.playableTime = playableTime
        
        update()
    }
    
    private func update() {
        guard totalPlayTime > 0 else { return }
        
        playableTimeWidth.constant = widthForTime(playableTime)
        playTimeWidth.constant = widthForTime(currentPlayTime)
        
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                // frame, bound, alpha 0~1
                // 위의 적용될 UI 변동사항이 바로 적용되도록 메서드 호출 
                self?.layoutIfNeeded()
            }
        )
    }
    
    // 시간에 따른 너비 구하기
    private func widthForTime(_ time: Double) -> CGFloat {
        return min(frame.width, frame.width * time / totalPlayTime)
    }
    
    // 터치 위치에 따른 너비 구하기
    private func widthForTouch(_ touch: UITouch) -> CGFloat {
        return min(touch.location(in: self).x, playableTimeWidth.constant)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        updatePlayedWidth(touch: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        updatePlayedWidth(touch: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        updatePlayedWidth(touch: touch)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        updatePlayedWidth(touch: touch)
    }
    
    private func updatePlayedWidth(touch: UITouch) {
        let xPosition = widthForTouch(touch)
        playTimeWidth.constant = xPosition
        
        delegate?.seekbar(self, seekToPercent: xPosition / frame.width)
    }
}
