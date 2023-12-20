//
//  LongStyle.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import SwiftUI

struct LongStyle: ViewModifier {
   func body(content: Content) -> some View {
       content
           .font(.title2)
           .fontWeight(.bold)
           .frame(height: 60)
           .frame(maxWidth: .infinity)
           .foregroundStyle(.white)
           .background(.blue)
           .clipShape(Capsule())
           .padding(.horizontal)
           .padding(.horizontal)
   }
}
