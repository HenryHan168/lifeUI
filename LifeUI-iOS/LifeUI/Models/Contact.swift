//
//  Contact.swift
//  LifeUI
//
//  冬山生命禮儀公司聯絡資訊模型
//  定義聯絡方式和表單相關的資料結構
//

import Foundation
import MapKit

// MARK: - 聯絡資訊模型
struct ContactInfo: Codable {
    let phone: String
    let emergencyPhone: String
    let lineId: String
    let email: String
    let address: String
    let website: String
    let businessHours: BusinessHours
    let location: LocationCoordinate
    let transportationInfo: [String]
    
    struct BusinessHours: Codable {
        let office: String
        let weekend: String
        let holiday: String
        let emergency: String
    }
    
    struct LocationCoordinate: Codable {
        let latitude: Double
        let longitude: Double
        
        var clLocationCoordinate2D: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    static let `default` = ContactInfo(
        phone: "0935571189",
        emergencyPhone: "0935571189",
        lineId: "@dongshan-life",
        email: "service@dongshan-life.com.tw",
        address: "宜蘭縣冬山鄉冬山路160號",
        website: "https://dongshan-life.com.tw",
        businessHours: BusinessHours(
            office: "週一至週日 08:00-18:00",
            weekend: "週六日 09:00-17:00",
            holiday: "國定假日 10:00-16:00",
            emergency: "24小時全年無休"
        ),
        location: LocationCoordinate(
            latitude: 24.6394,
            longitude: 121.7900
        ),
        transportationInfo: [
            "國道5號冬山交流道下，約5分鐘車程",
            "台鐵冬山站步行約10分鐘",
            "免費停車場提供便民服務",
            "無障礙設施完善"
        ]
    )
}

// MARK: - 聯絡項目類型
enum ContactItemType: String, CaseIterable, Codable {
    case phone = "phone"
    case emergency = "emergency"
    case line = "line"
    case email = "email"
    case address = "address"
    case website = "website"
    
    var displayName: String {
        switch self {
        case .phone: return "服務專線"
        case .emergency: return "24小時緊急專線"
        case .line: return "LINE官方帳號"
        case .email: return "電子信箱"
        case .address: return "公司地址"
        case .website: return "官方網站"
        }
    }
    
    var systemIcon: String {
        switch self {
        case .phone: return "phone.fill"
        case .emergency: return "phone.badge.plus"
        case .line: return "message.fill"
        case .email: return "envelope.fill"
        case .address: return "location.fill"
        case .website: return "globe"
        }
    }
    
    var isActionable: Bool {
        switch self {
        case .phone, .emergency, .line, .email: return true
        case .address, .website: return false
        }
    }
}

// MARK: - 聯絡表單模型
struct ContactForm: Codable {
    var name: String
    var phone: String
    var email: String
    var subject: ContactSubject
    var message: String
    var isUrgent: Bool
    var preferredContactTime: PreferredTime
    var agreedToTerms: Bool
    
    init() {
        self.name = ""
        self.phone = ""
        self.email = ""
        self.subject = .general
        self.message = ""
        self.isUrgent = false
        self.preferredContactTime = .anytime
        self.agreedToTerms = false
    }
    
    enum ContactSubject: String, CaseIterable, Codable {
        case general = "general"
        case inquiry = "inquiry"
        case emergency = "emergency"
        case appointment = "appointment"
        case complaint = "complaint"
        case suggestion = "suggestion"
        
        var displayName: String {
            switch self {
            case .general: return "一般諮詢"
            case .inquiry: return "服務詢問"
            case .emergency: return "緊急需求"
            case .appointment: return "預約服務"
            case .complaint: return "客訴反映"
            case .suggestion: return "建議回饋"
            }
        }
        
        var icon: String {
            switch self {
            case .general: return "questionmark.circle"
            case .inquiry: return "info.circle"
            case .emergency: return "exclamationmark.triangle"
            case .appointment: return "calendar"
            case .complaint: return "hand.raised"
            case .suggestion: return "lightbulb"
            }
        }
    }
    
    enum PreferredTime: String, CaseIterable, Codable {
        case morning = "morning"
        case afternoon = "afternoon"
        case evening = "evening"
        case anytime = "anytime"
        
        var displayName: String {
            switch self {
            case .morning: return "上午 (9:00-12:00)"
            case .afternoon: return "下午 (13:00-17:00)"
            case .evening: return "晚上 (18:00-21:00)"
            case .anytime: return "任何時間"
            }
        }
    }
    
