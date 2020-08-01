//
//  NetworkNewsManager.swift
//  NewsApp
//
//  Created by Степан Усьянцев on 06.07.2020.
//  Copyright © 2020 Stepan Usiantsev. All rights reserved.
//

import Foundation

class NetworkNewsManager {
    
    private let decoder = JSONDecoder()
    private let session = URLSession(configuration: .default)
    
    private var pageNumber = 1
    private var isLoading = false
    private var shouldLoadNextPage = true
    private var articles: [Articles] = []
    
    var onCompletion: (([Articles]) -> Void)?
    var activateActivityIndicator: ((Bool) -> Void)?
    
    func fetchNews(isRefreshing: Bool = false) {
        if !isRefreshing && (isLoading || !shouldLoadNextPage) { return }
        if isRefreshing { self.pageNumber = 1 }
        
        guard let request = createRequest(for: NewsAPI.topHeadlines(pageNumber: pageNumber)) else { return }
        
        performRequest(with: request, for: NewsAPI.topHeadlines(pageNumber: pageNumber), isRefreshing: isRefreshing)
    }
}

private extension NetworkNewsManager {
    
    private func createRequest(for endpoint: EndpointProtocol) -> URLRequest? {
        guard var urlComponents = URLComponents(string: endpoint.fullURL) else {
            return nil
        }
        
        urlComponents.queryItems = endpoint.params.compactMap { param -> URLQueryItem in
            return URLQueryItem(name: param.key, value: param.value)
        }
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        
        var urlRequest = URLRequest(url: url)
        
        endpoint.headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        return urlRequest
    }
    
    private func performRequest(with request: URLRequest,for endpoint: EndpointProtocol, isRefreshing: Bool) {
        isLoading = true
        activateActivityIndicator?(true)
        // запрос данных
        let task = session.dataTask(with: request) { [weak self] data, _, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activateActivityIndicator?(false)
            }
            self.isLoading = false
            
            guard
                let data = data,
                let news = self.parseJSON(withData: data)
                else { return }
            
            self.pageNumber += 1
            self.articles = isRefreshing
                ? news.articles
                : self.articles + news.articles
            self.shouldLoadNextPage = news.articles.count == Container.pageSize
            
            DispatchQueue.main.async {
                self.onCompletion?(self.articles)
            }
        }
        //начало работы запроса
        task.resume()
    }
    
    private func parseJSON(withData data: Data) -> NewsData? {
        return try? decoder.decode(NewsData.self, from: data)
    }
}

