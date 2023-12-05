//
//  ConfirmView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/04.
//

import SwiftUI

struct ConfirmView: View {
    let members = ["ひな", "さこ", "かい", "せいげつ", "まき", "じょにー"]
    
    var body: some View {
            VStack{
                Spacer()
                ZStack {
                    VStack(alignment: .leading) {
                        Text("昼飯")
                            .font(.title2)
                            .fontWeight(.medium)
                        Text("合計 1801円")
                        
                        
                        VStack {
                            ForEach(members, id: \.self) { member in
                                HStack {
                                    Text(member)
                                    Spacer()
                                    Text("300円")
                                }
                            }
                            Divider()
                            HStack {
                                Text("端数")
                                Spacer()
                                Text("1円")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.red)
                            }
                        }
                        .padding(.top)
                    }
                    .font(.title)
                    .padding(.horizontal, 50)
                }
                Spacer()
                NavigationLink("端数ルーレットする", value: Path.tatekaeListView)
                    .modifier(LongStyle())
                    .padding(.bottom, 1)
            }
    }
}


#Preview {
    ConfirmView()
}
