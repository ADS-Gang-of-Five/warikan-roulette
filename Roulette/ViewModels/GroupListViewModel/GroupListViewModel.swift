//
//  GroupListViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class GroupListViewModel: ObservableObject {
    @Published private(set) var warikanGroups: [WarikanGroup]? = []
    @Published var isShowAddGroupView = false
    @Published var isShowAlert = false
    @Published private(set) var alertText = ""
    @Published private var isDeletingGroup = false
    var isNavigationLinkListDisabled: Bool { isDeletingGroup }
    var isAddButtonDisabled: Bool { isDeletingGroup }

    private let warikanGroupUseCase = WarikanGroupUseCase(
        warikanGroupRepository: WarikanGroupRepository(),
        memberRepository: MemberRepository(),
        tatekaeRepository: TatekaeRepository()
    )

    func fetchAllWarikanGroups() async {
        do {
            warikanGroups = try await warikanGroupUseCase.getAll()
        } catch {
            print(error)
            alertText = "割り勘グループの取得に失敗しました。"
            isShowAlert = true
        }
    }

    func didTappedGroupDeleteButtonAction(id: EntityID<WarikanGroup>) {
        guard isDeletingGroup == false else { return }
        Task {
            do {
                isDeletingGroup = true
                defer { isDeletingGroup = false }
                try await warikanGroupUseCase.remove(ids: [id])
                await fetchAllWarikanGroups()
            } catch {
                print(error)
                alertText = "割り勘グループの削除に失敗しました。"
                isShowAlert = true
            }
        }
    }
}
