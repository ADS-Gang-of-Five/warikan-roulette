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

     @Published private(set) var tatekaeDTOs: [TatekaeDTO]?

     @Published var isShowAlert = false
     @Published private(set) var alertText = ""

     @Published var isShowAddTatekaeView = false
     @Published var focusedTatekaeDTO: TatekaeDTO?

     @Published private var isDeletingTatekae = false

     var isTatekaeListDisabled: Bool { isDeletingTatekae }
     var isAddTatekaeButtonDisabled: Bool { isDeletingTatekae }
     var isBackToPreviousviewButtonDisabled: Bool { isDeletingTatekae }
     var isNavigateToConfirmViewButtonDisabled: Bool {
         !(tatekaeDTOs.flatMap { $0.count > 0 } ?? false && isDeletingTatekae == false)
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

     func didTappedTatekaeDeleteButtonAction(id: EntityID<Tatekae>) {
         guard isDeletingTatekae == false else { return }
         Task {
             do {
                 isDeletingTatekae = true
                 defer { isDeletingTatekae = false }
                 try await warikanGroupUseCase.removeTatekae(
                    warikanGroup: warikanGroupID,
                    tatekae: id
                 )
                 await makeTatekaeDTOs()
             } catch {
                 print(error)
                 alertText = "立替の削除に失敗しました。"
                 isShowAlert = true
             }
         }
     }
 }
