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
    
    var characterStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .center
        view.distribution = .equalCentering
        return view
    }()
    
    var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var actorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var characterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    func generateCharacterView(actorName: String?, characterName: String?, path: String?) -> UIView {
        guard let actorName = actorName, let characterName = characterName else {
            return UIView()
        }
        
        actorNameLabel.text = actorName
        characterNameLabel.text = characterName
        characterImageView.image = CharacterView.placeholderImage
        
        if let path = path , let url = URL(string: StringKey.imageBaseURL.rawValue + path) {
            fetchImage(url: url) { [weak self] image in
                self?.characterImageView.image = image ?? CharacterView.placeholderImage
            }
        }
        
        characterStackView.addArrangedSubview(characterImageView)
        characterStackView.addArrangedSubview(actorNameLabel)
        characterStackView.addArrangedSubview(characterNameLabel)
                
        return characterStackView
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
