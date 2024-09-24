//
//  HomeViewModel.swift
//  KTV
//
//  Created by 유연수 on 2024/08/15.
//

import Foundation

@MainActor class HomeViewModel {
    
    private(set) var home: Home?
    let recommendViewModel = HomeRecommendViewModel()
    var dataChanged: (() -> Void)?
    
    func requestData() {
        Task {
            do {
//                home = try await DataLoader.load(url: URLDefines.home, for: Home.self)
                let home = try DataLoader.load(json: "home", for: Home.self)
                self.home = home
                recommendViewModel.recommends = home.recommends
                dataChanged?()
            } catch {
                print("json parshing failed: \(error.localizedDescription)")
            }
        }
    }
}
