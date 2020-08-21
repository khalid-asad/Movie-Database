//
//  Emailable.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 8/16/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

import class UIKit.UIApplication

public protocol Emailable: Codable {
    
    /// The application to use to send the e-mail. Default is Microsoft Outlook.
    var application: EmailApplication { get }
    
    /// The body of the e-mail.
    var body: String? { get }
    
    /// The e-mail to send to.
    var reciever: String { get }
    
    /// The e-mail to send from.
    var sender: String { get }
    
    /// The subject of the e-mail.
    var subject: String { get }
    
    /// Sends the e-mail.
    /// - parameter completion: The result of the request.
    func send(completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - Internal Computed Properties.
extension Emailable {
    
    // Default is Microsoft Outlook.
    var application: EmailApplication { .microsoftOutlook }
    
    var encodedSubject: String {
        subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    var encodedBody: String {
        body?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    var url: URL? {
        guard !sender.isEmpty, !reciever.isEmpty, !subject.isEmpty else { return nil }
        let urlString = "\(application.rawValue)//compose?to=\(reciever)&subject=\(encodedSubject)&body=\(encodedBody)&cc=\(sender)"
        return URL(string: urlString)
    }
}

// MARK: Default Implementation
public extension Emailable {
    
    func send(completion: @escaping (Result<Void, EmailErrors>) -> Void) {
        guard UIApplication.shared.canOpenURL(application.urlScheme) else {
            return completion(.failure(.unableToOpenScheme(for: application)))
        }
        
        guard let url = url else { return completion(.failure(.unableToParseURL)) }
        
        UIApplication.shared.open(url, options: [:]) { result in
            completion(result ? .success(()) : .failure(.unableToSendEmail))
        }
    }
}
