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
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel.numberOfLines = 0
    
    newsImageView.contentMode = .scaleAspectFill
    newsImageView.clipsToBounds = true
    newsImageView.layer.cornerRadius = 8
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(newsImageView)
  }
  
  private func layoutCell() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    newsImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let padding: CGFloat = 10
    
    NSLayoutConstraint.activate([
      newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
      newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      newsImageView.heightAnchor.constraint(equalToConstant: 200),
      
      titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
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



