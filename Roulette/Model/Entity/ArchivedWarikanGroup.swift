//
//  ArchivedWarikanGroup.swift
//  Roulette
//  
//  Created by Seigetsu on 2023/12/08
//  
//

import Foundation

struct ArchivedWarikanGroup: Identifiable, Codable {
    var id: EntityID<Self>
    private(set) var name: String
    private(set) var members: [EntityID<Member>]
    private(set) var tatekaeList: [EntityID<Tatekae>]
    private(set) var unluckyMember: EntityID<Member>?
    private(set) var seisanList: [Seisan]
}
