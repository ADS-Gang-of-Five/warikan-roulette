//
//  Tatekae.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/25.
//

import Foundation

struct Tatekae: Identifiable, Codable {
    var id = UUID()
    var name: String
    var payer: Member
    var recipients: [Member]
    var money: Int
}
