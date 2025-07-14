//
//  ColorExtensions.swift
//  LifeUI
//
//  冬山生命禮儀公司品牌色彩系統
//  定義應用程式中使用的所有顏色
//

import SwiftUI

extension Color {
    
    // MARK: - 品牌主色調
    
    /// 品牌主色 - 深藍色 (專業、信任)
    static let brandPrimary = Color(red: 0.12, green: 0.23, blue: 0.54)
    
    /// 品牌次色 - 金色 (尊貴、溫暖)
    static let brandSecondary = Color(red: 0.85, green: 0.65, blue: 0.13)
    
    /// 品牌輔助色 - 溫暖米白色 (溫和、安慰)
    static let brandAccent = Color(red: 0.98, green: 0.96, blue: 0.92)
    
    // MARK: - 功能色彩
    
    /// 成功色 - 綠色
    static let success = Color(red: 0.13, green: 0.69, blue: 0.30)
    
    /// 警告色 - 橙色
    static let warning = Color(red: 1.0, green: 0.58, blue: 0.0)
    
    /// 錯誤色 - 紅色
    static let error = Color(red: 0.91, green: 0.30, blue: 0.24)
    
    /// 資訊色 - 淺藍色
    static let info = Color(red: 0.20, green: 0.68, blue: 0.93)
    
    // MARK: - 灰階色彩
    
    /// 深灰色 - 主要文字
    static let textPrimary = Color(red: 0.13, green: 0.13, blue: 0.13)
    
    /// 中灰色 - 次要文字
    static let textSecondary = Color(red: 0.46, green: 0.46, blue: 0.50)
    
    /// 淺灰色 - 輔助文字
    static let textTertiary = Color(red: 0.71, green: 0.71, blue: 0.76)
    
    /// 背景色 - 主要
    static let backgroundPrimary = Color(red: 1.0, green: 1.0, blue: 1.0)
    
    /// 背景色 - 次要
    static let backgroundSecondary = Color(red: 0.97, green: 0.97, blue: 0.97)
    
    /// 背景色 - 第三級
    static let backgroundTertiary = Color(red: 0.95, green: 0.95, blue: 0.97)
    
    // MARK: - 漸層色彩
    
    /// 主要漸層 - 深藍到金色
    static let primaryGradient = LinearGradient(
        colors: [brandPrimary, brandSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// 溫暖漸層 - 金色到米白
    static let warmGradient = LinearGradient(
        colors: [brandSecondary, brandAccent],
        startPoint: .top,
        endPoint: .bottom
    )
    
    /// 冷色漸層 - 深藍到淺藍
    static let coolGradient = LinearGradient(
        colors: [brandPrimary, info],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - 特殊用途色彩
    
    /// 卡片陰影色
    static let cardShadow = Color.black.opacity(0.08)
    
    /// 分隔線色
    static let separator = Color(red: 0.90, green: 0.90, blue: 0.90)
    
    /// 邊框色 - 主要
    static let borderPrimary = Color(red: 0.85, green: 0.85, blue: 0.85)
    
    /// 邊框色 - 次要
    static let borderSecondary = Color(red: 0.92, green: 0.92, blue: 0.92)
    
    /// 高亮色 - 按鈕按下狀態
    static let highlight = brandPrimary.opacity(0.1)
    
    /// 遮罩色 - 半透明遮罩
    static let overlay = Color.black.opacity(0.4)
}

// MARK: - UIColor 擴展（用於 UIKit 組件）
extension UIColor {
    
    /// 品牌主色 UIColor 版本
    static let brandPrimary = UIColor(red: 0.12, green: 0.23, blue: 0.54, alpha: 1.0)
    
    /// 品牌次色 UIColor 版本
    static let brandSecondary = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1.0)
    
    /// 品牌輔助色 UIColor 版本
    static let brandAccent = UIColor(red: 0.98, green: 0.96, blue: 0.92, alpha: 1.0)
} 