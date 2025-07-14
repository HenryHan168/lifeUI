//
//  ContentView.swift
//  LifeUI
//
//  冬山生命禮儀公司主要內容視圖
//  包含Tab導航和主要功能頁面
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var dataManager = DataManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // 首頁
            Group {
                if #available(iOS 16.0, *) {
                    NavigationStack {
                        HomeView()
                    }
                } else {
                    NavigationView {
                        HomeView()
                    }
                }
            }
            .tabItem {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                Text("首頁")
            }
            .tag(0)
            
            // 服務項目
            Group {
                if #available(iOS 16.0, *) {
                    NavigationStack {
                        ServicesView()
                            .navigationDestination(for: Service.self) { service in
                                ServiceDetailView(service: service)
                            }
                    }
                } else {
                    NavigationView {
                        ServicesView()
                    }
                }
            }
            .tabItem {
                Image(systemName: selectedTab == 1 ? "list.bullet.clipboard.fill" : "list.bullet.clipboard")
                Text("服務項目")
            }
            .tag(1)
            
            // 服務流程
            Group {
                if #available(iOS 16.0, *) {
                    NavigationStack {
                        ProcessView()
                    }
                } else {
                    NavigationView {
                        ProcessView()
                    }
                }
            }
            .tabItem {
                Image(systemName: selectedTab == 2 ? "arrow.triangle.2.circlepath" : "arrow.triangle.2.circlepath")
                Text("服務流程")
            }
            .tag(2)
            
            // 關於我們
            Group {
                if #available(iOS 16.0, *) {
                    NavigationStack {
                        AboutView()
                    }
                } else {
                    NavigationView {
                        AboutView()
                    }
                }
            }
            .tabItem {
                Image(systemName: selectedTab == 3 ? "info.circle.fill" : "info.circle")
                Text("關於我們")
            }
            .tag(3)
            
            // 聯絡我們
            Group {
                if #available(iOS 16.0, *) {
                    NavigationStack {
                        ContactView()
                    }
                } else {
                    NavigationView {
                        ContactView()
                    }
                }
            }
            .tabItem {
                Image(systemName: selectedTab == 4 ? "phone.fill" : "phone")
                Text("聯絡我們")
            }
            .tag(4)
        }
        .environmentObject(dataManager)
        .tint(.brandPrimary)
        .onAppear {
            // 配置 TabBar 外觀
            configureTabBarAppearance()
            
            // 載入資料
            dataManager.loadData()
        }
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        // 未選中項目的顏色
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray
        ]
        
        // 選中項目的顏色
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.brandPrimary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.brandPrimary)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

// MARK: - 臨時佔位視圖 (等待實際實現)

