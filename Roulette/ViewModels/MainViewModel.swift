//
//  MainViewModel.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/30.
//

import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    @Published var groups: [WarikanGroup] = []
    @Published var members: [Member] = []
    @Published var tatekaes: [Tatekae] = []
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

    func fecthAllGroups() async {
        do {
            groups = try await warikanGroupUseCase.getAll()
        } catch {
            print(#function, error)
        }
    }
    
    func createWarikanGroup(name: String, memberNames: [String]) async {
        do {
            try await warikanGroupUseCase.create(name: name, memberNames: memberNames)
            await fecthAllGroups()
        } catch {
            print(#function, error)
        }
    }
    
    func getTatakaeList(id: EntityID<WarikanGroup>) async {
        do {
            tatekaes = try await warikanGroupUseCase.getTatekaeList(id: id)
        } catch {
            print(#function, error)
        }
    }

    func getMembers(ids: [EntityID<Member>]) async {
        do {
            members = try await memberUsecase.get(ids: ids)
        } catch {          
            print(#function, error)
        }
    }
    
    func getMember(id: EntityID<Member>) async -> Member {
        do {
            let member = try await memberUsecase.get(id: id)!
            return member
        } catch {
            print(#function, error); fatalError();
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
        } catch {
            print(#function, error)
        }
    }
}
