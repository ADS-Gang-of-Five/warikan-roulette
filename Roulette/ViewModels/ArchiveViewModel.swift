//
//  ArchiveViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class ArchiveViewModel: ObservableObject {
    @Published private(set) var archivedWarikanGroupDataList: [ArchivedWarikanGroupData] = []
    private let archivedWarikanGroupUseCase: ArchivedWarikanGroupUseCase
    private let memberUsecase: MemberUsecase
    private let tatekaeUsecase: TatekaeUsecase
    
    init() {
        let memberUsecase = MemberUsecase(memberRepository: MemberRepository())
        let tatekaeUsecase = TatekaeUsecase(tatekaeRepository: TatekaeRepository())
        let archivedWarikanGroupUseCase = ArchivedWarikanGroupUseCase(
            archivedWarikanGroupRepository: ArchivedWarikanGroupRepository(),
            memberRepository: MemberRepository()
        )
        
        self.archivedWarikanGroupUseCase = archivedWarikanGroupUseCase
        self.memberUsecase = memberUsecase
        self.tatekaeUsecase = tatekaeUsecase
    }
    
    func getArchivedWarikanGroupDataList() async {
        do {
            archivedWarikanGroupDataList = try await archivedWarikanGroupUseCase.getAll()
        } catch {
            print(#function, error)
        }
    }
}
