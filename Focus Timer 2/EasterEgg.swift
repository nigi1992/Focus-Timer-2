//
//  EasterEgg.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 31.01.2026.
//

import SwiftUI

struct EasterEgg: View {
    //@EnvironmentObject var gameState: GameState
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isPresented: Bool
    //@State private var purchaseMessage: String?
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack() {
                // Header (fixed at top)

                    Text("🐣 Easter Egg\n\n ")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                    
                    //Spacer()
               
                    Text("Heil Hitler!\n\nScheiss Niggers!!!\n\nSieg Heil!\n\n69\n\n🍑🍆💦💦💦🤤")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .font(.system(size: 60))
            }
        }
        .padding(30)
        .frame(width: 420, height: 520)
        .background(
            colorScheme == .dark ? Color.black.opacity(0.35) : Color.white,
            in: RoundedRectangle(cornerRadius: 20)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.18) : Color.black.opacity(0.2), lineWidth: 1)
        )
        .shadow(radius: 20)
    }
}
