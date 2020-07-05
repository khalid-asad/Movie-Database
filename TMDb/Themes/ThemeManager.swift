//
//  ThemeManager.swift
//  TMDb
//
//  Created by Khalid Asad on 11/11/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import Foundation
import UIKit

struct ThemeManager {
        
    static var isDarkMode: Bool {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate
        else { return false }
        let window = sceneDelegate.window
        return window?.traitCollection.userInterfaceStyle == .light || window?.traitCollection.userInterfaceStyle == .unspecified
    }
    
    // MARK: - Fonts
    static var headerFont: UIFont {
        guard let font = UIFont(name: "Helvetica-Bold", size: 32) else { return UIFont.systemFont(ofSize: 32, weight: .bold)}
        return font
    }
    
    static var subHeaderFont: UIFont {
        guard let font = UIFont(name: "Helvetica", size: 20) else { return UIFont.systemFont(ofSize: 20) }
        return font
    }
    
    static var titleFont: UIFont {
        guard let font = UIFont(name: "Helvetica-Bold", size: 20) else { return UIFont.systemFont(ofSize: 20, weight: .bold)}
        return font
    }
    
    static var subTitleFont: UIFont {
        guard let font = UIFont(name: "Helvetica", size: 14) else { return UIFont.systemFont(ofSize: 16)}
        return font
    }
    
    static var smallTitleFont: UIFont {
        guard let font = UIFont(name: "Helvetica", size: 12) else { return UIFont.systemFont(ofSize: 12)}
        return font
    }
    
    // MARK: - Colors
    static var darkColor: UIColor {
        UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0) /* #212121 */
    }
    
    static var lightColor: UIColor {
        .white
    }
        
    static var backgroundColor: UIColor {
        isDarkMode ? ThemeManager.darkColor : ThemeManager.lightColor
    }
    
    static var navigationBarColor: UIColor {
        UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
    }
    
    static var navigationBarTextColor: UIColor {
        isDarkMode ? .white : .black
    }
    
    static var borderColor: UIColor {
        isDarkMode ? .white : UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
    }
    
    static var textColor: UIColor {
        isDarkMode ? .white : UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
    }
    
    static var tableViewCellColor: UIColor {
        .white
    }
}
