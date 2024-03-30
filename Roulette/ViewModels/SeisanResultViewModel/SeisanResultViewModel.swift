//
//  SeisanResultViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class SeisanResultViewModel: ObservableObject {
    private let archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>
    @Published private(set) var archivedWarikanGroupDTO: ArchivedWarikanGroupDTO?
    private let archivedWarikanGroupUseCase: ArchivedWarikanGroupUseCase
    @Published var isShowAlert = false
    let alertText = "データを取得できなかったためトップに戻ります。"

    init(archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>) {
        self.archivedWarikanGroupID = archivedWarikanGroupID
        self.archivedWarikanGroupUseCase = ArchivedWarikanGroupUseCase(
            archivedWarikanGroupRepository: ArchivedWarikanGroupRepository(),
            memberRepository: MemberRepository(),
            tatekaeRepository: TatekaeRepository()
        )
    }

    // `archivedWarikanGroupDTO`の作成を行う関数
    func makeArchivedWarikanGroupDTO() async {
        do {
            let archivedWarikanGroupData = try await archivedWarikanGroupUseCase.get(id: archivedWarikanGroupID)
            self.archivedWarikanGroupDTO = try await ArchivedWarikanGroupDTO.convert(archivedWarikanGroupData)
        } catch {
            self.isShowAlert = true
        }
    }
}
