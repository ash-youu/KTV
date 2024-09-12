//
//  LiveViewController.swift
//  KTV
//
//  Created by 유연수 on 2024/09/09.
//

import UIKit

class LiveViewController: UIViewController {
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var startTimeButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private let liveViewModel = LiveViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(named: "gray-2")?.cgColor
        
        liveViewModel.request(sort: .favorite)
        setupCollectionView()
        bindViewModel()
    }
    
    @IBAction func sortDidTap(_ sender: UIButton) {
        guard sender.isSelected == false else { return }
        
        favoriteButton.isSelected = sender == favoriteButton
        startTimeButton.isSelected = sender == startTimeButton
        favoriteButton.isSelected ?
        liveViewModel.request(sort: .favorite) : liveViewModel.request(sort: .start)
    }
    
    private func setupCollectionView() {
        collectionView.register(
            UINib(nibName: LiveCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LiveCell.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func bindViewModel() {
        liveViewModel.dataChanged = { [weak self] items in
            self?.collectionView.reloadData()
            
            if items.isEmpty == false {
                self?.collectionView.scrollToItem(
                    at: IndexPath(row: 0, section: 0),
                    at: .top,
                    animated: true
                )
            }
        }
    }
}

extension LiveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: LiveCell.height)
    }
}

extension LiveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveViewModel.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LiveCell.identifier,
            for: indexPath
        ) as? LiveCell,
              let data = liveViewModel.items?[indexPath.row] else { return UICollectionViewCell() }
        
        cell.setData(data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoVC = VideoViewController()
        videoVC.isLiveMode = true
        present(videoVC, animated: true)
    }
}
