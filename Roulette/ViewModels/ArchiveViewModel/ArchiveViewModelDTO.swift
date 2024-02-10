// swiftlint:disable:this file_name
//
//  ArchiveViewModelDTO.swift
//  Roulette
//
//  Created by Masaki Doi on 2024/02/10.
//

import Foundation

extension ArchiveViewModel {
    struct ArchivedWarikanGroupDTO: Identifiable {
        let name: String
        let id: EntityID<ArchivedWarikanGroup>

        private init(name: String, id: EntityID<ArchivedWarikanGroup>) {
            self.name = name
            self.id = id
        }

        static func convert(_ archivedWarikanGroupData: ArchivedWarikanGroupData) -> Self {
            let name = archivedWarikanGroupData.groupName
            let id = archivedWarikanGroupData.id
            return ArchivedWarikanGroupDTO(name: name, id: id)
        }
    }
}
