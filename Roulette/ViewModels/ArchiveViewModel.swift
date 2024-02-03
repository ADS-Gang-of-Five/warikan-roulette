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
    private let memberUseCase: MemberUseCase
    private let tatekaeUseCase: TatekaeUseCase
    
    init() {
        let memberUseCase = MemberUseCase(memberRepository: MemberRepository())
        let tatekaeUseCase = TatekaeUseCase(tatekaeRepository: TatekaeRepository())
        let archivedWarikanGroupUseCase = ArchivedWarikanGroupUseCase(
            archivedWarikanGroupRepository: ArchivedWarikanGroupRepository(),
            memberRepository: MemberRepository()
        )
        
        self.archivedWarikanGroupUseCase = archivedWarikanGroupUseCase
        self.memberUseCase = memberUseCase
        self.tatekaeUseCase = tatekaeUseCase
    }
    
    func getArchivedWarikanGroupDataList() async {
        do {
            archivedWarikanGroupDataList = try await archivedWarikanGroupUseCase.getAll()
        } catch {
            print(#function, error)
        }
    }
}
