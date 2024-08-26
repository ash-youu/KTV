//
//  HomeRecommendViewModel.swift
//  KTV
//
//  Created by 유연수 on 2024/08/21.
//

import Foundation

class HomeRecommendViewModel {
    
    private(set) var isFolded: Bool = true {
        didSet {
            foldChanged?(isFolded)
        }
    }
    
    var foldChanged: ((Bool) -> Void)?
    
    var recommends: [Home.VideoListItem]?
    var itemCount: Int {
        let count = isFolded ? 5 : recommends?.count ?? 0
        
        // 5개보다 적은 경우에 대한 방어 코드
        return min(recommends?.count ?? 0, count)
    }
    
    func toggleFoldState() {
        isFolded.toggle()
    }
}
