//
//  ArticleWebViewController.swift
//  News
//
//  Created by Christopher Endress on 9/18/23.
//

import UIKit
import WebKit

class ArticleWebViewController: UIViewController {
  
  // MARK: - Properties
  
  var articleURL: String?
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var webView: WKWebView!
  
  // MARK: - View Controller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.tintColor = .systemGray
    
    loadWebView()
  }
  
  // MARK: - Private Methods
  
  private func loadWebView() {
    guard let urlString = articleURL, let url = URL(string: urlString) else {
      return
    }
    
    let request = URLRequest(url: url)
    webView.load(request)
  }
}
