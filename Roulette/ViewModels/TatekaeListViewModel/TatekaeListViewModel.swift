//
//  TatekaeListViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
 final class TatekaeListViewModel: ObservableObject {
     let warikanGroupID: EntityID<WarikanGroup>
     private let warikanGroupUseCase = WarikanGroupUseCase(
        warikanGroupRepository: WarikanGroupRepository(),
        memberRepository: MemberRepository(),
        tatekaeRepository: TatekaeRepository()
     )
     private let tatekaeUseCase = TatekaeUseCase(tatekaeRepository: TatekaeRepository())

     @Published private(set) var tatekaeDTOs: [TatekaeDTO]?

     @Published var isShowAlert = false
     @Published private(set) var alertText = ""

     @Published var isShowAddTatekaeView = false
     @Published private(set) var focusedTatekae: EntityID<Tatekae>?

     var isNavigateToConfirmViewButtonDisabled: Bool {
         return switch tatekaeDTOs {
         case .some(let tatekaeDTOs) where tatekaeDTOs.count > 0: false
         default: true
         }
     }

     init(warikanGroupID: EntityID<WarikanGroup>) {
         self.warikanGroupID = warikanGroupID
     }

     func makeTatekaeDTOs() async {
         do {
             let tatekaes = try await warikanGroupUseCase.getTatekaeList(id: warikanGroupID)
             let dateFormatter = DateFormatter()
             dateFormatter.calendar = Calendar.autoupdatingCurrent
             dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
             tatekaeDTOs = tatekaes.map { TatekaeDTO.convert($0, dateFormatter: dateFormatter) }
         } catch {
             print(error)
             alertText = "データの読み込み中にエラーが発生しました。前の画面に戻り再度お試しください。"
             isShowAlert = true
         }
     }
 }
