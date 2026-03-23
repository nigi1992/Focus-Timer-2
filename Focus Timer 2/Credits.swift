//
//  Credits.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 31.01.2026.
//

// Building Shop - Purchasing buildings with earned money

import SwiftUI

struct Credits: View {
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
            
            VStack(spacing: 20) {
                // Header (fixed at top)
                HStack {
                    Text("📋 Credits")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                    
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                            //.background(Color.clear)
                            .buttonStyle(.plain)
                    }
                }
                    Spacer()
                    Text("This Game was built by:\n\nHerr Labubu\nProfessor Chaos\nBiggus Diggus\nSchlongus Maximus\n\nWith the generous help of:\n\nKitty Titty\nNigahaga\nBalla Balla\n\n&\n\nAdolf Hitler")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                
                    Spacer()
                
                    Image(systemName: "doc.on.clipboard")
                        .foregroundColor(.black)
                        .background(Color.clear)
                
                //.frame(maxHeight: 350)
            //.background(Color.white)
            }
        }
        .padding(30)
        .frame(width: 420, height: 520)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

