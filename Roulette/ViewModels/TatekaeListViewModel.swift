//
//  TatekaeListViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
 final class TatekaeListViewModel: ObservableObject {
     @Published var tatekaes: [Tatekae] = []
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
