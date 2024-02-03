//
//  ArchivedSeisanResultViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2024/01/30.
//

import Foundation

@MainActor
final class ArchivedSeisanResultViewModel: ObservableObject {
    private let archivedWarikanGroupData: ArchivedWarikanGroupData
    @Published private(set) var viewData: ViewData?
    private let archivedWarikanGroupUseCase: ArchivedWarikanGroupUseCase
    private let memberUseCase: MemberUseCase
    private let tatekaeUseCase: TatekaeUseCase

    // Viewが必要とする割り勘グループのデータ
    struct ViewData {
        let tatekaeList: [String]
        let totalAmount: String
        let unluckyMember: String?
        let seisanList: [(debtor: String, creditor: String, money: String)]
        // swiftlint:disable:previous large_tuple
    }

    init(archivedWarikanGroupData: ArchivedWarikanGroupData) {
        self.archivedWarikanGroupData = archivedWarikanGroupData
        self.archivedWarikanGroupUseCase = ArchivedWarikanGroupUseCase(
            archivedWarikanGroupRepository: ArchivedWarikanGroupRepository(),
            memberRepository: MemberRepository()
        )
        self.memberUseCase = MemberUseCase(memberRepository: MemberRepository())
        self.tatekaeUseCase = TatekaeUseCase(tatekaeRepository: TatekaeRepository())
    }

    // `ViewData`の生成を行う関数
    func getGroupData() async {
        // tatekaeListプロパティの準備
        let tatekaes = try! await tatekaeUseCase.get(
            ids: archivedWarikanGroupData.tatekaeList
        )
        let tatekaeList = tatekaes.map { $0.name }
        // totalAmountプロパティの準備
        let totalAmount = tatekaes.reduce(0) { partialResult, tatekae in
            partialResult + tatekae.money
        }
        // unluckyMemberプロパティの準備
        var unluckyMember: String?
        if let unluckyMemberID = archivedWarikanGroupData.unluckyMember {
            unluckyMember = try! await memberUseCase.get(id: unluckyMemberID)?.name
        }
        // seisanListプロパティの準備
        let seisanList = archivedWarikanGroupData.seisanList.map { seisanData in
            let debtor = seisanData.debtor
            let creditor = seisanData.creditor
            let money = seisanData.money.description
            return (debtor: debtor.name, creditor: creditor.name, money: money)
        }
        // `ViewData`の生成
        let viewData = ViewData(
            tatekaeList: tatekaeList,
            totalAmount: totalAmount.description,
            unluckyMember: unluckyMember,
            seisanList: seisanList
        )
        self.viewData = viewData
    }
}
