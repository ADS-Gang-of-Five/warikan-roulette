//  swiftlint:disable:this file_name
//  ConfirmViewModelDTO.swift
//  Roulette
//
//  Created by sako0602 on 2024/02/25.
//

import Foundation

extension ConfirmViewModel {
    struct WarikanGroupDTO {
        let name: String
        let members: [String]
        let tatekaeList: [(name: String,money:String)]
        let tatekaeListName: [String]
        let tatekaeListMoney: [String]
        private init(name: String, members: [String], tatekaeListName: [String], tatekaeListMoney: [String]) {
            self.name = name
            self.members = members
            self.tatekaeListName = tatekaeListName
            self.tatekaeListMoney = tatekaeListMoney
        }
        
        static func convert(
            warikanGroupUseCase: WarikanGroupUseCase,
            memberUseCase: MemberUseCase,
            warikanGroup: WarikanGroup
        ) async throws -> WarikanGroupDTO {
            let warikanGroups = try await warikanGroupUseCase.getAll()
            // nameを取得
            let warikanGroup = warikanGroups.first { $0.id == warikanGroup.id }
            guard let warikanGroup else { 
                return WarikanGroupDTO(name: "nil", members: [], tatekaeListName: [], tatekaeListMoney: [])
            }
            let name = warikanGroup.name
            // membersを取得
            guard let memberIDs = warikanGroups.first(where: { $0.id == warikanGroup.id })?.members else {
                return WarikanGroupDTO(name: "nil", members: [], tatekaeListName: [], tatekaeListMoney: [])
            }
            let members = try await memberUseCase.get(ids: memberIDs)
            let convertMembers = members.map { $0.name }
            // tatekaeListNameを取得
            let tatekaeList = try await warikanGroupUseCase.getTatekaeList(id: warikanGroup.id)
            let convertTatekaeListName = tatekaeList.map { $0.name }
            // tatekaeListMoneyを取得
            let convertTatekaeListMoney = tatekaeList.map { String($0.money) }
            // DTOで返す
            return WarikanGroupDTO(
                name: name,
                members: convertMembers,
                tatekaeListName: convertTatekaeListName,
                tatekaeListMoney: convertTatekaeListMoney
            )
        }
    }
    
    struct TatekaeDTO: Identifiable {
        let id: EntityID<Tatekae>
        let name: String
        let money: String

        init(id: EntityID<Tatekae>, name: String, money: String) {
            self.id = id
            self.name = name
            self.money = money
        }

        static func convert(_ tatekae: Tatekae) -> Self {
            Self.init(
                id: tatekae.id,
                name: tatekae.name,
                money: tatekae.money.description
            )
        }
    }
    
    struct SeisanResponseDTO {
        
    }
}
