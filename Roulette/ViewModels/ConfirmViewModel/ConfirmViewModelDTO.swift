// swiftlint:disable:this file_name
//
//  ConfirmViewModelDTO.swift
//  Roulette
//
//  Created by Masaki Doi on 2024/03/03.
//

import Foundation

extension ConfirmViewModel {
    struct WarikanGroupDTO {
        let name: String
        let members: [String]
        let tatekaeList: [(name: String, money: String)]
        let totalAmount: String

        private init(
            name: String,
            members: [String],
            tatekaeList: [(name: String, money: String)],
            totalAmount: String
        ) {
            self.name = name
            self.members = members
            self.tatekaeList = tatekaeList
            self.totalAmount = totalAmount
        }

        static func convert(
            warikanGroup: WarikanGroup,
            memberUseCase: MemberUseCase,
            tatekaeUseCase: TatekaeUseCase
        ) async throws -> Self {
            let name = warikanGroup.name
            let members = try await memberUseCase.get(ids: warikanGroup.members).map { $0.name }
            let tatekaeList = try await tatekaeUseCase.get(ids: warikanGroup.tatekaeList)
                .map { ($0.name, $0.money.description) }
            let totalAmount = try await tatekaeUseCase.get(ids: warikanGroup.tatekaeList)
                .map { $0.money }
                .reduce(0, +)
                .description
            return WarikanGroupDTO(
                name: name,
                members: members,
                tatekaeList: tatekaeList,
                totalAmount: totalAmount
            )
        }
    }
}
