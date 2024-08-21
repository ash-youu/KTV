//
//  HomeViewModel.swift
//  KTV
//
//  Created by 유연수 on 2024/08/15.
//

import Foundation

@MainActor class HomeViewModel {
    
    private(set) var home: Home?
    var dataChanged: (() -> Void)?
    
    func requestData() {
        Task {
            do {
                home = try await DataLoader.load(url: URLDefines.home, for: Home.self)
                self.dataChanged?()
            } catch {
                print("json parshing failed: \(error.localizedDescription)")
            }
        }
    }
}
