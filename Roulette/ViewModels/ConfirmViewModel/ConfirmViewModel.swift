//
//  ConfirmViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class ConfirmViewModel: ObservableObject {
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
    private let seisanCalculator: SeisanCalculator
    
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
            guard let totalAmount = totalAmount else { return "計算に失敗しました"}
            return totalAmount
        } catch {
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

    // 清算レスポンスの結果に応じてunluckyMemberの書き換えを行う。
    func archiveGroupAndNavigateToResult() async {
        do {
            let tatekaeList = try await warikanGroupUseCase.getTatekaeList(id: warikanGroupID)
            let seisan = try await seisanCalculator.seisan(tatekaeList: tatekaeList)
            selectedGroupSeisanResponse = seisan
            switch selectedGroupSeisanResponse {
            case .needsUnluckyMember:
                unluckyMember = true
            case .success(let seisanList):
                unluckyMember = false
                 await archiveWarikanGroup(id: self.warikanGroupID, seisanList: seisanList, unluckyMember: nil)
            case .none:
                print("レスポンスの取得に失敗しました。")
            }
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
