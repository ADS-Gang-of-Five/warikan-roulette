//
//  ConfirmViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
class ConfirmViewModel: ObservableObject {
    var archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>
    @Published var selectedGroup: WarikanGroup?
    @Published var selectedGroupMembers: [Member]?
    @Published var selectedGroupTatekaes: [Tatekae]?
    @Published var selectedGroupSeisanResponse: SeisanCalculator.SeisanResponse?
    
    // ユースケース
    private let warikanGroupArchiveController: WarikanGroupArchiveController
    let seisanCalculator: SeisanCalculator
    
    init(_ archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>) {
        self.archivedWarikanGroupID = archivedWarikanGroupID
        self.seisanCalculator = SeisanCalculator(memberRepository: MemberRepository())
        self.warikanGroupArchiveController = WarikanGroupArchiveController(
            warikanGroupRepository: WarikanGroupRepository(),
            archivedWarikanGroupRepository: ArchivedWarikanGroupRepository()
        )
    }
    
    // 現在のselectedGroupTatekaesを基にSeisanResponseを取得する
    func getSeisanResponse() async {
        do {
            guard let tatekaeList = selectedGroupTatekaes else {
                print("selectedGroupTatekaesがnilです。")
                return
            }
            try await selectedGroupSeisanResponse = seisanCalculator.seisan(tatekaeList: tatekaeList)
        } catch {
            print(#function, error)
        }
    }
    
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
