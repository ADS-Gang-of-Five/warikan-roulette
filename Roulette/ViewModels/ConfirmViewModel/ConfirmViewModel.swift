//
//  ConfirmViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class ConfirmViewModel: ObservableObject {
    private let warikanGroupUseCase = WarikanGroupUseCase(
        warikanGroupRepository: WarikanGroupRepository(),
        memberRepository: MemberRepository(),
        tatekaeRepository: TatekaeRepository()
    )
    private let memberUseCase = MemberUseCase(memberRepository: MemberRepository())
    private let tatekaeUseCase = TatekaeUseCase(tatekaeRepository: TatekaeRepository())
    private let archiveController = WarikanGroupArchiveController(
        warikanGroupRepository: WarikanGroupRepository(),
        archivedWarikanGroupRepository: ArchivedWarikanGroupRepository()
    )
    private let seisanCalculator = SeisanCalculator(memberRepository: MemberRepository())

    @Published private(set) var warikanGroupDTO: WarikanGroupDTO?
    @Published private(set) var seisanResponse: SeisanCalculator.SeisanResponse?
    let warikanGroupID: EntityID<WarikanGroup>
    private(set) var archivedWarikanGroupID: EntityID<ArchivedWarikanGroup>?
    @Published var isShowAlert = false
    let alertText = "エラーが発生しました。前の画面に戻りもう一度お試しください。"
    init(warikanGroupID: EntityID<WarikanGroup>) {
        self.warikanGroupID = warikanGroupID
    }

    func didTappedNavigateToSeisanResultViewButton(
        completionHandler: @escaping (ViewRouter.Path) -> Void
    ) {
        Task {
            do {
                try await archiveWarikanGroup()
                guard let archivedWarikanGroupID = self.archivedWarikanGroupID else {
                    throw NSError(
                        domain: "直前にアーカイブを行ったのにも関わらず、ConfirmViewModelにEntityID<ArchivedWarikanGroup>が保持されていない。",
                        code: 0
                    )
                }
                completionHandler(ViewRouter.Path.seisanResultView(archivedWarikanGroupID))
            } catch {
                print(error)
                isShowAlert = true
            }
        }
    }

    private func archiveWarikanGroup() async throws {
        guard let seisanResponse,
              case SeisanCalculator.SeisanResponse.success(let seisanDataList) = seisanResponse
        else { return }
        self.archivedWarikanGroupID = try await archiveController.archive(
            id: warikanGroupID,
            seisanList: seisanDataList,
            unluckyMember: nil
        )
    }

    func onAppearAction() async {
        do {
            try await makeWarikanGroupDTO()
            try await checkIsNeedUnluckyMember()
        } catch {
            print(error)
            isShowAlert = true
        }
    }

    private func makeWarikanGroupDTO() async throws {
        let allWarikanGroup = try await warikanGroupUseCase.getAll()
        guard let warikanGroup = allWarikanGroup.first(where: { warikanGroup in
            warikanGroup.id == self.warikanGroupID
        }) else { throw NSError(domain: "not found", code: 0) }
        self.warikanGroupDTO = try await WarikanGroupDTO.convert(
            warikanGroup: warikanGroup,
            memberUseCase: memberUseCase,
            tatekaeUseCase: tatekaeUseCase
        )
    }

    private func checkIsNeedUnluckyMember() async throws {
        let allWarikanGroups = try await warikanGroupUseCase.getAll()
        guard let warikanGroup = allWarikanGroups.first(where: { warikanGroup in
            warikanGroup.id == self.warikanGroupID
        }) else { throw NSError(domain: "not found", code: 404) }
        let tatekaeList = try await tatekaeUseCase.get(ids: warikanGroup.tatekaeList)
        self.seisanResponse = try await seisanCalculator.seisan(tatekaeList: tatekaeList)
    }
}
