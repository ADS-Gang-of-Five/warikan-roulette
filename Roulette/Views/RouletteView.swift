//
//  RouletteView.swift
//  Roulette
//
//  Created by sako0602 on 2023/12/05.
//

import SwiftUI
import Charts

//TODO: ルーレットが回った後に、backできない使用に変更する。
struct RouletteView: View {
    private var members = [
        (name: "A", count: 100),
        (name: "B", count: 100),
        (name: "C", count: 100),
        (name: "D", count: 100),
        (name: "E", count: 100),
        (name: "F", count: 100),
        (name: "G", count: 100),
        
    ]
    @State private var angle = Angle(degrees: 0.0)
    
    var body: some View {
        VStack {
            Image(systemName: "triangleshape.fill")
                .rotationEffect(Angle(degrees: 180.0))
                .foregroundStyle(.red)
                .scaleEffect(1.3)
            Chart {
                ForEach(members, id: \.name) { member in
                    SectorMark(
                        angle: .value("", member.count),
                        innerRadius:  MarkDimension.ratio(0.5),
                        angularInset: 1
                    )
                    .cornerRadius(5)
                    .foregroundStyle(by: .value("", member.name))
                    .annotation(position: .overlay) {
                        Text(member.name)
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                }
            }
            .chartLegend(.hidden)
            .rotationEffect(angle)
            .frame(width: 300, height: 300)
            .padding(.top, 3)
            Button {
                angle = .zero
                withAnimation(.spring(duration: 10)) {
                    angle = .degrees(18000.0)
                }
            } label: {
                Text("Start")
            }
            .buttonStyle(.borderedProminent)
            .tint(.gray)
            .padding(.top)
            NavigationLink("Next", value: Path.rouletteResultView)
                .buttonStyle(.borderedProminent)
                .padding(.top)
        }
    }
}

#Preview {
    RouletteView()
}