    var isValid: Bool {
        return !name.isEmpty && 
               !phone.isEmpty && 
               !message.isEmpty && 
               agreedToTerms &&
               isValidPhone(phone)
    }
    
    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^09[0-9]{8}$|^0[2-8][0-9]{7,8}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }
}

// MARK: - 公司據點模型
struct CompanyLocation: Identifiable, Codable {
    var id: UUID
    let name: String
    let address: String
    let coordinate: LocationCoordinate
    let description: String
    let businessHours: [BusinessHour]
    let services: [String]
    let isPrimary: Bool
    
    init(name: String, address: String, coordinate: LocationCoordinate, description: String, businessHours: [BusinessHour], services: [String], isPrimary: Bool) {
        self.id = UUID()
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.description = description
        self.businessHours = businessHours
        self.services = services
        self.isPrimary = isPrimary
    }
    
    struct LocationCoordinate: Codable {
        let latitude: Double
        let longitude: Double
        
        var clLocationCoordinate2D: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    struct BusinessHour: Codable {
        let day: DayOfWeek
        let openTime: String
        let closeTime: String
        let isOpen: Bool
        
        enum DayOfWeek: String, CaseIterable, Codable {
            case monday = "monday"
            case tuesday = "tuesday"
            case wednesday = "wednesday"
            case thursday = "thursday"
            case friday = "friday"
            case saturday = "saturday"
            case sunday = "sunday"
            
            var displayName: String {
                switch self {
                case .monday: return "週一"
                case .tuesday: return "週二"
                case .wednesday: return "週三"
                case .thursday: return "週四"
                case .friday: return "週五"
                case .saturday: return "週六"
                case .sunday: return "週日"
                }
            }
        }
        
        var formattedHours: String {
            if !isOpen {
                return "休息"
            }
            return "\(openTime) - \(closeTime)"
        }
    }
}

// MARK: - FAQ項目模型
struct FAQItem: Identifiable, Codable {
    var id: UUID
    let question: String
    let answer: String
    let category: FAQCategory
    let priority: Int
    
    init(question: String, answer: String, category: FAQCategory, priority: Int = 0) {
        self.id = UUID()
        self.question = question
        self.answer = answer
        self.category = category
        self.priority = priority
    }
    
    enum FAQCategory: String, CaseIterable, Codable {
        case general = "general"
        case service = "service"
        case pricing = "pricing"
        case process = "process"
        case emergency = "emergency"
        
        var displayName: String {
            switch self {
            case .general: return "一般問題"
            case .service: return "服務相關"
            case .pricing: return "價格資訊"
            case .process: return "流程說明"
            case .emergency: return "緊急狀況"
            }
        }
    }
}

// MARK: - 預設資料
extension ContactInfo {
    func refreshContactInfo() {
        // 這裡可以實現從伺服器更新聯絡資訊的邏輯
        // 目前返回預設資料
    }
}

extension FAQItem {
    static let sampleFAQs: [FAQItem] = [
        FAQItem(
            question: "服務範圍涵蓋哪些地區？",
            answer: "我們主要服務宜蘭縣全境，包括宜蘭市、羅東鎮、冬山鄉等各鄉鎮市。對於鄰近縣市的緊急需求，我們也會視情況提供協助。",
            category: .general,
            priority: 1
        ),
        FAQItem(
            question: "緊急情況下多久可以到達？",
            answer: "我們承諾在接到緊急通知後30分鐘內趕達現場（宜蘭縣內）。我們的專業團隊24小時待命，隨時為您提供即時協助。",
            category: .emergency,
            priority: 2
        ),
        FAQItem(
            question: "是否提供免費諮詢服務？",
            answer: "是的，我們提供完全免費的諮詢服務。您可以透過電話、LINE、現場參觀等方式，我們的專業團隊會詳細為您說明服務內容與流程。",
            category: .service,
            priority: 3
        ),
        FAQItem(
            question: "如何預約參觀設施？",
            answer: "您可以透過電話或線上表單預約參觀時間。建議您事先預約，我們會安排專人為您導覽介紹，讓您更了解我們的服務環境。",
            category: .process,
            priority: 4
        ),
        FAQItem(
            question: "服務價格如何計算？",
            answer: "我們的服務價格依據服務內容、規模和個人需求而定。基礎方案從NT$150,000起，標準方案NT$250,000起，豪華方案NT$380,000起。詳細報價會根據您的具體需求提供。",
            category: .pricing,
            priority: 5
        )
    ]
} 