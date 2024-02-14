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
     private let warikanGroupUseCase: WarikanGroupUseCase
     private let memberUseCase: MemberUseCase
 
     init() {
         self.memberUseCase = MemberUseCase(memberRepository: MemberRepository())
         self.warikanGroupUseCase = WarikanGroupUseCase(
             warikanGroupRepository: WarikanGroupRepository(),
             memberRepository: MemberRepository(),
             tatekaeRepository: TatekaeRepository()
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
             members = try await memberUseCase.get(ids: ids)
         } catch {
             print("error:", error)
             print(#file, #line)
         }
     }
     
     func getMember(id: EntityID<Member>) async -> Member {
         do {
             let member = try await memberUseCase.get(id: id)
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
