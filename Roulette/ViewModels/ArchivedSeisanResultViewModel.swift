//
//  ArchivedSeisanResultViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2024/01/30.
//

import Foundation

struct SeisanDTO {
    let debtor: String
    let creditor: String
    let money: String

    private init(
        debtor: String,
        creditor: String,
        money: String
    ) {
        self.debtor = debtor
        self.creditor = creditor
        self.money = money
    }

    static func convert(_ seisanData: SeisanData) -> Self {
        let debtor = seisanData.debtor.name
        let creditor = seisanData.creditor.name
        let money = seisanData.money.description
        return SeisanDTO(debtor: debtor, creditor: creditor, money: money)
    }
}

struct ArchivedWarikanGroupDTO {
    let name: String
    let tatekaeList: [String]
    let totalAmount: String
    let unluckyMember: String?
    let seisanList: [SeisanDTO]
}

@MainActor
final class ArchivedSeisanResultViewModel: ObservableObject {
    private let archivedWarikanGroupData: ArchivedWarikanGroupData
    @Published private(set) var archivedWarikanGroupDTO: ArchivedWarikanGroupDTO?
    private let archivedWarikanGroupUseCase: ArchivedWarikanGroupUseCase
    private let memberUsecase: MemberUsecase
    private let tatekaeUsecase: TatekaeUsecase

    init(archivedWarikanGroupData: ArchivedWarikanGroupData) {
        self.archivedWarikanGroupData = archivedWarikanGroupData
        self.archivedWarikanGroupUseCase = ArchivedWarikanGroupUseCase(
            archivedWarikanGroupRepository: ArchivedWarikanGroupRepository(),
            memberRepository: MemberRepository()
        )
        self.memberUsecase = MemberUsecase(memberRepository: MemberRepository())
        self.tatekaeUsecase = TatekaeUsecase(tatekaeRepository: TatekaeRepository())
    }

    // `archivedWarikanGroupDTO`の生成を行う関数
    func getArchivedWarikanGroupDTO() async {
        // nameプロパティの準備
        let name = archivedWarikanGroupData.groupName
        // tatekaeListプロパティの準備
        let tatekaes = try! await tatekaeUsecase.get(
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
            unluckyMember = try! await memberUsecase.get(id: unluckyMemberID)?.name
        }
        // seisanListプロパティの準備
        let seisanList = archivedWarikanGroupData.seisanList.map { seisanData in
            SeisanDTO.convert(seisanData)
        }
        // `ArchivedWarikanGroupDTO`の生成
        let archivedWarikanGroupDTO = ArchivedWarikanGroupDTO(
            name: name,
            tatekaeList: tatekaeList,
            totalAmount: totalAmount.description,
            unluckyMember: unluckyMember,
            seisanList: seisanList
        )
        self.archivedWarikanGroupDTO = archivedWarikanGroupDTO
    }
}
