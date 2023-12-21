//
//  MapToDataExtensions.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/21
//  
//

import Foundation

extension [Seisan] {
    func mapToData(withMemberRepository memberRepository: MemberRepositoryProtocol) async throws -> [SeisanData] {
        var seisanDataList: [SeisanData] = []
        for seisan in self {
            let seisanData = try await SeisanData.create(from: seisan, memberRepository: memberRepository)
            seisanDataList.append(seisanData)
        }
        return seisanDataList
    }
}

extension [ArchivedWarikanGroup] {
    func mapToData(withMemberRepository memberRepository: MemberRepositoryProtocol) async throws -> [ArchivedWarikanGroupData] {
        var dataList: [ArchivedWarikanGroupData] = []
        for archivedWarikanGroup in self {
            let data = try await ArchivedWarikanGroupData.create(
                from: archivedWarikanGroup,
                memberRepository: memberRepository
            )
            dataList.append(data)
        }
        return dataList
    }
}
