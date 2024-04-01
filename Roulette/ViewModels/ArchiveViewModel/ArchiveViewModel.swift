//
//  ArchiveViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class ArchiveViewModel: ObservableObject {
    @Published private(set) var archivedWarikanGroupDTOs: [ArchivedWarikanGroupDTO] = []
    @Published private var isDeletingGroup = false
    @Published var isShowAlert = false
    @Published private(set) var alertText = ""
    var isNavigationLinkListDisabled: Bool { isDeletingGroup }

    private let archivedWarikanGroupUseCase = ArchivedWarikanGroupUseCase(
        archivedWarikanGroupRepository: ArchivedWarikanGroupRepository(),
        memberRepository: MemberRepository(),
        tatekaeRepository: TatekaeRepository()
    )

    func makeArchivedWarikanGroupDTO() async {
        do {
            let archivedWarikanGroupDataList = try await archivedWarikanGroupUseCase.getAll()
            self.archivedWarikanGroupDTOs = archivedWarikanGroupDataList
                .map { ArchivedWarikanGroupDTO.convert($0) }
        } catch {
            print(#function, error)
        }
    }

    func didTappedGroupDeleteButtonAction(id: EntityID<ArchivedWarikanGroup>) {
        guard isDeletingGroup == false else { return }
        Task {
            do {
                isDeletingGroup = true
                defer { isDeletingGroup = false }
                try await archivedWarikanGroupUseCase.remove(ids: [id])
                await makeArchivedWarikanGroupDTO()
            } catch {
                print(error)
                alertText = "精算済み割り勘グループの削除に失敗しました。"
                isShowAlert = true
            }
        }
    }
}
