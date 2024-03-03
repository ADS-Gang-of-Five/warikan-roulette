//
//  MainViewModel.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/30.
//

import Foundation

/// - Important: 何かを追加するという処理には、更新が付随することに注意。
@MainActor
final class MainViewModel: ObservableObject {
    // 端末に保存されている全ての割り勘グループ
    @Published var allGroups: [WarikanGroup] = []

    // 使用中の割り勘グループ、及びそのメンバーと立て替えの一覧
    @Published var selectedGroup: WarikanGroup?
    @Published var selectedGroupMembers: [Member]?
    @Published var selectedGroupTatekaes: [Tatekae]?
    @Published var selectedGroupSeisanResponse: SeisanCalculator.SeisanResponse?
    @Published var unluckyMemberName: String?

    // ユースケース
    private let warikanGroupUseCase: WarikanGroupUseCase
    private let memberUseCase: MemberUseCase
    private let tatekaeUseCase: TatekaeUseCase
    private let warikanGroupArchiveController: WarikanGroupArchiveController
    let seisanCalculator: SeisanCalculator

    init() {
        self.warikanGroupUseCase = WarikanGroupUseCase(
            warikanGroupRepository: WarikanGroupRepository(),
            memberRepository: MemberRepository(),
            tatekaeRepository: TatekaeRepository()
        )
        self.memberUseCase = MemberUseCase(memberRepository: MemberRepository())
        self.tatekaeUseCase = TatekaeUseCase(tatekaeRepository: TatekaeRepository())
        self.warikanGroupArchiveController = WarikanGroupArchiveController(
            warikanGroupRepository: WarikanGroupRepository(),
            archivedWarikanGroupRepository: ArchivedWarikanGroupRepository()
        )
        self.seisanCalculator = SeisanCalculator(memberRepository: MemberRepository())
    }
    
    // 途中計算の.needsunluckymenberを.successへ変える
    func convertSeisanResponseToSuccess( _ seisanDataList: [SeisanData]) {
        selectedGroupSeisanResponse = .success(seisanDataList)
    }
    
    var archivedWarkanGroupID: EntityID<ArchivedWarikanGroup>?
    
    func archiveWarikanGroup(
        id: EntityID<WarikanGroup>,
        seisanList: [SeisanData],
        unluckyMember: EntityID<Member>?
    ) async {
        do {
            let id = try await warikanGroupArchiveController.archive(
                id: id,
                seisanList: seisanList,
                unluckyMember: unluckyMember
            )
            archivedWarkanGroupID = id
        } catch {
            print(#function, error)
        }
    }
}
