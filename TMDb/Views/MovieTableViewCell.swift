//
//  MovieTableViewCell.swift
//  TMDb
//
//  Created by Khalid Asad on 11/11/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Table View Cell
class MovieTableViewCell: UITableViewCell {

    let movieImageView = UIImageView()
    let movieNameLabel = UILabel()
    let movieDescriptionLabel = UILabel()

    static let defaultImage = #imageLiteral(resourceName: "default")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = ThemeManager.backgroundColor
        
        // Provide a placeholder image, and make sure content mode is aspect fit
        movieImageView.contentMode = .scaleAspectFit
        movieImageView.image = MovieTableViewCell.defaultImage
        
        // Add the views
        [movieImageView, movieNameLabel, movieDescriptionLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        // Set font for labels using a custom Theme Manager
        movieNameLabel.font = ThemeManager.titleFont
        movieDescriptionLabel.font = ThemeManager.subTitleFont
        
        // Ensure the labels can handle multiple lines
        [movieNameLabel, movieDescriptionLabel].forEach() {
            $0.textColor = ThemeManager.textColor
            $0.numberOfLines = 0
        }
        
        movieNameLabel.lineBreakMode = .byWordWrapping
        
        movieDescriptionLabel.text = "placeholder"
        
        let viewsDict = [
            "movieImage": movieImageView,
            "movieName": movieNameLabel,
            "movieDesc": movieDescriptionLabel,
        ]
        
        /* Programmatically set the layout to
            Image   Title           ...     ...
            ...     Description     ...     ...
            ...     ...             ...     ...
         */
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[movieImage]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[movieName]-(4)-[movieDesc]-(>=8)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[movieImage(128)]-(16)-[movieName]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[movieImage(128)]-(16)-[movieDesc]-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
