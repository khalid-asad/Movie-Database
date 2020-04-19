//
//  RatingView.swift
//  TMDb
//
//  Created by Khalid Asad on 4/18/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import UIKit

final class RatingView: UIView {
    
    private static let fullStarImage = #imageLiteral(resourceName: "fullStar")
    private static let halfStarImage = #imageLiteral(resourceName: "halfStar")
    private let size: CGFloat = 24
    
    var ratingStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .center
        view.distribution = .equalCentering
        return view
    }()
    
    var starsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        return view
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    func generateRatingView(voteAverage: Double) -> UIView {
        let rating = voteAverage / 2.0
        let stars = Int(rating.round(nearest: 0.5) / 0.5)
        
        guard rating != 0 else {
            ratingLabel.text = "Unrated!"
            return ratingLabel
        }
        
        for _ in 1...(stars/2) {
            addStar()
        }
        
        if stars % 2 == 1 {
            addStar(isHalf: true)
        }
        
        ratingLabel.text = "\(rating)"
        
        NSLayoutConstraint.activate([
            ratingLabel.heightAnchor.constraint(equalToConstant: size),
            ratingLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        ratingStackView.addArrangedSubview(starsStackView)
        ratingStackView.addArrangedSubview(ratingLabel)
        
        return ratingStackView
    }
}

// MARK: - Private Methods
extension RatingView {
    
    private func addStar(isHalf: Bool = false) {
        let starImageView = UIImageView()
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.image = isHalf ? RatingView.halfStarImage : RatingView.fullStarImage
        starImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            starImageView.heightAnchor.constraint(equalToConstant: size),
            starImageView.widthAnchor.constraint(equalToConstant: size)
        ])
        
        starsStackView.addArrangedSubview(starImageView)
    }
}
