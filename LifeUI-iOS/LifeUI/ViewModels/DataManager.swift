//
//  DataManager.swift
//  LifeUI
//
//  冬山生命禮儀公司資料管理器
//  負責應用程式資料的載入、管理和持久化
//

import Foundation
import Combine
import SwiftUI
import UserNotifications

// MARK: - 主要資料管理器
class DataManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published var services: [Service] = []
    @Published var servicePackages: [ServicePackage] = []
    @Published var contactInfo: ContactInfo = ContactInfo.default
    @Published var faqItems: [FAQItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Search and Filter
    @Published var searchText: String = ""
    @Published var selectedCategory: ServiceCategory = .all
    
    // MARK: - Form Management
    @Published var contactForm: ContactForm = ContactForm()
    @Published var isSubmittingForm: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        setupSubscribers()
        requestNotificationPermission()
    }
    
    // MARK: - Data Loading
    func loadData() {
        isLoading = true
        
        // 模擬載入資料
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.services = Service.sampleServices
            self.servicePackages = ServicePackage.samplePackages
            self.contactInfo = ContactInfo.default
            self.faqItems = FAQItem.sampleFAQs
            self.isLoading = false
        }
    }
    
    func refreshData() {
        loadData()
    }
    
    func refreshContactInfo() {
        // 重新載入聯絡資訊
        contactInfo = ContactInfo.default
    }
    
    // MARK: - Service Management
    func getPopularServices() -> [Service] {
        return services.filter { $0.isPopular }.prefix(3).map { $0 }
    }
    
    func getServicesByCategory(_ category: ServiceCategory) -> [Service] {
        if category == .all {
            return services
        }
        return services.filter { $0.category == category }
    }
    
    func getServicePackages() -> [ServicePackage] {
        return servicePackages.sorted { $0.isRecommended && !$1.isRecommended }
    }
    
    func searchServices(with query: String) -> [Service] {
        if query.isEmpty {
            return services
        }
        
        return services.filter { service in
            service.title.localizedCaseInsensitiveContains(query) ||
            service.subtitle.localizedCaseInsensitiveContains(query) ||
            service.description.localizedCaseInsensitiveContains(query) ||
            service.features.contains { $0.localizedCaseInsensitiveContains(query) }
        }
    }
    
    // MARK: - Form Management
    func submitContactForm() {
        guard contactForm.isValid else {
            errorMessage = "請填寫所有必要欄位"
            return
        }
        
        isSubmittingForm = true
        
        // 模擬表單提交
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isSubmittingForm = false
            self.resetContactForm()
            self.sendNotification(title: "表單已送出", body: "我們會盡快與您聯絡")
        }
    }
    
    func resetContactForm() {
        contactForm = ContactForm()
    }
    
    // MARK: - Notification Management
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = "冬山生命禮儀緊急通知"
        content.body = "24小時緊急專線：0935571189，我們隨時為您服務"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupSubscribers() {
        // 監聽搜尋文字變化
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.performSearch(with: searchText)
            }
            .store(in: &cancellables)
        
        // 監聽類別變化
        $selectedCategory
            .sink { [weak self] category in
                self?.filterServicesByCategory(category)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(with query: String) {
        // 實現搜尋邏輯
        if query.isEmpty {
            // 顯示所有服務
        } else {
            // 篩選搜尋結果
        }
    }
    
    private func filterServicesByCategory(_ category: ServiceCategory) {
        // 實現類別篩選邏輯
    }
    
    // MARK: - Data Persistence
    func saveDataToLocal() {
        // 實現本地資料儲存
        let encoder = JSONEncoder()
        
        do {
            let servicesData = try encoder.encode(services)
            UserDefaults.standard.set(servicesData, forKey: "SavedServices")
            
            let packagesData = try encoder.encode(servicePackages)
            UserDefaults.standard.set(packagesData, forKey: "SavedPackages")
            
            let contactData = try encoder.encode(contactInfo)
            UserDefaults.standard.set(contactData, forKey: "SavedContactInfo")
            
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func loadDataFromLocal() {
        let decoder = JSONDecoder()
        
        // 載入服務資料
        if let servicesData = UserDefaults.standard.data(forKey: "SavedServices") {
            do {
                services = try decoder.decode([Service].self, from: servicesData)
            } catch {
                print("Error loading services: \(error)")
            }
        }
        
        // 載入套餐資料
        if let packagesData = UserDefaults.standard.data(forKey: "SavedPackages") {
            do {
                servicePackages = try decoder.decode([ServicePackage].self, from: packagesData)
            } catch {
                print("Error loading packages: \(error)")
            }
        }
        
        // 載入聯絡資訊
        if let contactData = UserDefaults.standard.data(forKey: "SavedContactInfo") {
            do {
                contactInfo = try decoder.decode(ContactInfo.self, from: contactData)
            } catch {
                print("Error loading contact info: \(error)")
            }
        }
    }
    
    // MARK: - Analytics and Tracking
    func trackServiceView(_ service: Service) {
        // 實現服務瀏覽追蹤
        print("Service viewed: \(service.title)")
    }
    
    func trackFormSubmission(_ form: ContactForm) {
        // 實現表單提交追蹤
        print("Form submitted: \(form.subject.displayName)")
    }
    
    func trackEmergencyCall() {
        // 實現緊急通話追蹤
        print("Emergency call initiated")
    }
    
    // MARK: - Utility Methods
    func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TWD"
        formatter.currencySymbol = "NT$"
        return formatter.string(from: NSNumber(value: price)) ?? "NT$\(price)"
    }
    
    func isServiceAvailable(_ service: Service) -> Bool {
        // 實現服務可用性檢查
        return true
    }
    
    func getEstimatedPrice(for services: [Service]) -> Int {
        return services.compactMap { $0.price?.basePrice }.reduce(0, +)
    }
}

// MARK: - 錯誤類型
enum DataManagerError: Error, LocalizedError {
    case invalidForm
    case networkError
    case dataNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidForm:
            return "表單資料無效，請檢查必填欄位"
        case .networkError:
            return "網路連線發生問題，請稍後再試"
        case .dataNotFound:
            return "找不到相關資料"
        }
    }
}

