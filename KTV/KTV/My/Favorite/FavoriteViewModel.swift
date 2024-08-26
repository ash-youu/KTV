//
//  FavoriteViewModel.swift
//  KTV
//
//  Created by 유연수 on 2024/08/23.
//

import Foundation

@MainActor class FavoriteViewModel {
    
    private(set) var favorites: [Home.VideoListItem]?
    var dataChanged: (() -> Void)?
    
    func requestData() {
        Task {
            do {
                let favorite = try await DataLoader.load(url: URLDefines.favorite, for: Favorite.self)
                favorites = favorite.list
                dataChanged?()
            } catch {
                print("json parshing failed: \(error.localizedDescription)")
            }
        }
    }
}
