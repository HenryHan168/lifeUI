//
//  LifeUIApp.swift
//  LifeUI
//
//  冬山生命禮儀公司 iOS應用程式
//  Created on 2024
//
//  專業的生命禮儀服務應用程式
//  提供24小時服務、線上諮詢、服務預約等功能
//

import SwiftUI
import UserNotifications

@main
struct LifeUIApp: App {
    
    @StateObject private var dataManager = DataManager()
    
    init() {
        // 配置應用程式外觀
        configureAppearance()
        
        // 請求通知權限
        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .preferredColorScheme(.light) // 固定使用光色主題，符合品牌形象
        }
    }
    
    // MARK: - Private Methods
    
    /// 配置應用程式外觀
    private func configureAppearance() {
        // 設定導航欄樣式
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.12, green: 0.23, blue: 0.54, alpha: 1.0) // 深藍色
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // 設定Tab Bar樣式
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white
        tabBarAppearance.selectionIndicatorTintColor = UIColor(red: 0.12, green: 0.23, blue: 0.54, alpha: 1.0)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    /// 請求推播通知權限
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("✅ 通知權限已授予")
            } else if let error = error {
                print("❌ 通知權限請求失敗: \(error.localizedDescription)")
            }
        }
    }
} 