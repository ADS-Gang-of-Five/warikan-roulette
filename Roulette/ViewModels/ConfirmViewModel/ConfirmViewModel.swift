//
//  ConfirmViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
class ConfirmViewModel: ObservableObject {
    let warikanGroupID: EntityID<WarikanGroup>
    var archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>?
    @Published var selectedGroup: WarikanGroup?
    @Published var selectedGroupMembers: [Member]?
    @Published var selectedGroupTatekaes: [Tatekae]?
    @Published var selectedGroupSeisanResponse: SeisanCalculator.SeisanResponse?
    
    // ユースケース
    private let warikanGroupArchiveController: WarikanGroupArchiveController
    private let warikanGroupUseCase: WarikanGroupUseCase
    private let memberUseCase: MemberUseCase
    let seisanCalculator: SeisanCalculator

    init(_ warikanGroupID: EntityID<WarikanGroup>) {
        self.warikanGroupID = warikanGroupID
        self.warikanGroupUseCase = WarikanGroupUseCase(
            warikanGroupRepository: WarikanGroupRepository(),
            memberRepository: MemberRepository(),
            tatekaeRepository: TatekaeRepository()
        )
        self.warikanGroupArchiveController = WarikanGroupArchiveController(
            warikanGroupRepository: WarikanGroupRepository(),
            archivedWarikanGroupRepository: ArchivedWarikanGroupRepository()
        )
        self.memberUseCase = MemberUseCase(memberRepository: MemberRepository())
        self.seisanCalculator = SeisanCalculator(memberRepository: MemberRepository())
    }
    
    // ConfirmViewに必要な割り勘グループ情報を取得する。
    func getConfirmViewBuildingElements() async {
        do {
            try await selectedGroupTatekaes = warikanGroupUseCase.getTatekaeList(id: warikanGroupID)
            guard let tatekaeList = selectedGroupTatekaes else {
                return print("selectedGroupTatekaesがnilです。")
            }
            try await selectedGroupSeisanResponse = seisanCalculator.seisan(tatekaeList: tatekaeList)
            let warikanGroups = try await warikanGroupUseCase.getAll()
            let warikanGroup = warikanGroups.first { $0.id == warikanGroupID }
            selectedGroup = warikanGroup
            guard let memberIDs = selectedGroup?.members else {
                return print("memberのIDsを取得できませんでした。")
            }
            let members = try await memberUseCase.get(ids: memberIDs)
            selectedGroupMembers = members
        } catch {
            print(#function, error)
        }
    }
    
    // warikanGroupのIDを使って、archiveを作成する。
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
            archivedWarikanGroupID = id
        } catch {
            print(#function, error)
        }
    }
}
