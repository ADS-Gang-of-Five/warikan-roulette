//
//  RouletteResultViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class RouletteResultViewModel: ObservableObject {
    let archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>
    private let archivedWarikanGroupUseCase = ArchivedWarikanGroupUseCase(
        archivedWarikanGroupRepository: ArchivedWarikanGroupRepository(),
        memberRepository: MemberRepository(),
        tatekaeRepository: TatekaeRepository()
    )

    @Published private(set) var unluckyMember: MemberData?

    @Published var isShowAlert = false
    @Published private(set) var aletText = ""

    init(_ archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>) {
        self.archivedWarikanGroupID = archivedWarikanGroupID
    }

    func getUnluckyMember() async {
        do {
            let groupData = try await archivedWarikanGroupUseCase.get(id: archivedWarikanGroupID)
            guard let unluckyMember = groupData.unluckyMember else {
                throw NSError(domain: "RouletteResultViewに遷移しているのにunluckyMemberが存在しないのはおかしい。", code: 0)
            }
            self.unluckyMember = unluckyMember
        } catch {
            print(error)
            aletText = "データの読み込みに失敗しました。前の画面に戻り再度お試しください。"
            isShowAlert = true
        }
    }
}
