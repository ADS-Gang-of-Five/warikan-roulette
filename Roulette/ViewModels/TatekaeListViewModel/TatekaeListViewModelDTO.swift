// swiftlint:disable:this file_name
//
//  TatekaeListViewModelDTO.swift
//  Roulette
//
//  Created by Masaki Doi on 2024/02/13.
//

import Foundation

extension TatekaeListViewModel {
    struct TatekaeDTO: Identifiable {
        let id: EntityID<Tatekae>
        let name: String
        let money: String
        let createdTime: String

        init(id: EntityID<Tatekae>, name: String, money: String, createdTime: String) {
            self.id = id
            self.name = name
            self.money = money
            self.createdTime = createdTime
        }

        static func convert(_ tatekae: TatekaeData, dateFormatter: DateFormatter) -> Self {
            Self.init(
                id: tatekae.id,
                name: tatekae.name,
                money: tatekae.money.description,
                createdTime: dateFormatter.string(from: tatekae.createdTime)
            )
        }
    }
}
