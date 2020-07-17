//
//  ViewController.swift
//  NewsApp
//
//  Created by Степан Усьянцев on 06.07.2020.
//  Copyright © 2020 Stepan Usiantsev. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewCell = TableViewCell()
    var networkNewsManager = NetworkNewsManager()
    var news = [Articles]()
    var fetchingMore = false
    var isLoading = false
    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkNewsManager.onCompletion = { [weak self] news in
            DispatchQueue.main.async {
                self?.news += news.articles
                self?.fetchingMore = news.articles.count  >= 10
                self?.isLoading = false
                OperationQueue.main.addOperation {
                    self?.refreshControl.endRefreshing()
                    self?.tableView.reloadData()
                }
            }
        }
        self.tableView.refreshControl = self.refreshControl
        isLoading = true
        networkNewsManager.fetchNews()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        news = []
//        tableView.reloadData()
        networkNewsManager.pageNumber = 1
        isLoading = true
        networkNewsManager.fetchNews()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        var newsTitleString = news[indexPath.row].title
        cell.sourceNameLabel?.text = news[indexPath.row].source.name
        if let dashRange = newsTitleString.range(of: " -") {
            newsTitleString.removeSubrange(dashRange.lowerBound..<newsTitleString.endIndex)
        }
        cell.newsTitleLabel?.text = newsTitleString
        cell.newsImage?.kf.indicatorType = .activity
        cell.newsImage?.kf.setImage(with: URL(string: news[indexPath.row].urlToImage ?? ""),
                                    placeholder: #imageLiteral(resourceName: "placeholder"))
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cellHeight = UITableView.automaticDimension
//
//        return cellHeight
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > 0 && offsetY > contentHeight - scrollView.frame.height {
            if fetchingMore {
                if isLoading { return }
                isLoading = true
                networkNewsManager.fetchNews()
            }
            }
        }
}

