//
//  NewsManager.swift
//  News
//
//  Created by Christopher Endress on 9/18/23.
//

import Foundation

protocol NewsManagerDelegate: AnyObject {
  func didFetchArticles(_ articles: [Article])
  func didFailWithError(_ error: Error)
}

class NewsManager {
  
  private let apiKey = Keys.newsApiKey
  private let baseURL = "https://newsapi.org/v2/"
  
  weak var delegate: NewsManagerDelegate?
  
  func fetchTopHeadlines() {
    let urlString = "\(baseURL)top-headlines?country=us&apiKey=\(apiKey)"
    performRequest(with: urlString)
  }
  
  private func performRequest(with urlString: String) {
    guard let url = URL(string: urlString) else {
      return
    }
    
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { [weak self] data, response, error in
      if let error = error {
        self?.delegate?.didFailWithError(error)
        return
      }
      
      if let safeData = data {
        let decoder = JSONDecoder()
        do {
          let decodedData = try decoder.decode(NewsData.self, from: safeData)
          self?.delegate?.didFetchArticles(decodedData.articles)
        } catch {
          self?.delegate?.didFailWithError(error)
        }
      }
    }
    task.resume()
  }
}
