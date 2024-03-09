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
        let money: Int

        static func convert(_ seisanData: SeisanData) -> Self {
            let debtor = seisanData.debtor.name
            let creditor = seisanData.creditor.name
            let money = seisanData.money
            return SeisanDTO(debtor: debtor, creditor: creditor, money: money)
        }
    }

    struct ArchivedWarikanGroupDTO {
        let name: String
        let tatekaeList: [String]
        let totalAmount: Int
        let unluckyMember: String?
        let seisanList: [SeisanDTO]

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
                totalAmount: totalAmount,
                unluckyMember: unluckyMember,
                seisanList: seisanList
            )
        }
    }
}
