//
//  EndpointProtocol.swift
//  NewsApp
//
//  Created by Степан Усьянцев on 20.07.2020.
//  Copyright © 2020 Stepan Usiantsev. All rights reserved.
//

import Foundation

protocol EndpointProtocol {
    var baseURL: String { get }
    var fullURL: String { get }
    var params: [String : String] { get }
    var headers: [String : String] { get }
    var locale: String { get }
    var region: String { get }
}

extension EndpointProtocol {
    var locale: String {
        Locale.current.languageCode ?? "en"
    }
    
    var region: String {
        Locale.current.regionCode ?? "us"
    }
    var pageSize: String {
        return "\(Container.pageSize)"
    }
    
    var pageNumber: String {
        return ""
    }
}
