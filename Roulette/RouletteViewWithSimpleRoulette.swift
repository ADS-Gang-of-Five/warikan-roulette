//
//  RouletteViewWithSimpleRoulette.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/11/10.
//

import SwiftUI
import SimpleRoulette

struct RouletteViewWithSimpleRoulette: View {
    @StateObject var model: RouletteModel = RouletteModel(parts: [
        PartData(
            content: .label("Swift"),
            area: .flex(120),
            fillColor: Color.pink
        ),
        PartData(
            content: .label("Kotlin"),
            area: .flex(120),
            fillColor: Color.blue
        ),
        PartData(
            content: .label("JavaScript"),
            area: .flex(120),
            fillColor: Color.green
//            strokeColor: .orange,
//            lineWidth: 10
        )
    ])
    
    var body: some View {
        VStack {
            RouletteView(model: model)
            
            HStack {
                Button {
                    model.start()
                } label: {
                    Text("Start")
                }
                .buttonStyle(.borderedProminent)
                .tint(.gray)
                                
                Button {
                    model.stop()
                } label: {
                    Text("Stop")
                }
                .buttonStyle(.borderedProminent)
                .tint(.gray)
                .padding(.leading)
                
                Button {
                    ViewRouter.shared.changeView(to: .RouletteViewWithCharts)
                } label: {
                    Text("Next")
                }
                .buttonStyle(.borderedProminent)
                .padding(.leading)
            }
            .padding(.top)
        }
    }
}

#Preview {
    RouletteViewWithSimpleRoulette()
}
