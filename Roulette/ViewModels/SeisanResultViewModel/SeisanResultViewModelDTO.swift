//  swiftlint:disable:this file_name
//  SeisanResultViewModelDTO.swift
//  Roulette
//
//  Created by sako0602 on 2024/02/17.
//

import Foundation

extension SeisanResultViewModel {
    struct SeisanDTO {
        let debtor: String
        let creditor: String
        let money: String

        init(debtor: String, creditor: String, money: String) {
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

        init(
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
            _ archivedWarikanGroupData: ArchivedWarikanGroupData,
            tatekaeUsecase: TatekaeUseCase,
            memberUsecase: MemberUseCase
        ) async throws -> Self {
            let name = archivedWarikanGroupData.groupName
            let tatekaes = try await tatekaeUsecase.get(
                ids: archivedWarikanGroupData.tatekaeList
            )
            let tatekaeList = tatekaes.map { $0.name }
            let totalAmount = tatekaes.reduce(0) { partialResult, tatekae in
                partialResult + tatekae.money
            }
            var unluckyMember: String?
            if let unluckyMemberID = archivedWarikanGroupData.unluckyMember {
                unluckyMember = try await memberUsecase.get(id: unluckyMemberID).name
            }
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
