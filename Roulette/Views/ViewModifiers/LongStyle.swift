//
//  LongStyle.swift
//  Roulette
//
//  Created by Masaki Doi on 2023/12/07.
//

import SwiftUI

struct LongStyle: ViewModifier {
   @Binding var isButtonDisabled: Bool
   func body(content: Content) -> some View {
       content
           .font(.title2)
           .fontWeight(.bold)
           .frame(height: 60)
           .frame(maxWidth: .infinity)
           .foregroundStyle(.white)
           .background(isButtonDisabled ? .gray : .blue)
           .clipShape(Capsule())
           .padding(.horizontal)
           .padding(.horizontal)
   }
}
