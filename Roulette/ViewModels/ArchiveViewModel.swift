//
//  ArchiveViewModel.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import Foundation

@MainActor
final class ArchiveViewModel: ObservableObject {
    @Published private(set) var archivedWarikanGroupsDataList: [ArchivedWarikanGroupData] = []
    
    private let archivedWarikanGroupUseCase: ArchivedWarikanGroupUseCase
    private let memberUsecase: MemberUsecase
    private let tatekaeUsecase: TatekaeUsecase
    
    init() {
        let memberRepository = MemberRepository(userDefaultsKey: "member")
        let memberUsecase = MemberUsecase(memberRepository: memberRepository)
        
        let tatekaeRepository = TatekaeRepository(userDefaultsKey: "tatekae")
        let tatekaeUsecase = TatekaeUsecase(tatekaeRepository: tatekaeRepository)
        
        let archivedWarikanGroupRepository = ArchivedWarikanGroupRepository(userDefaultsKey: "archivedWarikanGroup")
        let archivedWarikanGroupUseCase = ArchivedWarikanGroupUseCase(
            archivedWarikanGroupRepository: archivedWarikanGroupRepository,
            memberRepository: memberRepository
        )
        
        self.archivedWarikanGroupUseCase = archivedWarikanGroupUseCase
        self.memberUsecase = memberUsecase
        self.tatekaeUsecase = tatekaeUsecase
    }
    
    func getAllArchivedWarikanGroups() async {
        do {
            archivedWarikanGroupsDataList = try await archivedWarikanGroupUseCase.getAll()
        } catch {
            print(#function, error)
        }
    }
}
