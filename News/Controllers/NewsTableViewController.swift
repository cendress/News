//
//  NewsTableViewController.swift
//  News
//
//  Created by Christopher Endress on 9/18/23.
//

import UIKit

class NewsTableViewController: UITableViewController {
  
  // MARK: - Properties
  
  private var articles = [Article]()
  private var newsManager = NewsManager()
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    newsManager.delegate = self
    newsManager.fetchTopHeadlines()
    setupTableView()
  }
  
  // MARK: - Helper Methods
  
  private func setupTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
  }
  
  // MARK: - UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
    let article = articles[indexPath.row]
    cell.textLabel?.text = article.title
    cell.textLabel?.numberOfLines = 0
    cell.textLabel?.lineBreakMode = .byWordWrapping
    cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    cell.clipsToBounds = true
    
    cell.accessoryType = .disclosureIndicator
    
    return cell
  }
  
  
  // MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let article = articles[indexPath.row]
    if let url = article.url {
      performSegue(withIdentifier: "goToArticle", sender: url)
    }
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToArticle", let articleURL = sender as? String {
      let destination = segue.destination as! ArticleWebViewController
      destination.articleURL = articleURL
    }
  }
}

// MARK: - NewsManagerDelegate

extension NewsTableViewController: NewsManagerDelegate {
  
  func didFetchArticles(_ articles: [Article]) {
    DispatchQueue.main.async { [weak self] in
      self?.articles = articles
      self?.tableView.reloadData()
    }
  }
  
  func didFailWithError(_ error: Error) {
    print(error)
  }
}

