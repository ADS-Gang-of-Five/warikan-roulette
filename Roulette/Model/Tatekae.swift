//
//  Tatekae.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/25.
//

import Foundation

struct Tatekae: Identifiable, Codable {
    var id: EntityID<Self>
    var name: String
    var payer: EntityID<Member>
    var recipients: [EntityID<Member>]
    var money: Int
}
