//
//  Service.swift
//  LifeUI
//
//  冬山生命禮儀公司服務項目資料模型
//  定義所有服務相關的資料結構
//

import Foundation
import SwiftUI

// MARK: - 服務類別枚舉
enum ServiceCategory: String, CaseIterable, Codable {
    case all = "all"                   // 全部服務
    case funeral = "funeral"           // 殯葬服務
    case ceremony = "ceremony"         // 告別式
    case cemetery = "cemetery"         // 墓園服務
    case memorial = "memorial"         // 紀念服務
    case support = "support"           // 支援服務
    
    var displayName: String {
        switch self {
        case .all: return "全部服務"
        case .funeral: return "殯葬服務"
        case .ceremony: return "告別式"
        case .cemetery: return "墓園服務"
        case .memorial: return "紀念服務"
        case .support: return "支援服務"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .funeral: return "heart.fill"
        case .ceremony: return "person.3.fill"
        case .cemetery: return "house.fill"
        case .memorial: return "star.fill"
        case .support: return "hands.sparkles.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return .textSecondary
        case .funeral: return .brandPrimary
        case .ceremony: return .brandSecondary
        case .cemetery: return .success
        case .memorial: return .info
        case .support: return .warning
        }
    }
}

// MARK: - 服務項目模型
struct Service: Identifiable, Codable, Hashable {
    var id: UUID
    let title: String
    let subtitle: String
    let description: String
    let features: [String]
    let price: ServicePrice?
    let icon: String
    let category: ServiceCategory
    let isPopular: Bool
    let estimatedDuration: String
    
    init(title: String, subtitle: String, description: String, features: [String], price: ServicePrice?, icon: String, category: ServiceCategory, isPopular: Bool, estimatedDuration: String) {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.features = features
        self.price = price
        self.icon = icon
        self.category = category
        self.isPopular = isPopular
        self.estimatedDuration = estimatedDuration
    }
}

// MARK: - 服務價格模型
struct ServicePrice: Codable, Hashable {
    let basePrice: Int
    let currency: String
    let priceRange: PriceRange?
    let isNegotiable: Bool
    let includedItems: [String]
    let additionalItems: [AdditionalItem]
    let note: String
    
    struct PriceRange: Codable, Hashable {
        let min: Int
        let max: Int
    }
    
    init(basePrice: Int, currency: String = "TWD", priceRange: ClosedRange<Int>? = nil, isNegotiable: Bool = true, includedItems: [String] = [], additionalItems: [AdditionalItem] = [], note: String = "") {
        self.basePrice = basePrice
        self.currency = currency
        self.priceRange = priceRange.map { PriceRange(min: $0.lowerBound, max: $0.upperBound) }
        self.isNegotiable = isNegotiable
        self.includedItems = includedItems
        self.additionalItems = additionalItems
        self.note = note
    }
    
    var formattedBasePrice: String {
        return "NT$\(basePrice.formatted())"
    }
    
    var formattedPriceRange: String {
        guard let range = priceRange else { return formattedBasePrice }
        return "NT$\(range.min.formatted()) - NT$\(range.max.formatted())"
    }
}

// MARK: - 附加項目模型
struct AdditionalItem: Identifiable, Codable, Hashable {
    var id: UUID
    let name: String
    let price: Int
    let description: String
    let isOptional: Bool
    
    init(name: String, price: Int, description: String, isOptional: Bool) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.description = description
        self.isOptional = isOptional
    }
    
    var formattedPrice: String {
        return "NT$\(price.formatted())"
    }
}

// MARK: - 服務套餐模型
struct ServicePackage: Identifiable, Codable, Hashable {
    var id: UUID
    let title: String
    let description: String
    let includedServices: [String]
    let totalPrice: Int
    let originalPrice: Int
    let isRecommended: Bool
    let validUntil: Date?
    
    init(title: String, description: String, includedServices: [String], totalPrice: Int, originalPrice: Int, isRecommended: Bool, validUntil: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.includedServices = includedServices
        self.totalPrice = totalPrice
        self.originalPrice = originalPrice
        self.isRecommended = isRecommended
        self.validUntil = validUntil
    }
    
    var formattedPrice: String {
        return "NT$\(totalPrice.formatted())"
    }
    
    var formattedOriginalPrice: String {
        return "NT$\(originalPrice.formatted())"
    }
    
    var savings: Int {
        return originalPrice - totalPrice
    }
    
    var formattedSavings: String {
        return "節省 NT$\(savings.formatted())"
    }
    
    var discountPercentage: Int {
        guard originalPrice > 0 else { return 0 }
        return Int((Double(savings) / Double(originalPrice)) * 100)
    }
}

// MARK: - 擴展：數字格式化
extension NumberFormatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TWD"
        formatter.currencySymbol = "NT$"
        return formatter
    }()
}

