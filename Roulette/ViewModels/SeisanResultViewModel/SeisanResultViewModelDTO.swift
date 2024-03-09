//  swiftlint:disable:this file_name
//  SeisanResultViewModelDTO.swift
//  Roulette
//
//  Created by sako0602 on 2024/02/17.
//

import Foundation

extension SeisanResultView {
    struct ArchivedWarikanGroupDTO {
        let name: String
        let tatekaeList: [String]
        let totalAmount: Int
        let unluckyMember: String?
        let seisanList: [SeisanDTO]
        
        struct SeisanDTO {
            let debtor: String
            let creditor: String
            let money: Int
        }
    }
}
