//
//  HomeView.swift
//  LifeUI
//
//  冬山生命禮儀公司首頁視圖
//  展示公司品牌、主要服務和緊急聯絡方式
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var dataManager: DataManager
    @State private var showingEmergencyAlert = false
    @State private var showingContactForm = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // 主視覺區域
                heroSection
                
                // 緊急服務區域
                emergencySection
                
                // 服務承諾
                serviceCommitmentSection
                
                // 主要服務項目
                mainServicesSection
                
                // 客戶見證
                testimonialsSection
                
                // 聯絡資訊
                contactInfoSection
            }
        }
        .navigationTitle("冬山生命禮儀")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            dataManager.refreshData()
        }
        .sheet(isPresented: $showingContactForm) {
            ContactFormSheet()
        }
    }
    
    // MARK: - 主視覺區域
    private var heroSection: some View {
        ZStack {
            // 背景漸層
            Color.primaryGradient
                .frame(height: 300)
            
            VStack(spacing: 20) {
                // 品牌標識
                Image(systemName: "heart.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                
                Text("用心陪伴，溫暖送別")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("以心服務，以愛相伴\n為每個家庭提供最專業溫暖的告別儀式服務")
                    .font(.bodyLarge)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                HStack(spacing: 15) {
                    Button(action: { showingEmergencyAlert = true }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("緊急專線")
                        }
                        .font(.buttonPrimary)
                        .foregroundColor(.brandPrimary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(25)
                    }
                    
                    Button(action: { showingContactForm = true }) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("預約諮詢")
                        }
                        .font(.buttonSecondary)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(25)
                    }
                }
            }
            .padding()
        }
        .alert("緊急聯絡", isPresented: $showingEmergencyAlert) {
            Button("撥打 0935571189") {
                if let url = URL(string: "tel://0935571189") {
                    UIApplication.shared.open(url)
                }
            }
            Button("取消", role: .cancel) {}
        } message: {
            Text("24小時緊急服務專線，我們隨時為您服務")
        }
    }
    
    // MARK: - 緊急服務區域
    private var emergencySection: some View {
        VStack(spacing: 15) {
            Text("24小時緊急服務")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.error)
            
            HStack(spacing: 20) {
                EmergencyContactCard(
                    icon: "phone.badge.plus",
                    title: "緊急專線",
                    number: "0935571189",
                    description: "全年無休"
                )
                
                EmergencyContactCard(
                    icon: "message.fill",
                    title: "LINE客服",
                    number: "@dongshan-life",
                    description: "即時回應"
                )
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
    }
    
    // MARK: - 服務承諾
    private var serviceCommitmentSection: some View {
        VStack(spacing: 20) {
            Text("我們的服務承諾")
                .font(.title1)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("專業、溫暖、貼心，陪伴您走過人生重要時刻")
                .font(.bodyLarge)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                ServiceCommitmentCard(
                    icon: "clock.fill",
                    title: "24小時服務",
                    description: "全年無休，隨時協助",
                    color: .info
                )
                
                ServiceCommitmentCard(
                    icon: "heart.fill",
                    title: "貼心關懷",
                    description: "深度理解需求",
                    color: .warning
                )
                
                ServiceCommitmentCard(
                    icon: "star.fill",
                    title: "專業認證",
                    description: "政府核准立案",
                    color: .success
                )
            }
        }
        .padding()
        .background(Color.backgroundPrimary)
    }
    
    // MARK: - 主要服務項目
    private var mainServicesSection: some View {
        VStack(spacing: 20) {
            Text("主要服務項目")
                .font(.title1)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("完善的一條龍服務，讓您安心託付")
                .font(.bodyLarge)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 15) {
                ForEach(dataManager.getPopularServices(), id: \.id) { service in
                    ServiceCard(service: service)
                }
            }
            
            if dataManager.services.isEmpty && !dataManager.isLoading {
                Text("暫無服務資料")
                    .foregroundColor(.textTertiary)
                    .padding()
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
    }
    
    // MARK: - 客戶見證
    private var testimonialsSection: some View {
        VStack(spacing: 20) {
            Text("客戶見證")
                .font(.title1)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("真摯的服務，獲得家屬的信任與感謝")
                .font(.bodyLarge)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    TestimonialCard(
                        name: "林先生",
                        location: "宜蘭縣民",
                        testimonial: "在最困難的時刻，冬山生命禮儀的團隊給了我們最大的支持與協助。他們的專業與溫暖讓我們能夠安心地為父親舉辦一場莊嚴的告別式。",
                        rating: 5
                    )
                    
                    TestimonialCard(
                        name: "陳太太",
                        location: "羅東鎮民",
                        testimonial: "從開始諮詢到儀式結束，每個環節都處理得非常細緻。工作人員的耐心解說讓我們了解每個流程，真的很感謝他們的用心服務。",
                        rating: 5
                    )
                    
                    TestimonialCard(
                        name: "王先生",
                        location: "冬山鄉民",
                        testimonial: "選擇冬山生命禮儀是正確的決定。專業的服務團隊，透明的收費標準，讓我們在悲傷時刻也能感受到溫暖與支持。",
                        rating: 5
                    )
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical)
        .background(Color.backgroundPrimary)
    }
    
    // MARK: - 聯絡資訊
    private var contactInfoSection: some View {
        VStack(spacing: 20) {
            Text("聯絡我們")
                .font(.title1)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            VStack(spacing: 15) {
                ContactInfoRow(
                    icon: "phone.fill",
                    title: "服務專線",
                    value: "0935571189",
                    description: "週一至週日 08:00-22:00"
                )
                
                ContactInfoRow(
                    icon: "location.fill",
                    title: "服務地址",
                    value: "宜蘭縣冬山鄉冬山路160號",
                    description: "營業時間：週一至週日 08:00-18:00"
                )
                
                ContactInfoRow(
                    icon: "envelope.fill",
                    title: "電子信箱",
                    value: "service@dongshan-life.com.tw",
                    description: "一般諮詢與建議"
                )
            }
        }
        .padding()
        .background(Color.brandPrimary)
    }
}

