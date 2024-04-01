//
//  RouletteViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import SwiftUI

@MainActor
final class RouletteViewModel: ObservableObject {
    private let warikanGroupUseCase = WarikanGroupUseCase(
        warikanGroupRepository: WarikanGroupRepository(),
        memberRepository: MemberRepository(),
        tatekaeRepository: TatekaeRepository()
    )
    private let seisanCalculator = SeisanCalculator(memberRepository: MemberRepository())
    private let archiveController = WarikanGroupArchiveController(
        warikanGroupRepository: WarikanGroupRepository(),
        archivedWarikanGroupRepository: ArchivedWarikanGroupRepository()
    )

    @Published var angle = Angle(degrees: 0.0) // 見直し
    @Published var isRouletteBottanTap = false // 見直し

    @Published private(set) var members: [MemberData]?
    @Published private(set) var tatekaeList: [TatekaeData]?
    let warikanGroupID: EntityID<WarikanGroup>
    @Published private(set) var archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>?

    @Published var isShowAlert = false
    @Published private(set) var alertText = ""

    init(warikanGroupID: EntityID<WarikanGroup>) {
        self.warikanGroupID = warikanGroupID
    }

    func onAppearAction() async {
        do {
            try await getMembersAndTatekaeList()
        } catch {
            print(error)
            alertText = "データの読み込みに失敗しました。前の画面に戻りもう一度お試しください。"
            isShowAlert = true
        }
    }

    private func getMembersAndTatekaeList() async throws {
        let allWarikanGroups = try await warikanGroupUseCase.getAll()
        guard let warikanGroup = allWarikanGroups.first(where: { warikanGroup in
            warikanGroup.id == self.warikanGroupID
        }) else { throw NSError(domain: "not found", code: 404) }
        self.members = warikanGroup.members
        self.tatekaeList = warikanGroup.tatekaeList
    }

    private func archiveWarikanGroup() {}

    func stopAtMember(name: String) {
        guard let members else { return }
        guard let selectedMemberIndex = members.firstIndex(where: { $0.name == name }) else { return }
        let degreesPerMember = 360.0 / Double(members.count)
        let halfSector = degreesPerMember / 2.0
        let targetDegrees = degreesPerMember * Double(selectedMemberIndex) + halfSector
        angle = .zero
        withAnimation(.spring(duration: 10)) {
            let extraRotation = 360.0 * 5
            angle = .degrees(extraRotation - targetDegrees)
        }
    }

    func didStartButtonTappedAction() {
        isRouletteBottanTap = true
        guard let unluckyMember = members?.randomElement() else {
            fatalError() // FIXME: fatalError()
        }
        stopAtMember(name: unluckyMember.name)
        Task {
            // seinsan & archive
            do {
                guard let tatekaeList else { fatalError() } // FIXME: fatalError()
                let seisanResponse = try await seisanCalculator.seisan(tatekaeList: tatekaeList)
                guard case .needsUnluckyMember(let seisanContext) = seisanResponse else {
                    fatalError() // FIXME: fatalError()
                }
                let seisanDataList = try await seisanCalculator.seisan(
                    context: seisanContext,
                    unluckyMember: unluckyMember.id
                )
                archivedWarikanGroupID = try await archiveController.archive(
                    id: warikanGroupID,
                    seisanList: seisanDataList,
                    unluckyMember: unluckyMember.id
                )
            } catch {
                print(error)
                alertText = "エラーが発生しました。前の画面に戻りもう一度お試しください。"
                isShowAlert = true
            }
        }
    }
}
