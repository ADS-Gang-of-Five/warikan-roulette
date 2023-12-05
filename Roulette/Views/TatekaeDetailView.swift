//
//  TatekaeDetailView.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/05.
//

import SwiftUI

struct TatekaeDetailView: View {
    @Binding var isShowTatekaeDetailView: Bool
    
    var body: some View {
        ZStack {
            List {
                Section {
                    Text("朝食")
                } header: {
                    Text("立替の名目")
                }
                Section {
                    Text("5,000円")
                } header: {
                    Text("立替の金額")
                }
                Section {
                    Text("Maki")
                } header: {
                    Text("立替人")
                }
                Section {
                    Text("2023年12月5日 10:00")
                } header: {
                    Text("日時")
                }
            }
            
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Button("戻る") {
                        isShowTatekaeDetailView = false
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.blue)
                    .clipShape(Capsule(), style: FillStyle())
                    .padding(.trailing)
                    .padding(.bottom)
                }
            }
        }
    }
}


#Preview {
    TatekaeDetailView(isShowTatekaeDetailView: Binding.constant(true))
}
