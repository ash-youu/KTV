//
//  DateFormatter+.swift
//  KTV
//
//  Created by 유연수 on 2024/08/15.
//

import Foundation

extension DateFormatter {
    @discardableResult
    func convertDateStyle() -> DateFormatter {
        self.dateFormat = "YYMMDD."
        
        return self
    }
    
    @discardableResult
    func convertDateVideoViewStyle() -> DateFormatter {
        self.dateFormat = "yyyy.MM.dd"
        
        return self
    }
}
