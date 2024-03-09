//
//  SeisanResultViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

final class SeisanResultViewModel: SeisanResultViewModelProtocol {
    private let archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>
    @Published private(set) var archivedWarikanGroup: ArchivedWarikanGroupDTO?
    private let archivedWarikanGroupUseCase: ArchivedWarikanGroupUseCase
    private let memberUseCase: MemberUseCase
    private let tatekaeUseCase: TatekaeUseCase
    @Published var isShowingAlert = false
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

    func reload() async {
        do {
            let archivedWarikanGroupData = try await archivedWarikanGroupUseCase.get(id: archivedWarikanGroupID)
            self.archivedWarikanGroup = try await makeArchivedWarikanGroupDTO(
                archivedWarikanGroupData,
                tatekaeUsecase: tatekaeUseCase,
                memberUsecase: memberUseCase
            )
        } catch {
            self.isShowingAlert = true
        }
    }
}

private extension SeisanResultViewModel {
    func makeArchivedWarikanGroupDTO(
        _ archivedWarikanGroupData: ArchivedWarikanGroupData,
        tatekaeUsecase: TatekaeUseCase,
        memberUsecase: MemberUseCase
    ) async throws -> ArchivedWarikanGroupDTO {
        let name = archivedWarikanGroupData.groupName
        let tatekaes = try await tatekaeUsecase.get(
            ids: archivedWarikanGroupData.tatekaeList
        )
        let tatekaeList = tatekaes.map { $0.name }
        let totalAmount = tatekaes.reduce(0) { partialResult, tatekae in
            partialResult + tatekae.money
        }
        var unluckyMember: String?
        if let unluckyMemberID = archivedWarikanGroupData.unluckyMember {
            unluckyMember = try await memberUsecase.get(id: unluckyMemberID).name
        }
        let seisanList = archivedWarikanGroupData.seisanList.map {
            makeSeisanDTO(seisanData: $0)
        }
        return ArchivedWarikanGroupDTO(
            name: name,
            tatekaeList: tatekaeList,
            totalAmount: totalAmount,
            unluckyMember: unluckyMember,
            seisanList: seisanList
        )
    }
    
    func makeSeisanDTO(seisanData: SeisanData) -> SeisanDTO {
        let debtor = seisanData.debtor.name
        let creditor = seisanData.creditor.name
        let money = seisanData.money
        return .init(debtor: debtor, creditor: creditor, money: money)
    }
}
