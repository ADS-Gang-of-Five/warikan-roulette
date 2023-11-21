//
//  Extention.swift
//  Roulette
//
//  Created by sako0602 on 2023/11/20.
//

import Foundation
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

