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
        
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        model = MovieModel()

        configureNavigationBar()
        configureTableView()
        configureSearchController()
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
        search(for: searchBarText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchBarText = searchBar.text else { return }
        search(for: searchBarText)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard var scopeText = searchBar.scopeButtonTitles?[selectedScope] else { return }
        if scopeText == PopularMovies.all.rawValue { scopeText = searchBar.text ?? "" }
        searchBar.text = scopeText
        search(for: scopeText)
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
extension ViewController {
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func configureNavigationBar() {
        guard let navigationController = navigationController else { return }
        let navigationBar = navigationController.navigationBar
        
        navigationBar.prefersLargeTitles = true
        navigationBar.backgroundColor = ThemeManager().navigationBarColor
        
        title = "TMDb"
    }
    
    private func configureTableView() {
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
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.scopeButtonTitles = PopularMovies.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func search(for text: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reloadTableView), object: nil)
        if text != searchQuery || text.isEmpty {
            model.items.removeAll()
            model.cache.removeAllObjects()
        }
        searchQuery = text
        self.perform(#selector(reloadTableView), with: nil, afterDelay: 0.25)
    }
    
    @objc
    private func reloadTableView() {
        guard let searchQuery = searchQuery else { return }
        guard !searchQuery.isEmpty else {
            model.items.removeAll()
            model.cache.removeAllObjects()
            reloadData()
            return
        }
        // TODO - Fix this query
        model.fetchQuery(searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" + "&entity=software", completion: { [weak self] result in
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
