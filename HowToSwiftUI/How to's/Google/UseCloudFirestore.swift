//
//  UseCloudFirestore.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 5/11/23.
//

import SwiftUI

struct UseCloudFirestore: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        //
    }
}

struct UseCloudFirestore_Previews: PreviewProvider {
    static var previews: some View {
        UseCloudFirestore()
    }
}

/*
// Quest model
struct Quest {
    let id: Int
    let name: String
    let themedCategory: ThemedCategory
}

// Themed category model
struct ThemedCategory {
    let id: Int
    let name: String
    let tasks: [Task]
}

// Task model
struct Task {
    let id: Int
    let name: String
    let geofencedAreas: [GeofencedArea]
    let virtualEasterEggs: [VirtualEasterEgg]
    let inPersonEasterEggs: [InPersonEasterEgg]
    let brandPartnerQRCodes: [BrandPartnerQRCode]
    let trivia: [Trivia]
    let dailyDoubles: [DailyDouble]
    let clues: [Clue]
    let augmentedRealityExperiences: [AugmentedRealityExperience]
}

// Geofenced area model
struct GeofencedArea {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let radius: Double
}

// Virtual Easter egg model
struct VirtualEasterEgg {
    let id: Int
    let name: String
    let imageUrl: String
}

// In-person Easter egg model
struct InPersonEasterEgg {
    let id: Int
    let name: String
    let location: String
}

// Brand partner QR code model
struct BrandPartnerQRCode {
    let id: Int
    let name: String
    let imageUrl: String
}

// Trivia model
struct Trivia {
    let id: Int
    let question: String
    let answer: String
}

// Daily double model
struct DailyDouble {
    let id: Int
    let question: String
    let answer: String
    let value: Int
}

// Clue model
struct Clue {
    let id: Int
    let question: String
    let answer: String
}

// Augmented reality experience model
struct AugmentedRealityExperience {
    let id: Int
    let name: String
    let imageUrl: String
}

// Coin model
struct Coin {
    let id: Int
    let amount: Int
}

// Prize model
struct Prize {
    let id: Int
    let name: String
    let type: PrizeType
}

// Prize type enumeration
enum PrizeType {
    case physical
    case experience
    case legendaryExperience
}

// User-generated content model
struct UserGeneratedContent {
    let id: Int
    let images: [String]
    let videos: [String]
    let text: String
    let testimonials: [String]
}

// Brand sponsor model
struct BrandSponsor {
    let id: Int
    let name: String
    let revenueModel: RevenueModel
    let subscriptionFeatures: [String]
}

// Revenue model enumeration
enum RevenueModel {
    case freemium
    case subscription
}

// Team model
struct Team {
    let id: Int
    let name: String
    let members: [User]
    let coinPool: Coin
}

// User model
struct User {
    let id: Int
    let name: String
    let coins: [Coin]
    let prizes: [Prize]
    let ugc: UserGeneratedContent
    let teams: [Team]
}
*/


/*
struct Quest: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let tasks: [Task]
}

struct Task: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let geofencedAreas: [GeofencedArea]
    let virtualEasterEggs: [VirtualEasterEgg]
    let inPersonEasterEggs: [InPersonEasterEgg]
    let brandPartnerQRCodes: [BrandPartnerQRCode]
    let trivia: [Trivia]
    let dailyDoubles: [DailyDouble]
    let clues: [Clue]
    let augmentedRealityExperiences: [AugmentedRealityExperience]
}

struct GeofencedArea: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let latitude: Double
    let longitude: Double
    let radius: Double
}

struct VirtualEasterEgg: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageUrl: URL
}

struct InPersonEasterEgg: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let location: String
}

struct BrandPartnerQRCode: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageUrl: URL
}

struct Trivia: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct DailyDouble: Identifiable {
    let id = UUID()
    let category: String
    let value: Int
    let clue: String
    let answer: String
}

struct Clue: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let location: String
}

struct AugmentedRealityExperience: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let arModelUrl: URL
}

struct Coin: Identifiable {
    let id = UUID()
    let amount: Int
    let earnedBy: [CoinEarnedMethod]
}

enum CoinEarnedMethod {
    case completingTasks
    case uploadingUGC
    case invitingFriends
    case sharingUGCOnSocialMedia
    case groupPurchases
}

struct Prize: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let type: PrizeType
}

enum PrizeType {
    case physicalItem
    case experience
    case legendaryExperience
}

struct UserGeneratedContent: Identifiable {
    let id = UUID()
    let type: UGCType
    let title: String
    let description: String
    let imageUrl: URL?
    let videoUrl: URL?
    let text: String?
    let testimonial: String?
}

enum UGCType {
    case image
    case video
    case text
    case testimonial
}

struct BrandSponsor: Identifiable {
    let id = UUID()
    let name: String
    let revenueModel: RevenueModel
}

enum RevenueModel {
    case freemium
    case subscriptionBased
}

struct Team: Identifiable {
    let id = UUID()
    let name: String
    let members: [User]
    let coinPool: Int
}

struct User: Identifiable {
    let id = UUID()
    let name: String
    let email: String
}
*/

//struct Quest {
//    let id: UUID
//    let title: String
//    let description: String
//    let category: Category
//    var tasks: [Task]
//    var completedTasks: [UUID]
//    let coinReward: Int
//    let prize: Prize?
//}
//
//struct Task {
//    let id: UUID
//    let title: String
//    let description: String
//    let type: TaskType
//    let location: Location?
//    let coinReward: Int
//}
//
//enum TaskType {
//    case geofencedArea(Location)
//    case virtualEasterEgg
//    case inPersonEasterEgg(Location)
//    case brandPartnerQRCode(String)
//    case triviaQuestion(String, [String], Int)
//    case dailyDouble(String, [String], Int)
//    case clue(String)
//    case augmentedRealityExperience(String)
//}
//
//struct Category {
//    let name: String
//}
//
//struct Location {
//    let latitude: Double
//    let longitude: Double
//}
//
//struct Prize {
//    let id: UUID
//    let title: String
//    let description: String
//    let type: PrizeType
//    let coinCost: Int
//}
//
//enum PrizeType {
//    case physicalItem
//    case experience
//    case legendaryExperience
//}
//
//// User-generated content model
//struct UserGeneratedContent {
//    let id: Int
//    let images: [String]
//    let videos: [String]
//    let text: String
//    let testimonials: [String]
//}
//
//// Brand sponsor model
//struct BrandSponsor {
//    let id: Int
//    let name: String
//    let revenueModel: RevenueModel
//    let subscriptionFeatures: [String]
//}
//
//// Revenue model enumeration
//enum RevenueModel {
//    case freemium
//    case subscription
//}
//
//// Team model
//struct Team {
//    let id: Int
//    let name: String
//    let members: [User]
//    let coinPool: Coin
//}
//
//// User model
//struct User {
//    let id: Int
//    let name: String
//    let coins: [Coin]
//    let prizes: [Prize]
//    let ugc: UserGeneratedContent
//    let teams: [Team]
//}
//
//// Coin model
//struct Coin {
//    let id: Int
//    let amount: Int
//}
