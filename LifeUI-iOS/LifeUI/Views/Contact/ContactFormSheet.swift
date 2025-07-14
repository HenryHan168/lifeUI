//
//  ContactFormSheet.swift
//  LifeUI
//
//  冬山生命禮儀公司聯絡表單頁面
//  提供線上諮詢表單功能
//

import SwiftUI

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
        
        FirebaseService.shared.submitInquiry(
            name: name,
            phone: phone,
            email: email,
            type: inquiryType.rawValue,
            message: message
        ) { result in
            DispatchQueue.main.async {
                isSubmitting = false
                
                switch result {
                case .success:
                    // 顯示成功訊息
                    let alert = UIAlertController(
                        title: "提交成功",
                        message: "我們會盡快與您聯繫",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "確定", style: .default) { _ in
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                    
                case .failure(let error):
                    // 顯示錯誤訊息
                    let alert = UIAlertController(
                        title: "提交失敗",
                        message: "請稍後再試或直接撥打電話聯繫我們",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "確定", style: .default))
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                }
            }
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
struct ContactFormSheet_Previews: PreviewProvider {
    static var previews: some View {
        ContactFormSheet()
    }
} 