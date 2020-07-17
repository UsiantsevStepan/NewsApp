//
//  NetworkNewsManager.swift
//  NewsApp
//
//  Created by Степан Усьянцев on 06.07.2020.
//  Copyright © 2020 Stepan Usiantsev. All rights reserved.
//

import Foundation

class NetworkNewsManager {
    
    var onCompletion: ((NewsData) -> Void)?
    var pageNumber = 1
       
       func fetchNews() {
           let urlString = "https://newsapi.org/v2/top-headlines?country=us&page=\(pageNumber)&pageSize=10&apiKey=0fa2296c3e0c4b03bcffabfc169fa429"
           performRequest(withURLString: urlString)
        pageNumber += 1
       }

       
       fileprivate func performRequest(withURLString urlString: String) {
           // создание юрл
           guard let url = URL(string: urlString) else { return }
           // создание юрл сессии
           let session = URLSession(configuration: .default)
           // запрос данных
           let task = session.dataTask(with: url) { (data, response, error) in
               if let data = data {
                   if let news = self.parseJSON(withData: data) {
//                    DispatchQueue.main.async {
                        self.onCompletion?(news)
//                    }
                   }
            }
           }
           //начало работы запроса
           task.resume()
       }
       
       fileprivate func parseJSON(withData data: Data) -> NewsData? {
           let decoder = JSONDecoder()
           do {
               let newsData = try decoder.decode(NewsData.self, from: data)
               return newsData
           } catch let error as NSError {
               print(error)
           }
           return nil
       }
    
}
