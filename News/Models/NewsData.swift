//
//  NewsData.swift
//  News
//
//  Created by Christopher Endress on 9/18/23.
//

import Foundation

struct NewsData: Codable {
  let articles: [Article]
}

struct Article: Codable {
  let title: String
  let url: String?
}
