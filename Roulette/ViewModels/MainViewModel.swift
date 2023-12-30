//
//  MainViewModel.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/30.
//

import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    @Published var tatekaes: [Tatekae] = []
    @Published var groups: [WarikanGroup] = .init()
    @Published var members: [Member] = []
    private let warikanGroupUseCase: WarikanGroupUsecase
    private let memberUsecase: MemberUsecase

    init() {
        let warikanGroupRepository = WarikanGroupRepository(userDefaultsKey: "warikanGroup")
        let memberRepository = MemberRepository(userDefaultsKey: "member")
        let tatekaeRepository = TatekaeRepository(userDefaultsKey: "tatekae")

        self.memberUsecase = MemberUsecase(memberRepository: memberRepository)
        self.warikanGroupUseCase = WarikanGroupUsecase(
            warikanGroupRepository: warikanGroupRepository,
            memberRepository: memberRepository,
            tatekaeRepository: tatekaeRepository
        )
    }
    
    func fecthAllGroups() async {
        print("fetchGroupAllが呼ばれました。")
        do {
            groups = try await warikanGroupUseCase.getAll()
            print("groups", groups)
        } catch {
            print(error)
        }
    }
    
    func createWarikanGroup(name: String, memberNames: [String]) async {
        do {
            try await warikanGroupUseCase.create(name: name, memberNames: memberNames)
            await fecthAllGroups()
        } catch {
            print(#file, #line, "couldn't create")
        }
    }
    
    // TatekaeListViewModelから移行
    func getTatakaeList(id: EntityID<WarikanGroup>) async {
         do {
             tatekaes = try await warikanGroupUseCase.getTatekaeList(id: id)
         } catch {
//             print("error:", error)
//             print(#file, #line)
         }
     }
 
     func getMembers(ids: [EntityID<Member>]) async {
         do {
             members = try await memberUsecase.get(ids: ids)
         } catch {
             print("error:", error)
             print(#file, #line)
         }
     }
     
     func getMember(id: EntityID<Member>) async -> Member {
         do {
             let member = try await memberUsecase.get(id: id)!
             return member
         } catch {
             print("error:", error)
             print(#file, #line)
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
         } catch {
//             print("error:", error)
//             print(#file, #line)
         }
     }
}
