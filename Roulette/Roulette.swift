////
////  Roulette.swift
////  Roulette
////
////  Created by Masaki Doi on 2023/11/08.
////
//
//import SwiftUI
//import SimpleRoulette
//
//var partDatas: [PartData] {
//    [
//        PartData(
//            content: .label("Swift"),
//            area: .flex(3),
//            fillColor: Color.red
//        ),
//        PartData(
//            content: .label("Kotlin"),
//            area: .flex(1),
//            fillColor: Color.purple
//        ),
//        PartData(
//            content: .label("JavaScript"),
//            area: .flex(2),
//            fillColor: Color.yellow
//        ),
//        PartData(
//            content: .label("Dart"),
//            area: .flex(1),
//            fillColor: Color.green
//        ),
//        PartData(
//            content: .label("Python"),
//            area: .flex(2),
//            fillColor: Color.blue
//        ),
//        PartData(
//            content: .label("C++"),
//            area: .degree(60),
//            fillColor: Color.orange
//        ),
//    ]
//}
//
//struct Roulette: View {
//    @State var title = ""
//    
//    var body: some View {
//        VStack {
//            RouletteView(
//                parts: partDatas
//            )
//            .startOnAppear(automaticallyStopAfter: 5) { part in
//                guard let text = part.content.text else {
//                    return
//                }
//                title = text
//            }
//        }
//        
//    }
//}
//
//#Preview {
//    Roulette()
//}
