//
//  NewsTableViewController.swift
//  News
//
//  Created by Christopher Endress on 9/18/23.
//

import UIKit

class NewsTableViewController: UITableViewController {

  private var articles = [Article]()
  private var newsManager = NewsManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
    
    setupTableView()
    setupRefreshControl()
    fetchNews()
    
    tableView.dataSource = self
    newsManager.delegate = self
  }
  
  private func setupTableView() {
    tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 140
    tableView.separatorStyle = .none
  }
  
  private func setupRefreshControl() {
    refreshControl?.addTarget(self, action: #selector(refreshNewsData(_:)), for: .valueChanged)
  }
  
  @objc private func refreshNewsData(_ sender: Any) {
    fetchNews()
  }
  
  private func fetchNews() {
    newsManager.fetchTopHeadlines()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else {
      fatalError("Unable to dequeue NewsTableViewCell")
    }
    let article = articles[indexPath.row]
    cell.configure(with: article)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let article = articles[indexPath.row]
    if let url = article.url {
      performSegue(withIdentifier: "goToArticle", sender: url)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToArticle", let articleURL = sender as? String {
      let destination = segue.destination as! ArticleWebViewController
      destination.articleURL = articleURL
    }
  }
}

extension NewsTableViewController: NewsManagerDelegate {
  
  func didFetchArticles(_ articles: [Article]) {
    DispatchQueue.main.async {
      self.articles = articles
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }
  
  func didFailWithError(_ error: Error) {
    DispatchQueue.main.async {
      print(error)
      self.refreshControl?.endRefreshing()
    }
  }
}



