//
//  AddTatekaeViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class AddTatekaeViewModel: ObservableObject {
    @Published var tatekaeName = ""
    @Published var money = ""
    @Published private(set) var members: [MemberData]?
    @Published var payer: EntityID<Member>?

    private let warikanGroupID: EntityID<WarikanGroup>
    private let groupUseCase: WarikanGroupUseCase

    @Published var isShowAlert = false
    @Published private(set) var alertText = ""
    @Published private(set) var isAppendingTatekae = false
    @Published var isShowDismissConfirmationDialog = false

    var isAppendTatekaeButtonDisabled: Bool {
        !(tatekaeName.isEmpty == false &&
          Int(money).flatMap { $0 > 0 } ?? false &&
          payer != nil &&
          isAppendingTatekae == false)
    }

    var hasAnyInput: Bool {
        !(tatekaeName.isEmpty && money.isEmpty && payer == nil)
    }

    var isTatekaeNameTextFieldDisabled: Bool { isAppendingTatekae }
    var isMoneyTextFieldDisabled: Bool { isAppendingTatekae }
    var isPayerPickerDisabled: Bool { isAppendingTatekae }
    var isDismissButtonDisabled: Bool { isAppendingTatekae }

    init(_ warikanGroupID: EntityID<WarikanGroup>) {
        self.warikanGroupID = warikanGroupID
        self.groupUseCase = WarikanGroupUseCase(
            warikanGroupRepository: WarikanGroupRepository(),
            memberRepository: MemberRepository(),
            tatekaeRepository: TatekaeRepository()
        )
    }

    func getMembers() async {
        do {
            guard let warikanGroup = try await groupUseCase.getAll().first(where: { $0.id == warikanGroupID })
            else { return }
            members = warikanGroup.members
        } catch {
            print(error)
            alertText = "データの読み込み中にエラーが発生しました。前の画面に戻りもう一度お試しください。"
            isShowAlert = true
        }
    }

    func didTapAppendTatakaeButton(onCompleted completedAction: @escaping () -> Void) {
        guard isAppendingTatekae == false else { return }
        Task {
            do {
                defer { isAppendingTatekae = false }
                isAppendingTatekae = true
                guard let payerID = payer else {
                    alertText = "支払人を設定してください。"
                    isShowAlert = true
                    return
                }
                guard let members = members, let money = Int(money)
                else {
                    alertText = "立替の追加に失敗しました。"
                    isShowAlert = true
                    return
                }
                let memberIDs = members.map { $0.id }
                try await groupUseCase.appendTatekae(
                    warikanGroup: warikanGroupID,
                    tatekaeName: tatekaeName,
                    payer: payerID,
                    recipants: memberIDs,
                    money: money
                )
                completedAction()
            } catch {
                print(error)
                alertText = "立替の追加に失敗しました。"
                isShowAlert = true
            }
        }
    }

    func didTapDismissButtonAction(dismissFunction: () -> Void) {
        if hasAnyInput == false {
            dismissFunction()
        } else {
            isShowDismissConfirmationDialog = true
        }
    }
}
