// swiftlint:disable:this file_name
//
//  MapToEntityExtensions.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/21
//  
//

import Foundation

extension [SeisanData] {
    func mapToEntity() -> [Seisan] {
        self.map { $0.convertToSeisan() }
    }
}
