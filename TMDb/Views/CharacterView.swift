//
//  CharacterView.swift
//  TMDb
//
//  Created by Khalid Asad on 4/18/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import UIKit

final class CharacterView: UIView {
    
    private static let placeholderImage = #imageLiteral(resourceName: "default")
    private let size: CGFloat = 24
    private let characterViewWidth: CGFloat = (UIScreen.main.bounds.width / 3) - 2
    
    var characterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = ThemeManager().darkColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    var characterStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .center
        return view
    }()
        
    var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.image = placeholderImage
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var actorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    var characterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    func generateCharacterView(actorName: String?, characterName: String?, image: UIImage?) -> UIView {
        guard let actorName = actorName, let characterName = characterName else {
            return UIView()
        }
        
        actorNameLabel.text = actorName
        characterNameLabel.text = characterName
        if let image = image {
            characterImageView.image = image
        }
        
        NSLayoutConstraint.activate([
            characterImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 192)
        ])
        
        characterStackView.addArrangedSubview(characterImageView)
        characterStackView.addArrangedSubview(actorNameLabel)
        characterStackView.addArrangedSubview(characterNameLabel)
        
        NSLayoutConstraint.activate([
            characterStackView.widthAnchor.constraint(lessThanOrEqualToConstant: characterViewWidth)
        ])
        
        characterView.addSubview(characterStackView)
        
        NSLayoutConstraint.activate([
            characterView.topAnchor.constraint(equalTo: characterStackView.topAnchor),
            characterView.bottomAnchor.constraint(equalTo: characterStackView.bottomAnchor),
            characterView.leadingAnchor.constraint(equalTo: characterStackView.leadingAnchor),
            characterView.trailingAnchor.constraint(equalTo: characterStackView.trailingAnchor)
        ])
                
        return characterView
    }
}

// MARK: - Private Methods
extension CharacterView {
    
    // Download the image
    private func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.network.async {
            URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                guard let data = try? Data(contentsOf: url), let cellImage = UIImage(data: data) else {
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                DispatchQueue.main.async { completion(cellImage)}
            }).resume()
        }
    }
}
