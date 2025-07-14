//
//  ServicesView.swift
//  LifeUI
//
//  冬山生命禮儀公司服務項目頁面
//  顯示所有服務類別和詳細資訊
//

import SwiftUI

struct ServicesView: View {
    
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedCategory: ServiceCategory = .all
    @State private var searchText = ""
    @State private var showingPackages = false
    
    var filteredServices: [Service] {
        var services = dataManager.services
        
        // 類別篩選
        if selectedCategory != .all {
            services = services.filter { $0.category == selectedCategory }
        }
        
        // 搜尋篩選
        if !searchText.isEmpty {
            services = services.filter { service in
                service.title.localizedCaseInsensitiveContains(searchText) ||
                service.subtitle.localizedCaseInsensitiveContains(searchText) ||
                service.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return services
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 頂部工具列
            headerSection
            
            // 主內容
            ScrollView {
                LazyVStack(spacing: 16) {
                    // 類別篩選
                    categoryFilterSection
                    
                    // 服務方案卡片
                    servicePackagesSection
                    
                    // 服務項目列表
                    serviceListSection
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .refreshable {
                dataManager.refreshData()
            }
        }
        .navigationTitle("服務項目")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "搜尋服務項目...")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingPackages.toggle() }) {
                    Image(systemName: showingPackages ? "list.bullet" : "square.grid.2x2")
                }
            }
        }
    }
    
    // MARK: - 頂部工具列
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("專業生命禮儀服務")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text("提供完整的一條龍服務，從諮詢規劃到儀式執行")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.backgroundSecondary)
    }
    
    // MARK: - 類別篩選
    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ServiceCategory.allCases, id: \.self) { category in
                    CategoryFilterChip(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - 服務方案卡片
    private var servicePackagesSection: some View {
        VStack(spacing: 16) {
            if showingPackages {
                Text("服務方案")
                    .font(.title1)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 12) {
                    ForEach(dataManager.getServicePackages(), id: \.id) { package in
                        ServicePackageCard(package: package)
                    }
                }
            }
        }
    }
    
    // MARK: - 服務項目列表
    private var serviceListSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text(showingPackages ? "個別服務項目" : "所有服務項目")
                    .font(.title1)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(filteredServices.count) 項服務")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            if filteredServices.isEmpty {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "未找到相關服務",
                    subtitle: "請嘗試調整搜尋條件或選擇其他類別"
                )
                .padding(.vertical, 40)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 12) {
                    ForEach(filteredServices, id: \.id) { service in
                        if #available(iOS 16.0, *) {
                            NavigationLink(value: service) {
                                ServiceListCard(service: service)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            NavigationLink(destination: ServiceDetailView(service: service)) {
                                ServiceListCard(service: service)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 子視圖組件

struct CategoryFilterChip: View {
    let category: ServiceCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.displayName)
                    .font(.labelSmall)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                isSelected ? Color.brandPrimary : Color.backgroundTertiary
            )
            .foregroundColor(
                isSelected ? Color.white : Color.textSecondary
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? Color.clear : Color.borderPrimary,
                        lineWidth: 1
                    )
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct ServicePackageCard: View {
    let package: ServicePackage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 標題和標籤
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(package.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    if package.isRecommended {
                        Text("推薦方案")
                            .font(.captionSmall)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.warning)
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(package.formattedPrice)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.brandPrimary)
                    
                    Text("起")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            // 描述
            Text(package.description)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .lineLimit(2)
            
            // 包含項目
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(package.includedServices.prefix(3)), id: \.self) { service in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.success)
                        
                        Text(service)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                    }
                }
                
                if package.includedServices.count > 3 {
                    Text("還有 \(package.includedServices.count - 3) 個項目...")
                        .font(.captionSmall)
                        .foregroundColor(.textTertiary)
                        .padding(.leading, 20)
                }
            }
            
            // 立即諮詢按鈕
            Button(action: {}) {
                HStack {
                    Image(systemName: "phone.fill")
                    Text("立即諮詢")
                }
                .font(.buttonSecondary)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.brandPrimary)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            package.isRecommended 
                ? Color.brandSecondary.opacity(0.05)
                : Color.backgroundPrimary
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    package.isRecommended 
                        ? Color.brandSecondary.opacity(0.3)
                        : Color.borderPrimary,
                    lineWidth: package.isRecommended ? 2 : 1
                )
        )
        .shadow(color: .cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct ServiceListCard: View {
    let service: Service
    
    var body: some View {
        HStack(spacing: 16) {
            // 服務圖標
            Image(systemName: service.icon)
                .font(.title)
                .foregroundColor(service.category.color)
                .frame(width: 60, height: 60)
                .background(service.category.color.opacity(0.1))
                .cornerRadius(30)
            
            // 服務資訊
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(service.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    if service.isPopular {
                        Text("熱門")
                            .font(.captionSmall)
                            .fontWeight(.semibold)
                            .foregroundColor(.warning)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.warning.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                
                Text(service.subtitle)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
                
                HStack {
                    if let price = service.price {
                        Text(price.formattedPriceRange)
                            .font(.number)
                            .foregroundColor(.brandPrimary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding()
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.textTertiary)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.textSecondary)
            
            Text(subtitle)
                .font(.bodySmall)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - 服務詳情頁面
struct ServiceDetailView: View {
    let service: Service
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // 頂部返回按鈕區域
            HStack {
                Button(action: {
                    if #available(iOS 15.0, *) {
                        dismiss()
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                        Text("返回")
                            .font(.system(size: 17, weight: .medium))
                    }
                    .foregroundColor(.brandPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.brandPrimary.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Spacer()
                
                Text(service.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                Spacer()
                
                // 占位空间，保持标题居中
                Color.clear
                    .frame(width: 80, height: 44)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .background(Color.backgroundPrimary)
            
            // 主要內容
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 服務標題區域
                    serviceHeaderSection
                    
                    // 服務描述
                    serviceDescriptionSection
                    
                    // 服務特色
                    serviceFeaturesSection
                    
                    // 價格資訊
                    if let price = service.price {
                        servicePricingSection(price)
                    }
                    
                    // 諮詢按鈕
                    consultationButtonSection
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
    
    private var serviceHeaderSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: service.icon)
                    .font(.system(size: 40))
                    .foregroundColor(service.category.color)
                    .frame(width: 80, height: 80)
                    .background(service.category.color.opacity(0.1))
                    .cornerRadius(40)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(service.category.displayName)
                        .font(.captionSmall)
                        .foregroundColor(.textTertiary)
                    
                    Text(service.title)
                        .font(.title1)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text(service.subtitle)
                        .font(.bodyLarge)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
        }
    }
    
    private var serviceDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("服務說明")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(service.description)
                .font(.bodyLarge)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
    }
    
    private var serviceFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("服務特色")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 12) {
                ForEach(service.features, id: \.self) { feature in
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.success)
                        
                        Text(feature)
                            .font(.bodyLarge)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.backgroundSecondary)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private func servicePricingSection(_ price: ServicePrice) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("價格資訊")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                HStack {
                    Text("價格範圍")
                        .font(.bodyLarge)
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text(price.formattedPriceRange)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.brandPrimary)
                }
                
                if !price.note.isEmpty {
                    HStack {
                        Image(systemName: "info.circle")
                            .font(.caption)
                            .foregroundColor(.info)
                        
                        Text(price.note)
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color.backgroundSecondary)
            .cornerRadius(12)
        }
    }
    
    private var consultationButtonSection: some View {
        VStack(spacing: 12) {
            Button(action: {}) {
                HStack {
                    Image(systemName: "phone.fill")
                    Text("立即電話諮詢")
                }
                .font(.buttonPrimary)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.brandPrimary)
                .cornerRadius(12)
            }
            
            Button(action: {}) {
                HStack {
                    Image(systemName: "message.fill")
                    Text("LINE 線上諮詢")
                }
                .font(.buttonSecondary)
                .foregroundColor(.brandPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.backgroundSecondary)
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - 預覽
struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesView()
            .environmentObject(DataManager())
    }
} 