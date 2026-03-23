//
//  BuildingType.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 30.01.2026.
//


// Data models for buildings and island elements

import Foundation

enum BuildingType: String, CaseIterable, Codable {
    case tent = "Tent"
    case hut = "Hut"
    case house = "House"
    case farm = "Farm"
    case market = "Market"
    case library = "Library"
    case townHall = "Town Hall"
    case lighthouse = "Lighthouse"
    case castle = "Castle"
    
    var emoji: String {
        switch self {
        case .tent: return "⛺️"
        case .hut: return "🛖"
        case .house: return "🏠"
        case .farm: return "🌾"
        case .market: return "🏪"
        case .library: return "📚"
        case .townHall: return "🏛️"
        case .lighthouse: return "🗼"
        case .castle: return "🏰"
        }
    }
    
    var populationBonus: Int {
        switch self {
        case .tent: return 1
        case .hut: return 2
        case .house: return 5
        case .farm: return 3
        case .market: return 8
        case .library: return 4
        case .townHall: return 15
        case .lighthouse: return 6
        case .castle: return 25
        }
    }
}

struct Building: Identifiable, Codable {
    let id: UUID
    let type: BuildingType
    let completedAt: Date
    
    // Providing default UUID in initializer instead of property declaration
    init(id: UUID = UUID(), type: BuildingType, completedAt: Date) {
        self.id = id
        self.type = type
        self.completedAt = completedAt
    }
}
