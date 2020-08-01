//
//  NewsData.swift
//  NewsApp
//
//  Created by Степан Усьянцев on 06.07.2020.
//  Copyright © 2020 Stepan Usiantsev. All rights reserved.
//

import Foundation
import UIKit

struct NewsData: Codable {
    let articles: [Articles]
}

struct Articles: Codable {
    let source: Source
    let title: String
    let urlToImage: String?
    let url: URL?
}

struct Source: Codable {
    let name: String
}