// MARK: - 子視圖組件

struct EmergencyContactCard: View {
    let icon: String
    let title: String
    let number: String
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.error)
            
            Text(title)
                .font(.labelSmall)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(number)
                .font(.buttonPrimary)
                .fontWeight(.bold)
                .foregroundColor(.brandPrimary)
            
            Text(description)
                .font(.captionSmall)
                .foregroundColor(.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct ServiceCommitmentCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Text(title)
                .font(.labelSmall)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.captionSmall)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct ServiceCard: View {
    let service: Service
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: service.icon)
                .font(.title)
                .foregroundColor(service.category.color)
                .frame(width: 50, height: 50)
                .background(service.category.color.opacity(0.1))
                .cornerRadius(25)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(service.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text(service.subtitle)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                
                if let price = service.price {
                    Text(price.formattedPriceRange)
                        .font(.number)
                        .foregroundColor(.brandPrimary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .padding()
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct TestimonialCard: View {
    let name: String
    let location: String
    let testimonial: String
    let rating: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title)
                    .foregroundColor(.brandSecondary)
                
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.label)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    Text(location)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
            
            Text(testimonial)
                .font(.bodySmall)
                .foregroundColor(.textPrimary)
                .lineLimit(4)
            
            HStack {
                ForEach(0..<rating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.brandSecondary)
                }
                Spacer()
            }
        }
        .padding()
        .frame(width: 280)
        .background(Color.backgroundTertiary)
        .cornerRadius(12)
        .shadow(color: .cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct ContactInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.labelSmall)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(value)
                    .font(.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
    }
}

// MARK: - 預覽
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(DataManager())
    }
} 