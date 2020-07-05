//
//  MovieViewController.swift
//  TMDb
//
//  Created by Khalid Asad on 11/11/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import UIKit

// MARK: - Movie View Controller Class
final class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var model: MovieModel!
    private var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    private var searchController: UISearchController!
    
    private var searchQuery: String?
    private var searchScope: Genres? = .all
    
    private static let placeHolderImage = #imageLiteral(resourceName: "default")
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        overrideUserInterfaceStyle = .dark
        
        model = MovieModel()

        configureNavigationBar()
        configureTableView()
        configureSearchController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Upon changing the orientation of the device, reset the size of the tableView.
        tableView.frame = CGRect(
            x: 0,
            y: UIApplication.shared.statusBarFrame.size.height,
            width: view.frame.width,
            height: view.frame.height
        )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 128 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = model.items[safe: (indexPath as NSIndexPath).row] else { return }
        let image = model.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage ?? MovieViewController.placeHolderImage
        
        let vc = MovieDetailsViewController(model: viewModel, image: image)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // When scrolling past the last cell, load the next page of data.
        if indexPath.row == model.items.count - 1 , let searchQuery = searchQuery {
            fetch(query: searchQuery)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? MovieTableViewCell,
            let movie = model.items[safe: (indexPath as NSIndexPath).row]
        else { return MovieTableViewCell() }
        
        cell.movieNameLabel.text = movie.title
        cell.movieDescriptionLabel.text = movie.overview
        cell.movieImageView.image = MovieViewController.placeHolderImage
        
        // If there is a cached image, set it to the view.
        guard model.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) == nil else {
            cell.movieImageView.image = model.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            return cell
        }
        
        // If the url does not exist, simply return the cell.
        guard let backdropPath = movie.backdropPath,
            let url = URL(string: StringKey.imageBaseURL.rawValue + backdropPath)
        else { return cell }
        
        // Add an activity indicator on the Image.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = cell.movieImageView.bounds
        cell.movieImageView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        // Download the image, and set it if it's available.
        model.fetchImage(url: url, completion: { [weak self] cellImage in
            guard let self = self else { return }
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                // Indirectly access the cell in an Async method to prevent memory leaks.
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                if let updateCell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell {
                    guard let cellImage = cellImage else { return }
                    updateCell.movieImageView.image = cellImage
                    self?.model.cache.setObject(cellImage, forKey: (indexPath as NSIndexPath).row as AnyObject)
                }
            })
        })
        
        return cell
    }
}

// MARK: - Search Controller
extension MovieViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    /// Protocol function for searching.
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let searchBarText = searchBar.text else { return }
        // Search with the text from the Search Bar
        search(for: searchBarText)
    }
    
    /// Protocol function for text changing, we want to clear the cache and then search.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchBarText = searchBar.text else { return }
        // Search with the text from the Search Bar
        clearDataAndCache()
        search(for: searchBarText)
    }
    
    /// Protocol function for Scopes (so we can sort by Genres).
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchScope = Genres.allCases[selectedScope]
        search(for: searchBar.text ?? "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}

// MARK: - Private Methods
extension MovieViewController {
    
    /// Asynchronously reload the tableView data and end refreshing.
    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    /// Configure the navigation bar theme.
    private func configureNavigationBar() {
        guard let navigationController = navigationController else { return }
        let navigationBar = navigationController.navigationBar
        
        navigationBar.prefersLargeTitles = true
        navigationBar.backgroundColor = ThemeManager.navigationBarColor
        navigationBar.tintColor = ThemeManager.navigationBarTextColor
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = ThemeManager.navigationBarTextColor
        navigationItem.backBarButtonItem = backButton
        
        title = "TMDb"
    }
    
    /// Configure the Table View.
    private func configureTableView() {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = view.frame.width
        let displayHeight: CGFloat = view.frame.height
        
        // Set the table view within the frame
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight))
        tableView.register(MovieTableViewCell.classForCoder(), forCellReuseIdentifier: "MyCell")

        // Estimate a row height of 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        // Set the data source and delegate to the current VC
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = ThemeManager.backgroundColor
        
        view.addSubview(tableView)
        
        // Create a refresh control and target it to the reloadTableView function for any values changed
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // Set the initial cache and data within the model to be empty
        model.cache = NSCache()
        model.items = []
    }
    
    /// Configures the Search Controller in the Navigation bar.
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.scopeButtonTitles = Genres.allCases.map { $0.name }
        searchController.searchBar.delegate = self
        
        configureSearchBarTheme()
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /// Configures the Search Bar Segmented Control and Bar Button Item themes.
    private func configureSearchBarTheme() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor: ThemeManager.navigationBarTextColor], for: .normal)
        let segmentedControl = UISegmentedControl.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        segmentedControl.setTitleTextAttributes([.foregroundColor: ThemeManager.navigationBarTextColor], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: ThemeManager.complementedColor], for: .selected)
        segmentedControl.selectedSegmentTintColor = ThemeManager.backgroundColor
        searchController.searchBar.tintColor = ThemeManager.navigationBarTextColor
    }
    
    /// Function to search by cancelling previous requests, and creating a new one.
    private func search(for text: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reloadTableView), object: nil)
        clearDataAndCache()
        searchQuery = text
        perform(#selector(reloadTableView), with: nil, afterDelay: 0.25)
    }
    
    /// Clears the cache in the model, then reloads the data in the table view.
    private func clearDataAndCache() {
        model.items.removeAll()
        model.cache.removeAllObjects()
        reloadData()
    }
    
    /// Reload the table view by fetching the search query.
    @objc
    private func reloadTableView() {
        // If search query is non-existent then wipe the data and cache and return
        guard let searchQuery = searchQuery, !searchQuery.isEmpty else {
            clearDataAndCache()
            return
        }
        fetch(query: searchQuery, page: 1)
    }
    
    /// Fetches the search results from the API through the model.
    private func fetch(query: String, page: Int? = nil) {
        model.fetchQuery(query, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                if let searchScope = self.searchScope, searchScope != .all {
                    self.model.items = self.model.items.filter {
                        $0.genreIDs.contains(searchScope.rawValue)
                    }
                }
                self.reloadData()
            case .failure(let error):
                print("Error: \(String(describing: error))")
            }
        }
    }
}