struct ProcessView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // 頁面標題
                VStack(spacing: 12) {
                    Text("服務流程說明")
                        .font(.title1)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text("清楚透明的服務流程，讓您了解每個階段的安排與準備")
                        .font(.bodyLarge)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.backgroundSecondary)
                
                // 流程步驟
                VStack(spacing: 16) {
                    ProcessStepCard(
                        stepNumber: 1,
                        title: "緊急聯絡與諮詢",
                        description: "24小時服務專線，第一時間提供協助",
                        icon: "phone.fill",
                        color: .error
                    )
                    
                    ProcessStepCard(
                        stepNumber: 2,
                        title: "專業接體服務",
                        description: "專業團隊30分鐘內到達現場",
                        icon: "car.fill",
                        color: .info
                    )
                    
                    ProcessStepCard(
                        stepNumber: 3,
                        title: "服務合約與規劃",
                        description: "詳細說明服務內容，簽署正式合約",
                        icon: "doc.text.fill",
                        color: .brandPrimary
                    )
                    
                    ProcessStepCard(
                        stepNumber: 4,
                        title: "遺體處理與美容",
                        description: "專業防腐處理及美容服務",
                        icon: "sparkles",
                        color: .success
                    )
                    
                    ProcessStepCard(
                        stepNumber: 5,
                        title: "告別式會場佈置",
                        description: "精美花藝布置，營造莊嚴氛圍",
                        icon: "leaf.fill",
                        color: .warning
                    )
                    
                    ProcessStepCard(
                        stepNumber: 6,
                        title: "告別式儀式進行",
                        description: "莊嚴隆重的告別儀式",
                        icon: "heart.fill",
                        color: .brandSecondary
                    )
                    
                    ProcessStepCard(
                        stepNumber: 7,
                        title: "火化與後續安排",
                        description: "協助火化程序及安置安排",
                        icon: "mountain.2.fill",
                        color: .textSecondary
                    )
                    
                    ProcessStepCard(
                        stepNumber: 8,
                        title: "後續關懷服務",
                        description: "持續關懷，提供後續協助",
                        icon: "hands.sparkles.fill",
                        color: .brandPrimary
                    )
                }
                .padding(.horizontal)
                
                // 必要文件
                VStack(spacing: 16) {
                    Text("必要文件準備")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: 12) {
                        DocumentCard(
                            title: "逝者相關文件",
                            items: ["身分證正本", "戶口名簿", "健保卡", "印章"]
                        )
                        
                        DocumentCard(
                            title: "家屬相關文件",
                            items: ["申請人身分證", "親屬關係證明", "醫院診斷證明", "其他相關文件"]
                        )
                    }
                }
                .padding()
                .background(Color.backgroundPrimary)
            }
        }
        .navigationTitle("服務流程")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // 公司簡介
                VStack(spacing: 16) {
                    Text("關於冬山生命禮儀")
                        .font(.title1)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text("專業、溫暖、貼心的生命禮儀服務機構，用愛與專業陪伴每個家庭走過人生重要時刻")
                        .font(.bodyLarge)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    // 統計數據
                    HStack(spacing: 20) {
                        StatCard(number: "14+", label: "年服務經驗")
                        StatCard(number: "3000+", label: "服務家庭")
                        StatCard(number: "24", label: "小時服務")
                    }
                }
                .padding()
                .background(Color.brandPrimary.opacity(0.05))
                
                // 經營理念
                VStack(spacing: 16) {
                    Text("經營理念與核心價值")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 16) {
                        ValueCard(
                            icon: "heart.fill",
                            title: "以心服務",
                            description: "用真誠的心對待每一位客戶，設身處地為家屬著想，提供最貼心的服務與陪伴。",
                            color: .error
                        )
                        
                        ValueCard(
                            icon: "star.fill",
                            title: "專業品質",
                            description: "持續提升專業技能，引進先進設備，堅持高品質的服務標準。",
                            color: .warning
                        )
                        
                        ValueCard(
                            icon: "hands.sparkles.fill",
                            title: "以愛相伴",
                            description: "在最困難的時刻給予家屬最大的支持，用愛心與耐心陪伴每個家庭。",
                            color: .success
                        )
                    }
                }
                .padding()
                .background(Color.backgroundPrimary)
                
                // 認證與資質
                VStack(spacing: 16) {
                    Text("認證與資質")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        CertificationCard(icon: "doc.text.fill", title: "營業執照", subtitle: "政府核准立案")
                        CertificationCard(icon: "shield.fill", title: "品質認證", subtitle: "ISO 9001認證")
                        CertificationCard(icon: "graduationcap.fill", title: "專業證照", subtitle: "禮儀師證照")
                        CertificationCard(icon: "checkmark.seal.fill", title: "保險保障", subtitle: "責任保險")
                    }
                }
                .padding()
                .background(Color.backgroundSecondary)
                
                // 服務區域
                VStack(spacing: 16) {
                    Text("服務區域")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text("為宜蘭地區提供全方位的生命禮儀服務")
                        .font(.bodyLarge)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ServiceAreaCard(area: "宜蘭市", description: "主要服務區域")
                        ServiceAreaCard(area: "羅東鎮", description: "主要服務區域")
                        ServiceAreaCard(area: "冬山鄉", description: "總部所在地")
                        ServiceAreaCard(area: "其他鄉鎮", description: "服務範圍涵蓋")
                    }
                }
                .padding()
                .background(Color.brandPrimary)
                .foregroundColor(.white)
            }
        }
        .navigationTitle("關於我們")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - 子視圖組件

struct ProcessStepCard: View {
    let stepNumber: Int
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // 步驟編號
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 40, height: 40)
                
                Text("\(stepNumber)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // 內容
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                    
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                }
                
                Text(description)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .lineLimit(3)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct DocumentCard: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(spacing: 8) {
                        Image(systemName: "doc.fill")
                            .font(.caption)
                            .foregroundColor(.brandPrimary)
                        
                        Text(item)
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
    }
}

struct StatCard: View {
    let number: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(number)
                .font(.title1)
                .fontWeight(.bold)
                .foregroundColor(.brandPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct ValueCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.1))
                .cornerRadius(25)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .lineLimit(4)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
        .shadow(color: .cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct CertificationCard: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.brandPrimary)
            
            Text(title)
                .font(.label)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(subtitle)
                .font(.captionSmall)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding()
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct ServiceAreaCard: View {
    let area: String
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(area)
                .font(.label)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text(description)
                .font(.captionSmall)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(8)
    }
}

// MARK: - 預覽
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 