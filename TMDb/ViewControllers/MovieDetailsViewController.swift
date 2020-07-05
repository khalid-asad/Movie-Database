//
//  MovieDetailsViewController.swift
//  TMDb
//
//  Created by Khalid Asad on 4/17/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    
    var model: MovieSearchResult!
    var image: UIImage!
    
    var creditsModel: CreditsResponse?
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    init(model: MovieSearchResult, image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        NetworkManager.shared.fetchCredits(for: model.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.creditsModel = response
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            self.setUpViews() { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
        
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var charactersStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 2
        return view
    }()
}

// MARK: - Private Methods
extension MovieDetailsViewController {
    
    private func setUpViews(completion: @escaping () -> Void) {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
                
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        titleLabel.text = "\(model.title) (\(model.releaseDate?.toStringYear ?? ""))"
        imageView.image = image
        descriptionLabel.text = model.overview
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 288)
        ])
        
        let ratingView = RatingView().generateRatingView(voteAverage: model.voteAverage)
        
        [titleLabel, ratingView, imageView, descriptionLabel].forEach {
            stackView.addArrangedSubview($0)
        }
                        
        let characterScrollView = UIScrollView()
        characterScrollView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(characterScrollView)
        
        let group = DispatchGroup()
        creditsModel?.cast?.forEach() {
            defer { group.leave() }
            group.enter()
            let actorName = $0.name
            let characterName = $0.character
            if let path = $0.profilePath , let url = URL(string: StringKey.imageBaseURL.rawValue + path) {
                NetworkManager.shared.fetchImage(url: url) { [weak self] image in
                    guard let self = self else { return }
                    let characterView = CharacterView().generateCharacterView(
                        actorName: actorName,
                        characterName: characterName,
                        image: image
                    )
                    self.charactersStackView.insertArrangedSubview(characterView, at: 0)
                }
            } else {
                let characterView = CharacterView().generateCharacterView(
                    actorName: $0.name,
                    characterName: $0.character,
                    image: nil
                )
                charactersStackView.addArrangedSubview(characterView)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return completion() }
            characterScrollView.addSubview(self.charactersStackView)
            
            NSLayoutConstraint.activate([
                characterScrollView.topAnchor.constraint(equalTo: self.charactersStackView.topAnchor),
                characterScrollView.leadingAnchor.constraint(equalTo: self.charactersStackView.leadingAnchor),
                characterScrollView.trailingAnchor.constraint(equalTo: self.charactersStackView.trailingAnchor),
                characterScrollView.heightAnchor.constraint(equalTo: self.charactersStackView.heightAnchor),
                characterScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
            ])
            
            completion()
        }
    }
}