// MARK: - 預設服務資料
extension Service {
    static let sampleServices: [Service] = [
        Service(
            title: "殯葬一條龍服務",
            subtitle: "完整專業的殯葬規劃",
            description: "提供從往生者接體、防腐處理、告別式規劃到後續追思等完整服務，讓家屬在傷痛時刻能夠安心交託。",
            features: [
                "24小時接體服務",
                "專業防腐處理",
                "告別式場地規劃",
                "宗教儀式安排",
                "後續法事服務"
            ],
            price: ServicePrice(
                basePrice: 280000,
                priceRange: 180000...380000,
                includedItems: [
                    "接體服務",
                    "防腐處理",
                    "告別式場地",
                    "基本花籃佈置",
                    "宗教儀式"
                ],
                additionalItems: [
                    AdditionalItem(name: "高級花籃佈置", price: 15000, description: "進口鮮花精緻佈置", isOptional: true),
                    AdditionalItem(name: "專業攝影服務", price: 8000, description: "告別式全程攝影", isOptional: true)
                ],
                note: "價格依服務內容調整"
            ),
            icon: "heart.fill",
            category: .funeral,
            isPopular: true,
            estimatedDuration: "3-7天"
        ),
        
        Service(
            title: "告別式規劃",
            subtitle: "莊嚴溫馨的告別儀式",
            description: "專業規劃告別式流程，包含場地佈置、音響設備、宗教儀式等，讓親友能夠溫馨告別。",
            features: [
                "場地佈置設計",
                "音響燈光設備",
                "宗教儀式安排",
                "司儀主持服務",
                "追思影片製作"
            ],
            price: ServicePrice(
                basePrice: 80000,
                priceRange: 50000...150000,
                includedItems: [
                    "基本場地佈置",
                    "音響設備",
                    "司儀服務"
                ],
                additionalItems: [
                    AdditionalItem(name: "追思影片製作", price: 12000, description: "專業影片剪輯製作", isOptional: true),
                    AdditionalItem(name: "花籃佈置升級", price: 20000, description: "進口鮮花豪華佈置", isOptional: true)
                ]
            ),
            icon: "person.3.fill",
            category: .ceremony,
            isPopular: true,
            estimatedDuration: "1天"
        ),
        
        Service(
            title: "墓園納骨服務",
            subtitle: "安息之地的專業安排",
            description: "協助選擇合適的墓園或納骨塔位，處理相關手續，確保往生者能夠安息。",
            features: [
                "塔位選擇諮詢",
                "合約手續辦理",
                "入塔儀式安排",
                "後續維護服務",
                "家屬關懷服務"
            ],
            price: ServicePrice(
                basePrice: 150000,
                priceRange: 80000...300000,
                includedItems: [
                    "塔位使用權",
                    "基本入塔儀式",
                    "相關手續辦理"
                ],
                note: "價格依塔位等級而定"
            ),
            icon: "house.fill",
            category: .cemetery,
            isPopular: false,
            estimatedDuration: "1-2天"
        ),
        
        Service(
            title: "紀念追思服務",
            subtitle: "永續的愛與思念",
            description: "提供各種紀念追思服務，讓逝者的愛與精神得以延續，為家屬帶來慰藉。",
            features: [
                "追思會規劃",
                "紀念品製作",
                "影像紀錄服務",
                "線上追思平台",
                "週年追思安排"
            ],
            price: ServicePrice(
                basePrice: 25000,
                priceRange: 15000...50000,
                includedItems: [
                    "基本追思會規劃",
                    "紀念冊製作",
                    "線上追思頁面"
                ]
            ),
            icon: "star.fill",
            category: .memorial,
            isPopular: false,
            estimatedDuration: "彈性安排"
        ),
        
        Service(
            title: "家屬關懷支援",
            subtitle: "專業心理與生活支援",
            description: "在困難時刻提供專業的心理支援與生活協助，陪伴家屬度過哀傷期。",
            features: [
                "心理諮商服務",
                "法律諮詢協助",
                "保險理賠協助",
                "生活支援服務",
                "後續關懷追蹤"
            ],
            price: ServicePrice(
                basePrice: 5000,
                priceRange: 3000...10000,
                includedItems: [
                    "初次諮詢",
                    "基本協助服務"
                ],
                note: "部分服務免費提供"
            ),
            icon: "hands.sparkles.fill",
            category: .support,
            isPopular: true,
            estimatedDuration: "持續服務"
        )
    ]
}

// MARK: - 服務套餐預設資料
extension ServicePackage {
    static let samplePackages: [ServicePackage] = [
        ServicePackage(
            title: "基礎安心方案",
            description: "提供基本但完整的殯葬服務，經濟實惠且有品質保證",
            includedServices: [
                "基本告別式規劃",
                "接體防腐服務",
                "基本場地佈置",
                "宗教儀式安排"
            ],
            totalPrice: 150000,
            originalPrice: 180000,
            isRecommended: false
        ),
        
        ServicePackage(
            title: "標準溫馨方案",
            description: "最受歡迎的服務組合，平衡品質與價格的最佳選擇",
            includedServices: [
                "完整告別式規劃",
                "專業殯葬服務",
                "精美場地佈置",
                "追思影片製作",
                "家屬關懷服務"
            ],
            totalPrice: 250000,
            originalPrice: 320000,
            isRecommended: true
        ),
        
        ServicePackage(
            title: "豪華尊榮方案",
            description: "最高規格的服務品質，為重要人士提供尊榮告別",
            includedServices: [
                "頂級告別式規劃",
                "豪華殯葬服務",
                "進口花材佈置",
                "專業攝影錄影",
                "VIP專屬服務",
                "長期關懷服務"
            ],
            totalPrice: 380000,
            originalPrice: 480000,
            isRecommended: false
        )
    ]
} 