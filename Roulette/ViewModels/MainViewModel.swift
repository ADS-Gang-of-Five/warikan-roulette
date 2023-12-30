//
//  MainViewModel.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/30.
//

import Foundation


/// - Important: 何かを追加するという処理には、更新が付随することに注意。
@MainActor
final class MainViewModel: ObservableObject {
    @Published var allGroups: [WarikanGroup] = []

    @Published var selectedGroup: WarikanGroup?
    @Published var selectedGroupMembers: [Member]?
    @Published var selectedGroupTatekaes: [Tatekae]?

    private let warikanGroupUseCase: WarikanGroupUsecase
    private let memberUsecase: MemberUsecase
    private let tatekaeUsecase: TatekaeUsecase

    init() {
        let warikanGroupRepository = WarikanGroupRepository(userDefaultsKey: "warikanGroup")
        let memberRepository = MemberRepository(userDefaultsKey: "member")
        let tatekaeRepository = TatekaeRepository(userDefaultsKey: "tatekae")

        self.warikanGroupUseCase = WarikanGroupUsecase(
            warikanGroupRepository: warikanGroupRepository,
            memberRepository: memberRepository,
            tatekaeRepository: tatekaeRepository
        )
        self.memberUsecase = MemberUsecase(memberRepository: memberRepository)
        self.tatekaeUsecase = TatekaeUsecase(tatekaeRepository: tatekaeRepository)
    }

    func getAllWarikanGroups() async {
        do {
            allGroups = try await warikanGroupUseCase.getAll()
        } catch {
            print(#function, error)
        }
    }
    
    func createWarikanGroup(name: String, memberNames: [String]) async {
        do {
            try await warikanGroupUseCase.create(name: name, memberNames: memberNames)
            await getAllWarikanGroups()
        } catch {
            print(#function, error)
        }
    }
    
    func getSelectedGroupTatakaeList(id: EntityID<WarikanGroup>) async {
        do {
            selectedGroupTatekaes = try await warikanGroupUseCase.getTatekaeList(id: id)
        } catch {
            print(#function, error)
        }
    }

    func getSelectedGroupMembers(ids: [EntityID<Member>]) async {
        do {
            selectedGroupMembers = try await memberUsecase.get(ids: ids)
        } catch {          
            print(#function, error)
        }
    }
    
    func getMember(id: EntityID<Member>) async -> Member {
        do {
            let member = try await memberUsecase.get(id: id)!
            return member
        } catch {
            print(#function, error)
            fatalError()
        }
    }

    func appendTatekae(
        warikanGroupID: EntityID<WarikanGroup>,
        tatekaeName: String,
        payerID: EntityID<Member>,
        recipantIDs: [EntityID<Member>],
        money: Int
    ) async {
        do {
            try await warikanGroupUseCase.appendTatekae(
                warikanGroup: warikanGroupID,
                tatekaeName: tatekaeName,
                payer: payerID,
                recipants: recipantIDs,
                money: money
            )
            await getSelectedGroupTatakaeList(id: warikanGroupID)
        } catch {
            print(#function, error)
        }
    }
}
