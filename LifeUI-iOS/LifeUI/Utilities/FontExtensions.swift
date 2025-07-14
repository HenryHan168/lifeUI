//
//  FontExtensions.swift
//  LifeUI
//
//  冬山生命禮儀公司字體系統
//  定義應用程式中使用的所有字體樣式
//

import SwiftUI

extension Font {
    
    // MARK: - 標題字體
    
    /// 大標題 - 主頁面標題
    static let largeTitle = Font.system(size: 32, weight: .bold, design: .rounded)
    
    /// 主標題 - 頁面標題
    static let title1 = Font.system(size: 28, weight: .bold, design: .default)
    
    /// 次標題 - 區塊標題
    static let title2 = Font.system(size: 24, weight: .semibold, design: .default)
    
    /// 小標題 - 卡片標題
    static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
    
    // MARK: - 內文字體
    
    /// 大內文 - 重要內容
    static let bodyLarge = Font.system(size: 18, weight: .regular, design: .default)
    
    /// 標準內文 - 一般內容
    static let body = Font.system(size: 16, weight: .regular, design: .default)
    
    /// 小內文 - 輔助說明
    static let bodySmall = Font.system(size: 14, weight: .regular, design: .default)
    
    // MARK: - 說明字體
    
    /// 標籤文字 - 按鈕、標籤
    static let label = Font.system(size: 16, weight: .medium, design: .default)
    
    /// 小標籤 - 狀態、標記
    static let labelSmall = Font.system(size: 14, weight: .medium, design: .default)
    
    /// 說明文字 - 提示、幫助
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    
    /// 小說明 - 版權、細節
    static let captionSmall = Font.system(size: 10, weight: .regular, design: .default)
    
    // MARK: - 特殊字體
    
    /// 數字字體 - 價格、統計
    static let number = Font.system(size: 18, weight: .semibold, design: .monospaced)
    
    /// 大數字 - 重要數據
    static let numberLarge = Font.system(size: 24, weight: .bold, design: .monospaced)
    
    /// 引用文字 - 客戶評價
    static let quote = Font.system(size: 16, weight: .regular, design: .serif)
    
    // MARK: - 按鈕字體
    
    /// 主要按鈕
    static let buttonPrimary = Font.system(size: 16, weight: .semibold, design: .default)
    
    /// 次要按鈕
    static let buttonSecondary = Font.system(size: 14, weight: .medium, design: .default)
    
    /// 小按鈕
    static let buttonSmall = Font.system(size: 12, weight: .medium, design: .default)
}

// MARK: - 自定義字體修飾器
struct CustomFontModifier: ViewModifier {
    let font: Font
    let color: Color
    let lineLimit: Int?
    
    init(font: Font, color: Color = .textPrimary, lineLimit: Int? = nil) {
        self.font = font
        self.color = color
        self.lineLimit = lineLimit
    }
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .lineLimit(lineLimit)
    }
}

// MARK: - View 擴展
extension View {
    
    // 標題樣式
    func titleStyle() -> some View {
        modifier(CustomFontModifier(font: .title1, color: .textPrimary))
    }
    
    func subtitleStyle() -> some View {
        modifier(CustomFontModifier(font: .title2, color: .textPrimary))
    }
    
    // 內文樣式
    func bodyStyle() -> some View {
        modifier(CustomFontModifier(font: .body, color: .textPrimary))
    }
    
    func bodySecondaryStyle() -> some View {
        modifier(CustomFontModifier(font: .body, color: .textSecondary))
    }
    
    // 說明樣式
    func captionStyle() -> some View {
        modifier(CustomFontModifier(font: .caption, color: .textSecondary))
    }
    
    func labelStyle() -> some View {
        modifier(CustomFontModifier(font: .label, color: .textPrimary))
    }
    
    // 數字樣式
    func numberStyle() -> some View {
        modifier(CustomFontModifier(font: .number, color: .brandPrimary))
    }
    
    // 引用樣式
    func quoteStyle() -> some View {
        modifier(CustomFontModifier(font: .quote, color: .textSecondary))
    }
} 