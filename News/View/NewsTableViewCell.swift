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
  let subtitleLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
    layoutCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupCell() {
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel.numberOfLines = 0
    
    subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    subtitleLabel.numberOfLines = 0
    subtitleLabel.textColor = .darkGray
    
    newsImageView.contentMode = .scaleAspectFill
    newsImageView.clipsToBounds = true
    newsImageView.layer.cornerRadius = 8
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(subtitleLabel)
    contentView.addSubview(newsImageView)
    
    accessoryType = .disclosureIndicator 
  }
  
  private func layoutCell() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    newsImageView.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let padding: CGFloat = 10
    
    NSLayoutConstraint.activate([
      newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
      newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      newsImageView.heightAnchor.constraint(equalToConstant: 200),
      
      titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
      subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
    ])
  }
  
  func configure(with article: Article, newsData: NewsData) {
    titleLabel.text = article.title
    subtitleLabel.text = newsData.name
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



