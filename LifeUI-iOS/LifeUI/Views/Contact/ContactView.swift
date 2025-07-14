//
//  ContactView.swift
//  LifeUI
//
//  冬山生命禮儀公司聯絡我們頁面
//  包含聯絡資訊、地圖、表單和緊急聯絡功能
//

import SwiftUI
import MapKit

struct ContactView: View {
    
    @EnvironmentObject var dataManager: DataManager
    @State private var showingEmergencyDialog = false
    @State private var showingContactForm = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.6394, longitude: 121.7900),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 緊急聯絡區域
                emergencyContactSection
                
                // 聯絡方式卡片
                contactMethodsSection
                
                // 地圖和地址
                locationSection
                
                // 營業時間
                businessHoursSection
                
                // 聯絡表單
                contactFormSection
                
                // 常見問題
                faqSection
            }
        }
        .navigationTitle("聯絡我們")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            dataManager.refreshContactInfo()
        }
    }
    
    // MARK: - 緊急聯絡區域
    private var emergencyContactSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title2)
                    .foregroundColor(.error)
                
                Text("24小時緊急服務")
                    .font(.title1)
                    .fontWeight(.bold)
                    .foregroundColor(.error)
            }
            
            Text("遇到緊急狀況請立即撥打專線")
                .font(.bodyLarge)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                EmergencyCallButton(
                    icon: "phone.fill",
                    title: "緊急專線",
                    number: dataManager.contactInfo.emergencyPhone,
                    subtitle: "24小時服務"
                ) {
                    makePhoneCall(dataManager.contactInfo.emergencyPhone)
                }
                
                EmergencyCallButton(
                    icon: "message.fill",
                    title: "LINE客服",
                    number: dataManager.contactInfo.lineId,
                    subtitle: "即時回應"
                ) {
                    openLineChat()
                }
            }
        }
        .padding()
        .background(Color.error.opacity(0.05))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.error.opacity(0.2)),
            alignment: .bottom
        )
    }
    
    // MARK: - 聯絡方式卡片
    private var contactMethodsSection: some View {
        VStack(spacing: 20) {
            Text("多元聯絡方式")
                .font(.title1)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ContactMethodCard(
                    icon: "phone.fill",
                    title: "電話聯絡",
                    value: dataManager.contactInfo.phone,
                    description: "直接撥打專線",
                    color: .info
                ) {
                    makePhoneCall(dataManager.contactInfo.phone)
                }
                
                ContactMethodCard(
                    icon: "envelope.fill",
                    title: "電子郵件",
                    value: dataManager.contactInfo.email,
                    description: "發送郵件給我們",
                    color: .success
                ) {
                    sendEmail()
                }
                
                ContactMethodCard(
                    icon: "location.fill",
                    title: "現場諮詢",
                    value: dataManager.contactInfo.address,
                    description: "歡迎親自到訪",
                    color: .warning
                ) {
                    openMaps()
                }
                
                ContactMethodCard(
                    icon: "calendar",
                    title: "預約諮詢",
                    value: "線上預約",
                    description: "安排專人服務",
                    color: .brandPrimary
                ) {
                    showingContactForm = true
                }
            }
        }
        .padding()
        .background(Color.backgroundPrimary)
    }
    
    // MARK: - 地圖和地址
    private var locationSection: some View {
        VStack(spacing: 16) {
            Text("服務據點")
                .font(.title1)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            // 地圖
            Map(coordinateRegion: $region, annotationItems: [LocationPin()]) { pin in
                MapAnnotation(coordinate: pin.coordinate) {
                    VStack(spacing: 4) {
                        Image(systemName: "building.2.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.brandPrimary)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        
                        Text("冬山生命禮儀")
                            .font(.captionSmall)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.brandPrimary)
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
            }
            .frame(height: 200)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.borderPrimary, lineWidth: 1)
            )
            
            // 地址資訊卡片
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "location.fill")
                        .font(.title2)
                        .foregroundColor(.brandPrimary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("服務據點地址")
                            .font(.label)
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        Text(dataManager.contactInfo.address)
                            .font(.bodyLarge)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: openMaps) {
                        Image(systemName: "arrow.up.right.square")
                            .font(.title2)
                            .foregroundColor(.brandPrimary)
                    }
                }
                
                Divider()
                
                // 交通資訊
                VStack(alignment: .leading, spacing: 8) {
                    Text("交通資訊")
                        .font(.label)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    ForEach(dataManager.contactInfo.transportationInfo, id: \.self) { info in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundColor(.textTertiary)
                                .padding(.top, 6)
                            
                            Text(info)
                                .font(.bodySmall)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
            }
            .padding()
            .background(Color.backgroundSecondary)
            .cornerRadius(12)
        }
        .padding()
        .background(Color.backgroundPrimary)
    }
    
    // MARK: - 營業時間
    private var businessHoursSection: some View {
        VStack(spacing: 16) {
            Text("服務時間")
                .font(.title1)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                BusinessHourRow(
                    title: "緊急服務",
                    hours: "24小時全年無休",
                    highlight: true
                )
                
                BusinessHourRow(
                    title: "辦公時間",
                    hours: dataManager.contactInfo.businessHours.office
                )
                
                BusinessHourRow(
                    title: "假日服務",
                    hours: dataManager.contactInfo.businessHours.weekend
                )
                
                BusinessHourRow(
                    title: "國定假日",
                    hours: dataManager.contactInfo.businessHours.holiday
                )
            }
            .padding()
            .background(Color.backgroundSecondary)
            .cornerRadius(12)
            
            // 當前狀態指示
            CurrentStatusIndicator(contactInfo: dataManager.contactInfo)
        }
        .padding()
        .background(Color.backgroundPrimary)
    }
    
    // MARK: - 聯絡表單
    private var contactFormSection: some View {
        VStack(spacing: 16) {
            Text("線上諮詢")
                .font(.title1)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("填寫表單，我們會盡快回覆您")
                .font(.bodyLarge)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: { showingContactForm = true }) {
                HStack {
                    Image(systemName: "square.and.pencil")
                    Text("填寫諮詢表單")
                }
                .font(.buttonPrimary)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.brandPrimary)
                .cornerRadius(12)
            }
            
            // 簡易聯絡按鈕
            HStack(spacing: 12) {
                Button(action: { makePhoneCall(dataManager.contactInfo.phone) }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("直接來電")
                    }
                    .font(.buttonSecondary)
                    .foregroundColor(.brandPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(8)
                }
                
                Button(action: openLineChat) {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("LINE諮詢")
                    }
                    .font(.buttonSecondary)
                    .foregroundColor(.success)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.success.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.backgroundPrimary)
        .sheet(isPresented: $showingContactForm) {
            ContactFormSheet()
        }
    }
    
    // MARK: - 常見問題
    private var faqSection: some View {
        VStack(spacing: 16) {
            Text("常見問題")
                .font(.title1)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                FAQItemView(
                    question: "服務範圍涵蓋哪些地區？",
                    answer: "我們主要服務宜蘭縣全境，包括宜蘭市、羅東鎮、冬山鄉等各鄉鎮市。對於鄰近縣市的緊急需求，我們也會視情況提供協助。"
                )
                
                FAQItemView(
                    question: "緊急情況下多久可以到達？",
                    answer: "我們承諾在接到緊急通知後30分鐘內趕達現場（宜蘭縣內）。我們的專業團隊24小時待命，隨時為您提供即時協助。"
                )
                
                FAQItemView(
                    question: "是否提供免費諮詢服務？",
                    answer: "是的，我們提供完全免費的諮詢服務。您可以透過電話、LINE、現場參觀等方式，我們的專業團隊會詳細為您說明服務內容與流程。"
                )
                
                FAQItemView(
                    question: "如何預約參觀設施？",
                    answer: "您可以透過電話或線上表單預約參觀時間。建議您事先預約，我們會安排專人為您導覽介紹，讓您更了解我們的服務環境。"
                )
            }
        }
        .padding()
        .background(Color.backgroundSecondary)
    }
    
    // MARK: - 輔助函數
    private func makePhoneCall(_ phoneNumber: String) {
        let cleanedNumber = phoneNumber.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        if let url = URL(string: "tel://\(cleanedNumber)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func sendEmail() {
        if let url = URL(string: "mailto:\(dataManager.contactInfo.email)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openLineChat() {
        let lineId = dataManager.contactInfo.lineId.replacingOccurrences(of: "@", with: "")
        if let url = URL(string: "https://line.me/ti/p/~\(lineId)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openMaps() {
        let address = dataManager.contactInfo.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "http://maps.apple.com/?q=\(address)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - 子視圖組件

struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate = CLLocationCoordinate2D(latitude: 24.6394, longitude: 121.7900)
}

struct EmergencyCallButton: View {
    let icon: String
    let title: String
    let number: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.error)
                    .cornerRadius(25)
                
                Text(title)
                    .font(.labelSmall)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text(number)
                    .font(.buttonPrimary)
                    .fontWeight(.bold)
                    .foregroundColor(.error)
                
                Text(subtitle)
                    .font(.captionSmall)
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct ContactMethodCard: View {
    let icon: String
    let title: String
    let value: String
    let description: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(color.opacity(0.1))
                    .cornerRadius(25)
                
                Text(title)
                    .font(.label)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text(value)
                    .font(.captionSmall)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(description)
                    .font(.captionSmall)
                    .foregroundColor(color)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
        .shadow(color: .cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct BusinessHourRow: View {
    let title: String
    let hours: String
    let highlight: Bool
    
    init(title: String, hours: String, highlight: Bool = false) {
        self.title = title
        self.hours = hours
        self.highlight = highlight
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.bodyLarge)
                .fontWeight(.medium)
                .foregroundColor(highlight ? .error : .textPrimary)
            
            Spacer()
            
            Text(hours)
                .font(.bodyLarge)
                .fontWeight(highlight ? .bold : .regular)
                .foregroundColor(highlight ? .error : .textSecondary)
        }
        .padding(.vertical, 8)
        .background(highlight ? Color.error.opacity(0.05) : Color.clear)
        .cornerRadius(8)
    }
}

struct CurrentStatusIndicator: View {
    let contactInfo: ContactInfo
    
    private var isOpen: Bool {
        // 簡化的營業狀態判斷邏輯
        let calendar = Calendar.current
        let now = Date()
        let hour = calendar.component(.hour, from: now)
        
        // 這裡可以根據實際營業時間進行判斷
        return hour >= 8 && hour < 18
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(isOpen ? Color.success : Color.warning)
                .frame(width: 12, height: 12)
            
            Text(isOpen ? "目前營業中" : "目前非營業時間")
                .font(.bodyLarge)
                .fontWeight(.medium)
                .foregroundColor(isOpen ? .success : .warning)
            
            Spacer()
            
            Text("緊急服務24小時可用")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .padding()
        .background(Color.backgroundTertiary)
        .cornerRadius(8)
    }
}

struct FAQItemView: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(question)
                        .font(.bodyLarge)
                        .fontWeight(.medium)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            if isExpanded {
                Text(answer)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(2)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(Color.backgroundPrimary)
        .cornerRadius(12)
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }
}

// MARK: - 聯絡表單頁面
struct ContactFormSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var inquiryType = InquiryType.general
    @State private var message = ""
    @State private var agreeToTerms = false
    @State private var isSubmitting = false
    
    enum InquiryType: String, CaseIterable {
        case general = "一般諮詢"
        case funeral = "告別式規劃"
        case burial = "殯葬服務"
        case cemetery = "墓園塔位"
        case other = "其他服務"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 表單說明
                    VStack(spacing: 8) {
                        Text("線上諮詢表單")
                            .font(.title1)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                        
                        Text("請填寫以下資訊，我們會盡快回覆您")
                            .font(.bodyLarge)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    // 表單內容
                    VStack(spacing: 16) {
                        FormField(title: "姓名", text: $name, placeholder: "請輸入您的姓名", required: true)
                        FormField(title: "聯絡電話", text: $phone, placeholder: "請輸入您的電話", required: true)
                        FormField(title: "電子郵件", text: $email, placeholder: "請輸入您的信箱（選填）")
                        
                        // 諮詢類型選擇
                        VStack(alignment: .leading, spacing: 8) {
                            Text("諮詢類型")
                                .font(.label)
                                .fontWeight(.medium)
                                .foregroundColor(.textPrimary)
                            
                            Picker("諮詢類型", selection: $inquiryType) {
                                ForEach(InquiryType.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        // 詳細內容
                        VStack(alignment: .leading, spacing: 8) {
                            Text("詳細內容")
                                .font(.label)
                                .fontWeight(.medium)
                                .foregroundColor(.textPrimary)
                            
                            TextEditor(text: $message)
                                .frame(minHeight: 100)
                                .padding(8)
                                .background(Color.backgroundSecondary)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.borderPrimary, lineWidth: 1)
                                )
                        }
                        
                        // 同意條款
                        HStack {
                            Button(action: { agreeToTerms.toggle() }) {
                                Image(systemName: agreeToTerms ? "checkmark.square" : "square")
                                    .foregroundColor(agreeToTerms ? .brandPrimary : .textTertiary)
                            }
                            
                            Text("我同意提供個人資料供諮詢服務使用")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            Spacer()
                        }
                    }
                    .padding()
                    
                    // 提交按鈕
                    Button(action: submitForm) {
                        if isSubmitting {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("提交中...")
                            }
                        } else {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                Text("送出諮詢")
                            }
                        }
                    }
                    .font(.buttonPrimary)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isFormValid ? Color.brandPrimary : Color.textTertiary)
                    .cornerRadius(12)
                    .disabled(!isFormValid || isSubmitting)
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !phone.isEmpty && !message.isEmpty && agreeToTerms
    }
    
    private func submitForm() {
        isSubmitting = true
        
        // 模擬提交過程
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSubmitting = false
            presentationMode.wrappedValue.dismiss()
            // 這裡可以加入成功提示
        }
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let required: Bool
    
    init(title: String, text: Binding<String>, placeholder: String, required: Bool = false) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.required = required
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.label)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
                
                if required {
                    Text("*")
                        .foregroundColor(.error)
                }
            }
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

// MARK: - 預覽
struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
            .environmentObject(DataManager())
    }
} 