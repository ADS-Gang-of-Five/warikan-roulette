//
//  Tatekae.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/25.
//

import Foundation

struct Tatekae: Identifiable, Codable {
    var id = UUID()
    let payer: Member
    let recipients: [Member]
    let money: Int
}
