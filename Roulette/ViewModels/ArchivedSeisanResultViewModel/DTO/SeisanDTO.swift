//
//  SeisanDTO.swift
//  Roulette
//
//  Created by Masaki Doi on 2024/02/10.
//

import Foundation

struct SeisanDTO {
    let debtor: String
    let creditor: String
    let money: String

    private init(debtor: String, creditor: String, money: String) {
        self.debtor = debtor
        self.creditor = creditor
        self.money = money
    }

    static func convert(_ seisanData: SeisanData) -> Self {
        let debtor = seisanData.debtor.name
        let creditor = seisanData.creditor.name
        let money = seisanData.money.description
        return SeisanDTO(debtor: debtor, creditor: creditor, money: money)
    }
}
