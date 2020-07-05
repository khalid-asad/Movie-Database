//
//  NetworkRequestProtocol.swift
//  TMDb
//
//  Created by Khalid Asad on 11/13/19.
//  Copyright © 2019 Khalid Asad. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkRequestProtocol {
    
    /// Fetches a query to the TMDb with a search term.
    /// - parameter term: A search term in the format of a String (hopefully percent encoded).
    func fetchQuery(_ term: String, page: Int, completion: @escaping (FetchInfoState<MovieSearchQuery?, Error>) -> Void)
    
    /// Fetches the credits against the API through URLSession downloadTask.
    /// - parameter id: The respective movie ID to query against.
    func fetchCredits(for id: Int, completion: @escaping (FetchInfoState<CreditsResponse?, Error>) -> Void)
    
    /// Downloads an image with a URL.
    /// - parameter url: The URL to download the image from.
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void)
}
