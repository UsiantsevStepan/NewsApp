//
//  ViewController.swift
//  NewsApp
//
//  Created by Степан Усьянцев on 06.07.2020.
//  Copyright © 2020 Stepan Usiantsev. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var networkNewsManager = NetworkNewsManager()
    private var news = [Articles]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //    private var shouldActivateActivityIndicator = false
    
    private let pageActivityIndicator = UIActivityIndicatorView(style: .gray)
    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        networkNewsManager.onCompletion = { [weak self] articles in
            self?.news = articles
            self?.refreshControl.endRefreshing()
            //                self?.pageActivityIndicator.stopAnimating()
        }
        
        networkNewsManager.activateActivityIndicator = { [weak self] shouldActivateActivityIndicator in
            if shouldActivateActivityIndicator {
                self?.tableView.tableFooterView = self?.pageActivityIndicator
                self?.pageActivityIndicator.startAnimating()
            } else {
                self?.pageActivityIndicator.stopAnimating()
                self?.tableView.tableFooterView = nil
            }
            //            self?.shouldActivateActivityIndicator = shouldActivateActivityIndicator
        }
        
        self.tableView.tableFooterView = nil
        pageActivityIndicator.hidesWhenStopped = true
        networkNewsManager.fetchNews()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        networkNewsManager.fetchNews(isRefreshing: true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newsUrl = news[indexPath.row].url else { return }
        let vc = SFSafariViewController(url: newsUrl)
        vc.delegate = self
        
        present(vc, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > 0,
            offsetY > contentHeight - scrollView.frame.height + 200 {
            networkNewsManager.fetchNews()
        }
    }
}
