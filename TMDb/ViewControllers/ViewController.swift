//
//  ViewController.swift
//  TMDb
//
//  Created by Khalid Asad on 11/11/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import UIKit

// MARK: - Main View Controller Class
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var model: MovieModel!
    private var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    private var searchController: UISearchController!
    
    private var searchQuery: String?
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TMDb"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = ThemeManager().navigationBarColor
        
        model = MovieModel()

        setupTableView()
        setupSearchController()
        reloadTableView()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? MovieTableViewCell,
            let dictionary = model.items[(indexPath as NSIndexPath).row] as? [String: AnyObject]
        else { return UITableViewCell() }
        cell.movieNameLabel.text = dictionary["trackName"] as? String
        cell.movieImageView.image = UIImage(named: "")
        
        guard model.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) == nil  else {
            cell.movieImageView.image = model.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            return cell
        }
        
        guard let artworkUrl = dictionary["artworkUrl100"] as? String,
            let url = URL(string: artworkUrl)
        else { return cell }
        
        model.fetchImage(url: url, completion: { [weak self] cellImage in
            guard let self = self, let cellImage = cellImage else { return }
            DispatchQueue.main.async(execute: { () -> Void in
                if let updateCell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell {
                    updateCell.movieImageView.image = cellImage
                    self.model.cache.setObject(cellImage, forKey: (indexPath as NSIndexPath).row as AnyObject)
                }
            })
        })
        
        return cell
    }
}

// MARK: - Search Controller
extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let searchBarText = searchBar.text else { return }
        if searchBarText != searchQuery { model.cache.removeAllObjects() }
        searchQuery = searchBarText
        reloadTableView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil { model.cache.removeAllObjects() }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reloadTableView), object: nil)
        self.perform(#selector(reloadTableView), with: nil, afterDelay: 0.5)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let scopeText = searchBar.scopeButtonTitles?[selectedScope] else { return }
        searchBar.text = scopeText
        if scopeText != searchQuery { model.cache.removeAllObjects() }
        searchQuery = scopeText
        reloadTableView()
    }
}
// MARK: - Private Methods
extension ViewController {
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func setupTableView() {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = view.frame.width
        let displayHeight: CGFloat = view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight))
        tableView.register(MovieTableViewCell.classForCoder(), forCellReuseIdentifier: "MyCell")

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
                        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
        tableView.refreshControl = self.refreshControl
               
        model.cache = NSCache()
        model.items = []
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.scopeButtonTitles = PopularMovies.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc
    private func reloadTableView() {
        // TODO - Fix this query
        model.fetchQuery(searchQuery?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" + "&entity=software", completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.reloadData()
            case .failure(let error):
                print("Error: \(String(describing: error))")
            }
        })
    }
}
