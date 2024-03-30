//
//  AddGroupViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class AddGroupViewModel: ObservableObject {
    @Published var groupName = ""
    @Published var memberList: [String] = []
    @Published var additionalMember = ""
    @Published var isCreatingWarikanGroup = false
    @Published var isShowAlert = false
    @Published var alertText = ""
    @Published var isShowDismissConfirmationDialog = false

    var isAddMemberButtonDisabled: Bool {
        !(additionalMember.isEmpty == false && memberList.count <= 20 && isCreatingWarikanGroup == false)
    }

    var isCreateGroupButtonDisabled: Bool {
        !(groupName.count > 0 && memberList.count > 1 && isCreatingWarikanGroup == false)
    }

    var isDissmissButtonDisabled: Bool {
        isCreatingWarikanGroup
    }

    var hasAnyInput: Bool {
        !(groupName.isEmpty && memberList.isEmpty && additionalMember.isEmpty)
    }

    private let warikanGroupUseCase = WarikanGroupUseCase(
        warikanGroupRepository: WarikanGroupRepository(),
        memberRepository: MemberRepository(),
        tatekaeRepository: TatekaeRepository()
    )

    func didTapAddMemberButton() {
        guard memberList.contains(additionalMember) == false else {
            alertText = "\(additionalMember)さんはすでに追加済みです。"
            isShowAlert = true
            return
        }
        memberList.append(additionalMember)
        Task { @MainActor in // Taskにしてる理由は Issue #222 参照
            additionalMember.removeAll()
        }
    }

    func didTapCreateGroupButton(onCompleted completedAction: @escaping () -> Void) {
        guard isCreatingWarikanGroup == false else { return }
        createWarikanGroup(onCompleted: completedAction)
    }

    func didTapDismissButtonAction(dismissFunction: () -> Void) {
        if hasAnyInput == false {
            dismissFunction()
        } else {
            isShowDismissConfirmationDialog = true
        }
    }

    private func createWarikanGroup(onCompleted completedAction: @escaping () -> Void) {
        Task {
            do {
                defer { isCreatingWarikanGroup = false }
                isCreatingWarikanGroup = true
                let isGroupNameDuplicated = try await warikanGroupUseCase.getAll().contains {
                    $0.name == self.groupName
                }
                guard isGroupNameDuplicated == false else {
                    alertText = "\(self.groupName)はすでに作成済みです。"
                    isShowAlert = true
                    return
                }
                try await warikanGroupUseCase.create(
                    name: self.groupName,
                    memberNames: self.memberList
                )
                completedAction()
            } catch {
                print(error)
                alertText = "割り勘グループの作成に失敗しました。"
                isShowAlert = true
            }
        }
    }
}
