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
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
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
}

// MARK: - Private Methods
extension MovieDetailsViewController {
    
    private func setUpViews() {
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
                
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
