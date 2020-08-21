//
//  DispatchQueue+Extensions.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 8/16/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

extension DispatchQueue {
    
    static let network = DispatchQueue(label: "network", qos: .background)
}
