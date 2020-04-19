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
                
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        fetchCredits(for: model.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.creditsModel = response
            case .failure(let error):
                print(error?.localizedDescription ?? "Unknown error")
            }
            
            self.setUpViews()
            self.activityIndicator.stopAnimating()
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
        
        creditsModel?.cast?.forEach() {
            let characterView = CharacterView().generateCharacterView(
                actorName: $0.name,
                characterName: $0.character,
                path: $0.profilePath
            )
            charactersStackView.addArrangedSubview(characterView)
        }
        
        characterScrollView.addSubview(charactersStackView)
        
        NSLayoutConstraint.activate([
            characterScrollView.topAnchor.constraint(equalTo: charactersStackView.topAnchor),
            characterScrollView.leadingAnchor.constraint(equalTo: charactersStackView.leadingAnchor),
            characterScrollView.trailingAnchor.constraint(equalTo: charactersStackView.trailingAnchor),
            characterScrollView.heightAnchor.constraint(equalTo: charactersStackView.heightAnchor),
            characterScrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

extension MovieDetailsViewController {
    
    /// Fetch the credits against the API through URLSession downloadTask.
    private func fetchCredits(for id: Int, completion: @escaping (FetchInfoState<CreditsResponse?, Error?>) -> Void) {
        guard let url = URL(string: StringKeyFormatter.creditsURL(id: id).rawValue) else {
            return completion(.failure(nil))
        }
        
        DispatchQueue.network.async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    DispatchQueue.main.async { completion(.failure(nil)) }
                    return
                }
                
                do {
                    let responseData = try JSONDecoder().decode(CreditsResponse.self, from: data)
                    DispatchQueue.main.async { completion(.success(responseData)) }
                } catch let err {
                    print("Err", err)
                    DispatchQueue.main.async { completion(.failure(err)) }
                }
            }.resume()
        }
    }
}
