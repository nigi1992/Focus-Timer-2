//
//  EasterEgg.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 31.01.2026.
//

import SwiftUI

struct EasterEgg: View {
    //@EnvironmentObject var gameState: GameState
    @Binding var isPresented: Bool
    //@State private var purchaseMessage: String?
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.white.opacity(0.05)
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
                        .foregroundColor(.black)
                        .font(.system(size: 60))
            }
        }
        .padding(30)
        .frame(width: 420, height: 520)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}
