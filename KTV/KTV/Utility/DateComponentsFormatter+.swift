//
//  DateComponentsFormatter+.swift
//  KTV
//
//  Created by 유연수 on 2024/08/15.
//

import Foundation

extension DateComponentsFormatter {
    func convertTimeStyle() -> DateComponentsFormatter {
        self.unitsStyle = .positional
        self.zeroFormattingBehavior = .pad
        self.allowedUnits = [.minute, .second]
        
        return self
    }
}
