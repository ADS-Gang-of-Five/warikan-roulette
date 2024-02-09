//
//  ArchivedWarikanGroupDTO.swift
//  Roulette
//
//  Created by Masaki Doi on 2024/02/10.
//

import Foundation

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
            unluckyMember = try await memberUsecase.get(id: unluckyMemberID)?.name
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
