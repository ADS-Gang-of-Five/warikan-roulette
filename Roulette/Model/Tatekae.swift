//
//  Tatekae.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/25.
//

import Foundation

struct Tatekae: Identifiable, Codable {
    // TODO: IDの発行はリポジトリで行う
    var id: EntityID<Self> = .init(value: UUID().uuidString)
    var name: String
    var payer: EntityID<Member>
    var recipients: [EntityID<Member>]
    var money: Int
}
