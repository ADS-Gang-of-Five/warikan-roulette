//
//  ArchivedSeisanResultViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2024/01/30.
//

import Foundation

@MainActor
final class ArchivedSeisanResultViewModel: ObservableObject {
    private let archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>
    @Published private(set) var archivedWarikanGroupDTO: ArchivedWarikanGroupDTO?
    private let archivedWarikanGroupUseCase: ArchivedWarikanGroupUseCase
    private let memberUseCase: MemberUseCase
    private let tatekaeUseCase: TatekaeUseCase
    @Published var isShowAlert = false
    let alertText = "データの読み込み中にエラーが発生しました。前の画面に戻りもう一度お試しください。"

    init(archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>) {
        self.archivedWarikanGroupID = archivedWarikanGroupID
        self.archivedWarikanGroupUseCase = ArchivedWarikanGroupUseCase(
            archivedWarikanGroupRepository: ArchivedWarikanGroupRepository(),
            memberRepository: MemberRepository(),
            tatekaeRepository: TatekaeRepository()
        )
        self.memberUseCase = MemberUseCase(memberRepository: MemberRepository())
        self.tatekaeUseCase = TatekaeUseCase(tatekaeRepository: TatekaeRepository())
    }

    // `archivedWarikanGroupDTO`の作成を行う関数
    func makeArchivedWarikanGroupDTO() async {
        do {
            let archivedWarikanGroupData = try await archivedWarikanGroupUseCase.get(id: archivedWarikanGroupID)
            self.archivedWarikanGroupDTO = try await ArchivedWarikanGroupDTO.convert(
                archivedWarikanGroupData,
                tatekaeUsecase: tatekaeUseCase,
                memberUsecase: memberUseCase
            )
        } catch {
            self.isShowAlert = true
        }
    }
}
