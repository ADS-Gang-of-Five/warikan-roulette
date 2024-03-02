//  swiftlint:disable:this file_name
//  ConfirmViewModelDTO.swift
//  Roulette
//
//  Created by sako0602 on 2024/02/25.
//

import Foundation

extension ConfirmViewModel {
    struct WarikanGroupDTO {
        struct TatekaeList: Identifiable{
            let id = UUID()
            let name: String
            let money: String
        }
        let name: String
        let members: [String]
        let tatekaeList: [TatekaeList]
        private init(name: String, members: [String], tatekaeList: [TatekaeList]) {
            self.name = name
            self.members = members
            self.tatekaeList = tatekaeList
        }
        
        static func convert(
            warikanGroupUseCase: WarikanGroupUseCase,
            memberUseCase: MemberUseCase,
            warikanGroup: WarikanGroup
        ) async throws -> WarikanGroupDTO {
            let warikanGroups = try await warikanGroupUseCase.getAll()
            // nameを取得・変換
            let warikanGroup = warikanGroups.first { $0.id == warikanGroup.id }
            guard let warikanGroup else { 
                return WarikanGroupDTO(name: "nil", members: [], tatekaeList: [])
            }
            let name = warikanGroup.name
            // membersを取得・変換
            guard let memberIDs = warikanGroups.first(where: { $0.id == warikanGroup.id })?.members else {
                return WarikanGroupDTO(name: "nil", members: [], tatekaeList: [])
            }
            let members = try await memberUseCase.get(ids: memberIDs)
            let convertMembers = members.map { $0.name }
            // nameとmoneyをTatekaeList型で取得・変換
            let tatekaeList = try await warikanGroupUseCase.getTatekaeList(id: warikanGroup.id)
            let convertNameMoney = tatekaeList.map { TatekaeList(name: $0.name, money: String($0.money))}
            // DTOで返す
            return WarikanGroupDTO(
                name: name,
                members: convertMembers,
                tatekaeList: convertNameMoney
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
}
