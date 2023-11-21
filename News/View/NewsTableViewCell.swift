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
  let dateLabel = UILabel()
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
    
    sourceLabel.font = UIFont.preferredFont(forTextStyle: .title1)
    sourceLabel.textColor = .systemBlue
    sourceLabel.numberOfLines = 1
    
    dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    dateLabel.textColor = .systemGray
    dateLabel.numberOfLines = 1
    
    newsImageView.contentMode = .scaleAspectFill
    newsImageView.clipsToBounds = true
    newsImageView.layer.cornerRadius = 8
    newsImageView.layer.masksToBounds = true
    newsImageView.backgroundColor = .lightGray
    
    activityIndicator.hidesWhenStopped = true
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(sourceLabel)
    contentView.addSubview(dateLabel)
    contentView.addSubview(newsImageView)
    newsImageView.addSubview(activityIndicator)
  }
  
  private func layoutCell() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    sourceLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
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
      
      dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
      dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      
      activityIndicator.centerXAnchor.constraint(equalTo: newsImageView.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: newsImageView.centerYAnchor)
    ])
  }
  
  func configure(with article: Article) {
    titleLabel.text = article.title
    let blueDot = "● "
    sourceLabel.attributedText = NSAttributedString(string: blueDot + article.source.name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
    dateLabel.text = formatDateString(article.publishedAt)
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
  
  private func formatDateString(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateStyle = .medium
    outputFormatter.timeStyle = .short
    
    if let date = inputFormatter.date(from: dateString) {
      return outputFormatter.string(from: date)
    } else {
      return "Date unavailable"
    }
  }
}