// MARK: - 本地儲存管理器
class LocalStorageManager {
    static let shared = LocalStorageManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - 用戶偏好設定
    
    /// 儲存聯絡表單草稿
    func saveContactFormDraft(_ form: ContactForm) {
        if let data = try? JSONEncoder().encode(form) {
            userDefaults.set(data, forKey: "contactFormDraft")
        }
    }
    
    /// 載入聯絡表單草稿
    func loadContactFormDraft() -> ContactForm? {
        guard let data = userDefaults.data(forKey: "contactFormDraft"),
              let form = try? JSONDecoder().decode(ContactForm.self, from: data) else {
            return nil
        }
        return form
    }
    
    /// 清除聯絡表單草稿
    func clearContactFormDraft() {
        userDefaults.removeObject(forKey: "contactFormDraft")
    }
    
    /// 儲存最愛服務
    func saveFavoriteServices(_ serviceIds: [UUID]) {
        let ids = serviceIds.map { $0.uuidString }
        userDefaults.set(ids, forKey: "favoriteServices")
    }
    
    /// 載入最愛服務
    func loadFavoriteServices() -> [UUID] {
        guard let ids = userDefaults.array(forKey: "favoriteServices") as? [String] else {
            return []
        }
        return ids.compactMap { UUID(uuidString: $0) }
    }
    
    /// 新增最愛服務
    func addFavoriteService(_ serviceId: UUID) {
        var favorites = loadFavoriteServices()
        if !favorites.contains(serviceId) {
            favorites.append(serviceId)
            saveFavoriteServices(favorites)
        }
    }
    
    /// 移除最愛服務
    func removeFavoriteService(_ serviceId: UUID) {
        var favorites = loadFavoriteServices()
        favorites.removeAll { $0 == serviceId }
        saveFavoriteServices(favorites)
    }
    
    /// 檢查是否為最愛服務
    func isFavoriteService(_ serviceId: UUID) -> Bool {
        return loadFavoriteServices().contains(serviceId)
    }
}

// MARK: - 通知管理器
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    private init() {}
    
    /// 發送本地通知
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ 通知排程失敗: \(error.localizedDescription)")
            } else {
                print("✅ 通知已排程")
            }
        }
    }
    
    /// 發送緊急服務提醒
    func scheduleEmergencyReminder() {
        scheduleNotification(
            title: "冬山生命禮儀公司",
            body: "24小時緊急專線：0800-555-999，我們隨時為您服務",
            timeInterval: 60 // 1分鐘後提醒
        )
    }
} 