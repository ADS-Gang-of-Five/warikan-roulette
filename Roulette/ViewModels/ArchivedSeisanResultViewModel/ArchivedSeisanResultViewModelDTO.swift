// swiftlint:disable:this file_name
//
//  ArchivedSeisanResultViewModelDTO.swift
//  Roulette
//
//  Created by Masaki Doi on 2024/02/10.
//

import Foundation

extension ArchivedSeisanResultViewModel {
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

    struct ArchivedWarikanGroupDTO {
        let name: String
        let tatekaeList: [String]
        let totalAmount: String
        let unluckyMember: String?
        let seisanList: [SeisanDTO]

        private init(
            name: String,
            tatekaeList: [String],
            totalAmount: String,
            unluckyMember: String?,
            seisanList: [SeisanDTO]
        ) {
            self.name = name
            self.tatekaeList = tatekaeList
            self.totalAmount = totalAmount
            self.unluckyMember = unluckyMember
            self.seisanList = seisanList
        }

        static func convert(
            _ archivedWarikanGroupData: ArchivedWarikanGroupData
        ) async throws -> Self {
            let name = archivedWarikanGroupData.groupName
            let tatekaes = archivedWarikanGroupData.tatekaeList
            let tatekaeList = tatekaes.map { $0.name }
            let totalAmount = tatekaes.reduce(0) { partialResult, tatekae in
                partialResult + tatekae.money
            }
            let unluckyMember = archivedWarikanGroupData.unluckyMember?.name
            let seisanList = archivedWarikanGroupData.seisanList.map {
                SeisanDTO.convert($0)
            }
            return ArchivedWarikanGroupDTO(
                name: name,
                tatekaeList: tatekaeList,
                totalAmount: totalAmount.description,
                unluckyMember: unluckyMember,
                seisanList: seisanList
            )
        }
    }
}
