//
//  ArchiveView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/04.
//

import SwiftUI

struct ArchiveView: View {
    let groups: [String]
    
    init(groups: [String] = ["Gang of Five", "ひなっこクラブ", "アプリ道場サロン"]) {
        self.groups = groups
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if groups != [] {
                    List {
                        ForEach(groups, id: \.self) { group in
                            NavigationLink(group) {
                                ArchivedSeisanResultView()
                                    .navigationTitle("清算結果")
                            }
                        }
                    }
                } else {
                    Text("清算済割り勘グループはありません。")
                        .font(.title2)
                        .padding(.horizontal, 30)
                }
            }
            .navigationTitle("清算済割り勘グループ")
        }
    }
}

#Preview {
    ArchiveView()
}
