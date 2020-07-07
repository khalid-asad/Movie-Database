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
        
        overrideUserInterfaceStyle = .dark
        
        view.backgroundColor = ThemeManager.backgroundColor
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        
        DispatchQueue.main.async { [weak self] in
            self?.view.addSubview(activityIndicator)
        }
        
        let group = DispatchGroup()
        
        group.enter()
        downloadMovieImages() {
            group.leave()
        }
        
        group.enter()
        fetchCredits { [weak self] in
            guard let self = self else { return group.leave() }
            self.downloadCharacterImages { group.leave() }
        }
        
        group.notify(queue: .main) { [weak self] in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
            }
            self?.setUpViews()
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
    
    var imagesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var imagesStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 2
        return view
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
    
    var characterScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var charactersStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 2
        return view
    }()
}

// MARK: - UI Configuration
extension MovieDetailsViewController {
    
    private func setUpViews() {
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
        
        let ratingView = RatingView().generateRatingView(voteAverage: model.voteAverage)
        
        [titleLabel, ratingView, imagesScrollView, descriptionLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        imagesScrollView.addSubview(imagesStackView)
        
        NSLayoutConstraint.activate([
            imagesScrollView.topAnchor.constraint(equalTo: imagesStackView.topAnchor),
            imagesScrollView.heightAnchor.constraint(equalTo: imagesStackView.heightAnchor),
            imagesScrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        let isOnlyOneMovieImage = imagesStackView.arrangedSubviews.count == 1
        imagesScrollView.leadingAnchor.constraint(equalTo: imagesStackView.leadingAnchor).isActive = !isOnlyOneMovieImage
        imagesScrollView.trailingAnchor.constraint(equalTo: imagesStackView.trailingAnchor).isActive = !isOnlyOneMovieImage
        imagesScrollView.centerXAnchor.constraint(equalTo: imagesStackView.centerXAnchor).isActive = isOnlyOneMovieImage
        
        stackView.addArrangedSubview(characterScrollView)
        
        characterScrollView.addSubview(charactersStackView)
        
        NSLayoutConstraint.activate([
            characterScrollView.topAnchor.constraint(equalTo: charactersStackView.topAnchor),
            characterScrollView.leadingAnchor.constraint(equalTo: charactersStackView.leadingAnchor),
            characterScrollView.trailingAnchor.constraint(equalTo: charactersStackView.trailingAnchor),
            characterScrollView.heightAnchor.constraint(equalTo: charactersStackView.heightAnchor),
            characterScrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func createMovieImageView(from image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        imagesStackView.addArrangedSubview(imageView)
    }
}

// MARK: - Network Requests
extension MovieDetailsViewController {
    
    /// Downloads the character images on a background thread.
    /// Generates the Character Views and inserts into the Character Stack View.
    private func downloadCharacterImages(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        creditsModel?.cast?.forEach() {
            group.enter()
            let actorName = $0.name
            let characterName = $0.character
            if let path = $0.profilePath , let url = URL(string: StringKey.imageBaseURL.rawValue + path) {
                NetworkManager.shared.fetchImage(url: url) { [weak self] image in
                    guard let self = self else {
                        group.leave()
                        return
                    }
                    let characterView = CharacterView().generateCharacterView(
                        actorName: actorName,
                        characterName: characterName,
                        image: image
                    )
                    self.charactersStackView.insertArrangedSubview(characterView, at: 0)
                    group.leave()
                }
            } else {
                let characterView = CharacterView().generateCharacterView(
                    actorName: $0.name,
                    characterName: $0.character,
                    image: nil
                )
                charactersStackView.addArrangedSubview(characterView)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    /// Downloads the movie images on a background thread.
    /// Generates the Movie Images and inserts into the Movie Stack View.
    private func downloadMovieImages(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchMovieImageDetails(for: model.id) { result in
            switch result {
            case .success(let imageDetails):
                guard let imagesToDownload = imageDetails?.backdrops else {
                    return completion()
                }
                let imageDownloadGroup = DispatchGroup()
                imagesToDownload.forEach() { backdrop in
                    imageDownloadGroup.enter()
                    guard let url = URL(string: StringKey.imageBaseURL.rawValue + backdrop.filePath)  else {
                        imageDownloadGroup.leave()
                        return
                    }
                    NetworkManager.shared.fetchImage(url: url) { [weak self] image in
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self, let image = image else { return imageDownloadGroup.leave() }
                            self.createMovieImageView(from: image)
                        }
                        imageDownloadGroup.leave()
                    }
                }
                imageDownloadGroup.notify(queue: .main) {
                    completion()
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    /// Fetches the movie credits on a background thread.
    private func fetchCredits(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchCredits(for: model.id) { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.creditsModel = response
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
