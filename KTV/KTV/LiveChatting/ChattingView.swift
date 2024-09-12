//
//  ChattingView.swift
//  KTV
//
//  Created by 유연수 on 2024/09/10.
//

import UIKit

protocol ChattingViewDelegate: AnyObject {
    func liveChattingViewCloseDidTap(_ chattingView: UIView)
}

class ChattingView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: ChattingViewDelegate?
    
    private let viewModel = ChattingViewModel()
    
    override var isHidden: Bool {
        didSet {
            toggleViewModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        setupTextField()
        toggleViewModel()
        bindViewModel()
    }
    
    @IBAction func closeDidTap() {
        textField.resignFirstResponder()
        delegate?.liveChattingViewCloseDidTap(self)
    }
    
    private func bindViewModel() {
        viewModel.chatReceived = { [weak self] in
            self?.collectionView.reloadData()
            self?.scrollToLatestIfNeeded()
        }
    }
    
    private func toggleViewModel() {
        if isHidden {
            viewModel.stop()
        } else {
            viewModel.start()
        }
    }
    
    private func scrollToLatestIfNeeded() {
        // UI 기준 가장 아래쪽의 Y값 >= 컨텐츠 사이즈보다 같거나 넘어서면 가장 하단까지 갔음을 알 수 있다.
        let isBottomOffset = collectionView.bounds.maxY >= collectionView.contentSize.height
        let isLastMessageMine = viewModel.messages.last?.isMine == true
        
        if isBottomOffset || isLastMessageMine {
            collectionView.scrollToItem(
                at: IndexPath(item: viewModel.messages.count - 1, section: 0),
                at: .bottom,
                animated: true
            )
        }
    }
    
    private func setupTextField() {
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: "채팅에 참여하세요.",
            attributes: [
                .foregroundColor: UIColor(named: "chat-text") ?? .clear,
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
        )
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: LiveChattingMessageCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LiveChattingMessageCollectionViewCell.identifier
        )
        
        collectionView.register(
            UINib(nibName: LiveChattingMyMessageCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LiveChattingMyMessageCollectionViewCell.identifier
        )
    }
}

// MARK: - UICollectionViewDelegate / DataSource
extension ChattingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = viewModel.messages[indexPath.row]
        let width = collectionView.frame.width - 32
        
        if item.isMine {
            return LiveChattingMyMessageCollectionViewCell.size(width: width, text: item.text)
        } else {
            return LiveChattingMessageCollectionViewCell.size(width: width, text: item.text)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension ChattingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.messages[indexPath.row]
        
        if item.isMine {
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LiveChattingMyMessageCollectionViewCell.identifier,
                for: indexPath
            ) as? LiveChattingMyMessageCollectionViewCell {
                cell.setText(item.text)
                
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LiveChattingMessageCollectionViewCell.identifier,
                for: indexPath
            ) as? LiveChattingMessageCollectionViewCell {
                cell.setText(item.text)
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UITextFieldDelegate
extension ChattingView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        
        viewModel.sendMessage(text)
        textField.text = nil
        
        return true
    }
}
