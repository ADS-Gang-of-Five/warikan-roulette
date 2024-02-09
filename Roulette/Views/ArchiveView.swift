//
//  ArchiveView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct ArchiveView: View {
    @StateObject private var archiveViewModel = ArchiveViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if !archiveViewModel.archivedWarikanGroupDataList.isEmpty {
                    List(archiveViewModel.archivedWarikanGroupDataList) { data in
                        NavigationLink(data.groupName) {
                            ArchivedSeisanResultView(archivedWarikanGroupID: data.id)
                        }
                    }
                } else {
                    Text("清算済割り勘グループはありません。")
                        .font(.title2)
                        .padding(.horizontal, 30)
                }
            }
            .navigationTitle("清算済割り勘グループ")
            .task {
                await archiveViewModel.getArchivedWarikanGroupDataList()
            }
        }
    }
}

#Preview {
    ArchiveView()
}
