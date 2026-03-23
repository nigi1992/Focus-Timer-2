//
//  ShopView.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 30.01.2026.
//

// Building Shop - Purchasing buildings with earned money

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isPresented: Bool
    @State private var purchaseMessage: String?
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 20) {
                // Header (fixed at top)
                HStack {
                    Text("🏗️ Building Shop")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.green)
                        Text("$\(gameState.money)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                
                Divider()
                
                // Scrollable building grid
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(BuildingType.allCases, id: \.self) { buildingType in
                            BuildingCard(
                                buildingType: buildingType,
                                cost: gameState.buildingCosts[buildingType] ?? 0,
                                canAfford: gameState.canAfford(buildingType),
                                onPurchase: {
                                    if gameState.purchaseBuilding(buildingType) {
                                        purchaseMessage = "Built \(buildingType.emoji) \(buildingType.rawValue)!"
                                        
                                        // Clearing message after delay
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            purchaseMessage = nil
                                        }
                                    }
                                }
                            )
                        }
                    }
                    .padding(.bottom, 10)
                }
                .frame(maxHeight: 350)
                
                // Purchase confirmation
                if let message = purchaseMessage {
                    Text(message)
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
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
}

struct BuildingCard: View {
    let buildingType: BuildingType
    let cost: Int
    let canAfford: Bool
    let onPurchase: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text(buildingType.emoji)
                .font(.system(size: 40))
            
            Text(buildingType.rawValue)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Image(systemName: "dollarsign.circle")
                    .foregroundColor(canAfford ? .green : .gray)
                Text("\(cost)")
                    .fontWeight(.semibold)
                    .foregroundColor(canAfford ? .green : .gray)
            }
            .font(.subheadline)
            
            Text("+\(buildingType.populationBonus) 👥")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button("Buy") {
                onPurchase()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!canAfford)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(canAfford ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(canAfford ? Color.green.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
