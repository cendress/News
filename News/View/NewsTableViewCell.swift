//
//  NewsTableViewCell.swift
//  News
//
//  Created by Christopher Endress on 11/20/23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
  
  let titleLabel = UILabel()
  let sourceLabel = UILabel()
  let newsImageView = UIImageView()
  let activityIndicator = UIActivityIndicatorView(style: .medium)
  
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
    
    sourceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    sourceLabel.textColor = .systemCyan
    sourceLabel.numberOfLines = 1
    
    newsImageView.contentMode = .scaleAspectFill
    newsImageView.clipsToBounds = true
    newsImageView.layer.cornerRadius = 8
    newsImageView.layer.masksToBounds = true
    newsImageView.backgroundColor = .lightGray
    
    activityIndicator.hidesWhenStopped = true
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(sourceLabel)
    contentView.addSubview(newsImageView)
    newsImageView.addSubview(activityIndicator)
  }
  
  private func layoutCell() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    sourceLabel.translatesAutoresizingMaskIntoConstraints = false
    newsImageView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      newsImageView.heightAnchor.constraint(equalToConstant: 200),
      
      sourceLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 10),
      sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      sourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      
      titleLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 5),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      
      activityIndicator.centerXAnchor.constraint(equalTo: newsImageView.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: newsImageView.centerYAnchor)
    ])
  }
  
  func configure(with article: Article) {
    titleLabel.text = article.title
    let blueDot = "● "
    sourceLabel.attributedText = NSAttributedString(string: blueDot + (article.source.name), attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemCyan])
    
    loadImage(from: article.urlToImage)
  }
  
  func loadImage(from urlString: String?) {
    guard let urlString = urlString, let url = URL(string: urlString) else {
      newsImageView.image = nil
      return
    }
    
    activityIndicator.startAnimating()
    
    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      DispatchQueue.main.async {
        self?.activityIndicator.stopAnimating()
      }
      
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




