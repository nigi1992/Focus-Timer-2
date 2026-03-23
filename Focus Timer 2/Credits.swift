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
            
            VStack(spacing: 20) {
                // Header (fixed at top)
                HStack {
                    Text("📋 Credits")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
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
                        .foregroundColor(.secondary)
                
                    Spacer()
                
                    Image(systemName: "doc.on.clipboard")
                        .foregroundColor(.primary)
                        .background(Color.clear)
                
                //.frame(maxHeight: 350)
            //.background(Color.white)
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
