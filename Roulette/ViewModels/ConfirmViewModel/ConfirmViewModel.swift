//
//  ConfirmViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
class ConfirmViewModel: ObservableObject {
    private let warikanGroupID: EntityID<WarikanGroup>
    var archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>?
    // DTOに変更
    @Published private(set) var warikanGroupDTO: WarikanGroupDTO?
    @Published private(set) var totalAmount: String?
    @Published var unluckyMember = false
    @Published var selectedGroupSeisanResponse: SeisanCalculator.SeisanResponse?
    // ユースケース
    private let warikanGroupUseCase: WarikanGroupUseCase = WarikanGroupUseCase(
        warikanGroupRepository: WarikanGroupRepository(),
        memberRepository: MemberRepository(),
        tatekaeRepository: TatekaeRepository()
    )
    private let memberUseCase: MemberUseCase = MemberUseCase(memberRepository: MemberRepository())
    private let tatekaeUseCase = TatekaeUseCase(tatekaeRepository: TatekaeRepository())
    private let warikanGroupArchiveController: WarikanGroupArchiveController = WarikanGroupArchiveController(
        warikanGroupRepository: WarikanGroupRepository(),
        archivedWarikanGroupRepository: ArchivedWarikanGroupRepository()
    )
    // privateにする
    let seisanCalculator: SeisanCalculator
    
    init(_ warikanGroupID: EntityID<WarikanGroup>) {
        self.warikanGroupID = warikanGroupID
        self.seisanCalculator = SeisanCalculator(memberRepository: MemberRepository())
    }
    
    func calculateTotalAmount() async -> String {
        do {
            let tatekaeList = try await warikanGroupUseCase.getTatekaeList(id: warikanGroupID)
            let tatekaeListTotalAmount = tatekaeList.reduce(0) { partialResult, tatekae in
                partialResult + tatekae.money
            }
            totalAmount = String(tatekaeListTotalAmount)
            return totalAmount ?? "合計金額がわかりません"
        } catch {
            // TODO: エラーハンドリングを記述
            return "合計金額を計算できませんでした"
        }
    }
    
    func makeConfirmViewModel() async throws {
        do {
            let warikanGroup = try await warikanGroupUseCase.getAll().first { $0.id == warikanGroupID }
            guard let warikanGroup else { return print("一致するIDが見つかりません") }
            warikanGroupDTO = try await ConfirmViewModel.WarikanGroupDTO.convert(
                warikanGroupUseCase: warikanGroupUseCase,
                memberUseCase: memberUseCase,
                warikanGroup: warikanGroup
            )
        } catch {
            print(error)
        }
    }
    
//    func archiveGroupAndNavigateToResult() {
//        Task {
//            _ = await archiveWarikanGroup(
//                id: warikanGroupID,
//                seisanList: seisanList, // ここでseisanListを取ってくる
//                unluckyMember: nil
//            )
//        }
//    }
    
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
    // Task内の処理のメソッド作成
}






// class ConfirmViewModel: ObservableObject {
//    private let warikanGroupID: EntityID<WarikanGroup>
//    var archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>?
//    // DTOに変更
//    @Published var selectedGroup: WarikanGroup?
//    @Published var selectedGroupMembers: [Member]?
//    @Published var selectedGroupTatekaes: [Tatekae]?
//    @Published var selectedGroupSeisanResponse: SeisanCalculator.SeisanResponse?
//    @Published private(set) var tatekaeDTOs: [TatekaeDTO]?
//    // ユースケース
//    private let warikanGroupArchiveController: WarikanGroupArchiveController
//    private let warikanGroupUseCase: WarikanGroupUseCase
//    private let memberUseCase: MemberUseCase
//    // privateにする
//    let seisanCalculator: SeisanCalculator
//
//    init(_ warikanGroupID: EntityID<WarikanGroup>) {
//        self.warikanGroupID = warikanGroupID
//        self.warikanGroupUseCase = WarikanGroupUseCase(
//            warikanGroupRepository: WarikanGroupRepository(),
//            memberRepository: MemberRepository(),
//            tatekaeRepository: TatekaeRepository()
//        )
//        self.warikanGroupArchiveController = WarikanGroupArchiveController(
//            warikanGroupRepository: WarikanGroupRepository(),
//            archivedWarikanGroupRepository: ArchivedWarikanGroupRepository()
//        )
//        self.memberUseCase = MemberUseCase(memberRepository: MemberRepository())
//        self.seisanCalculator = SeisanCalculator(memberRepository: MemberRepository())
//    }
//    
//    func makeConfirmViewModel() async {
//        do {
//            // TatekaeDTO
//            let tatekaes = try await warikanGroupUseCase.getTatekaeList(id: warikanGroupID)
//            let stringTatekae = tatekaes.map { TatekaeDTO.convert($0)}
//            tatekaeDTOs = stringTatekae
//            //
//        } catch {
//            print(error)
//        }
//    }
//    
//    // ConfirmViewに必要な割り勘グループ情報を取得する。
//    func getConfirmViewBuildingElements() async {
//        do {
//            try await selectedGroupTatekaes = warikanGroupUseCase.getTatekaeList(id: warikanGroupID)
//            guard let tatekaeList = selectedGroupTatekaes else {
//                return print("selectedGroupTatekaesがnilです。")
//            }
//            try await selectedGroupSeisanResponse = seisanCalculator.seisan(tatekaeList: tatekaeList)
//            let warikanGroups = try await warikanGroupUseCase.getAll()
//            let warikanGroup = warikanGroups.first { $0.id == warikanGroupID }
//            selectedGroup = warikanGroup
//            guard let memberIDs = selectedGroup?.members else {
//                return print("memberのIDsを取得できませんでした。")
//            }
//            let members = try await memberUseCase.get(ids: memberIDs)
//            selectedGroupMembers = members
//        } catch {
//            print(#function, error)
//        }
//    }
//    
//    // warikanGroupのIDを使って、archiveを作成する。
//    func archiveWarikanGroup(
//        id: EntityID<WarikanGroup>,
//        seisanList: [SeisanData],
//        unluckyMember: EntityID<Member>?
//    ) async {
//        do {
//            let id = try await warikanGroupArchiveController.archive(
//                id: id,
//                seisanList: seisanList,
//                unluckyMember: unluckyMember
//            )
//            archivedWarikanGroupID = id
//        } catch {
//            print(#function, error)
//        }
//    }
//    // Task内の処理のメソッド作成
//}
