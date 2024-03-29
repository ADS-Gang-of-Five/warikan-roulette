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
    private let memberUseCase: MemberUseCase
    private let tatekaeUseCase: TatekaeUseCase
    @Published var isShowAlert = false
    let alertText = "データを取得できなかったためトップに戻ります。"

    init(archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>) {
        self.archivedWarikanGroupID = archivedWarikanGroupID
        self.archivedWarikanGroupUseCase = ArchivedWarikanGroupUseCase(
            archivedWarikanGroupRepository: ArchivedWarikanGroupRepository(),
            memberRepository: MemberRepository()
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
