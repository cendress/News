//
//  NewsTableViewCell.swift
//  News
//
//  Created by Christopher Endress on 11/20/23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
  
  let titleLabel = UILabel()
  let newsImageView = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
    layoutCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupCell() {
    titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    titleLabel.numberOfLines = 0
    newsImageView.contentMode = .scaleAspectFill
    newsImageView.clipsToBounds = true
  }
  
  private func layoutCell() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(newsImageView)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    newsImageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      newsImageView.heightAnchor.constraint(equalToConstant: 200)
    ])
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
    ])
  }
  
  func configure(with article: Article) {
    titleLabel.text = article.title
    loadImage(from: article.urlToImage)
  }
  
  func loadImage(from urlString: String?) {
    guard let urlString = urlString, let url = URL(string: urlString) else {
      newsImageView.image = nil
      return
    }
    
    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      if let data = data, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self?.newsImageView.image = image
        }
      } else {
        DispatchQueue.main.async {
          self?.newsImageView.image = nil
        }
      }
    }.resume()
  }
}


