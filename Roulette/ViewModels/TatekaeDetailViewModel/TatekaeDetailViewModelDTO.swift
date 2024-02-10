// swiftlint:disable:this file_name
//
//  TatekaeDetailViewModelDTO.swift
//  Roulette
//
//  Created by Masaki Doi on 2024/02/10.
//

import Foundation

extension TatekaeDetailViewModel {
    struct TatekaeDTO {
        let name: String
        let money: String
        let createdTime: String

        private init(name: String, money: String, createdTime: String) {
            self.name = name
            self.money = money
            self.createdTime = createdTime
        }

        static func convert(_ tatekae: Tatekae) -> Self {
            let name = tatekae.name
            let money = String(tatekae.money)
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar.autoupdatingCurrent
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            let createdTime = dateFormatter.string(from: tatekae.createdTime)
            return Self.init(name: name, money: money, createdTime: createdTime)
        }
    }
}
