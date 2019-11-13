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
        
    // MARK: - Fonts
    var headerFont: UIFont {
        guard let font = UIFont(name: "Helvetica-Bold", size: 32) else { return UIFont.systemFont(ofSize: 32, weight: .bold)}
        return font
    }
    
    var subHeaderFont: UIFont {
        guard let font = UIFont(name: "Helvetica", size: 20) else { return UIFont.systemFont(ofSize: 20) }
        return font
    }
    
    var titleFont: UIFont {
        guard let font = UIFont(name: "Helvetica-Bold", size: 20) else { return UIFont.systemFont(ofSize: 20, weight: .bold)}
        return font
    }
    
    var subTitleFont: UIFont {
        guard let font = UIFont(name: "Helvetica", size: 16) else { return UIFont.systemFont(ofSize: 16)}
        return font
    }
    
    var smallTitleFont: UIFont {
        guard let font = UIFont(name: "Helvetica", size: 12) else { return UIFont.systemFont(ofSize: 12)}
        return font
    }
    
    // MARK: - Colors
    var darkColor: UIColor {
        return UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0) /* #212121 */
    }
    
    var lightColor: UIColor {
        return .white
    }
        
    var navigationBarColor: UIColor {
        return UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
    }
    
    var tableViewCellColor: UIColor {
        return .white
    }
}
