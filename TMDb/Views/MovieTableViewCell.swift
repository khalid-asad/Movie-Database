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
    let movieDateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        movieImageView.backgroundColor = .blue
        movieImageView.contentMode = .scaleAspectFit
        
        [movieImageView, movieNameLabel, movieDateLabel].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        movieNameLabel.font = ThemeManager().titleFont
        movieDateLabel.font = ThemeManager().subTitleFont
        
        [movieNameLabel, movieDateLabel].forEach() {
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
        }
        
        let viewsDict = [
            "movieImage": movieImageView,
            "movieName": movieNameLabel,
            "movieDate": movieDateLabel,
        ]

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[movieImage]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[movieName]-(4)-[movieDate]-(>=8)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[movieImage(<=128)]-(16)-[movieName]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[movieImage(<=128)]-(16)-[movieDate]-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
