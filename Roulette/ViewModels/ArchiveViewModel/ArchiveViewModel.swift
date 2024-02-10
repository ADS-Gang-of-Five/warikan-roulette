//
//  ArchiveViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class ArchiveViewModel: ObservableObject {
    @Published private(set) var archivedWarikanGroupDTOs: [ArchivedWarikanGroupDTO] = []
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
    
    func makeArchivedWarikanGroupDTO() async {
        do {
            let archivedWarikanGroupDataList = try await archivedWarikanGroupUseCase.getAll()
            self.archivedWarikanGroupDTOs = archivedWarikanGroupDataList
                .map { ArchivedWarikanGroupDTO.convert($0) }
        } catch {
            print(#function, error)
        }
    }
}
