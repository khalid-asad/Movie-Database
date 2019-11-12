//
//  ViewController.swift
//  TMDb
//
//  Created by Khalid Asad on 11/11/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var model: MovieModel!
    private var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var tableData: [AnyObject]!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache: NSCache<AnyObject, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        reloadTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? MovieTableViewCell,
            let dictionary = tableData[(indexPath as NSIndexPath).row] as? [String: AnyObject]
        else { return UITableViewCell() }
        cell.movieNameLabel.text = dictionary["trackName"] as? String
        cell.movieImageView.image = UIImage(named: "placeholder")
        
        guard cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) == nil  else {
            cell.movieImageView.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            return cell
        }
        
        guard let artworkUrl = dictionary["artworkUrl100"] as? String,
            let url = URL(string: artworkUrl)
            else { return UITableViewCell() }
        
        task = session.downloadTask(with: url, completionHandler: { [weak self] (location, response, error) -> Void in
            guard let self = self else { return }
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async(execute: { () -> Void in
                    if let updateCell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell {
                        guard let cellImage = UIImage(data: data) else { return }
                        updateCell.movieImageView.image = cellImage
                        self.cache.setObject(cellImage, forKey: (indexPath as NSIndexPath).row as AnyObject)
                    }
                })
            }
        })
        task.resume()
        return cell
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
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight))
        tableView.register(MovieTableViewCell.classForCoder(), forCellReuseIdentifier: "MyCell")

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        session = URLSession.shared
        task = URLSessionDownloadTask()
                
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.reloadTableView), for: .valueChanged)
        tableView.refreshControl = self.refreshControl
                
        tableData = []
        cache = NSCache()
    }
    
    @objc
    private func reloadTableView() {
        guard let url = URL(string: "https://itunes.apple.com/search?term=flappy&entity=software") else { return }
        task = session.downloadTask(with: url, completionHandler: { [weak self] (url: URL?, response: URLResponse?, error: Error?) -> Void in
            guard let self = self, let url = url else { return }
            do {
                guard let data = try? Data(contentsOf: url) else { return }
                let dic = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
                self.tableData = dic.value(forKey : "results") as? [AnyObject]
                self.reloadData()
            } catch {
                print("Error: \(error)")
            }
        })
        task.resume()
    }
}
