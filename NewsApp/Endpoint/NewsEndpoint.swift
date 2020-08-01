//
//  NewsEndpoint.swift
//  NewsApp
//
//  Created by Степан Усьянцев on 20.07.2020.
//  Copyright © 2020 Stepan Usiantsev. All rights reserved.
//

import Foundation

public enum NewsAPI {
    case topHeadlines (
        pageNumber: Int
    )
    case everything (
        pageNumber: Int
    )
}

extension NewsAPI: EndpointProtocol {
    var baseURL: String {
        return "https://newsapi.org/v2"
    }
    
    var fullURL: String {
        switch self {
        case .topHeadlines:
            return baseURL + "/top-headlines"
        case .everything:
            return baseURL + "/everything"
        }
    }
    
    var params: [String : String] {
        switch self {
        case let .topHeadlines(pageNumber):
            return ["country": region,"pageSize": pageSize, "page": "\(pageNumber)"]
        case let .everything(pageNumber):
            return ["pageSize": pageSize, "language": locale, "page": "\(pageNumber)"]
        }
    }
    
    var headers: [String : String] {
        return [
            "X-Api-Key": Container.newsAPIKey,
            "Content-type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    
}
