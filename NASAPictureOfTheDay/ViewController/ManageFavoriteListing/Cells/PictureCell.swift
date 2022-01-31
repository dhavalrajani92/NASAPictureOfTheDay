//
//  PictureCell.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 30/01/22.
//

import UIKit

final class PictureCell: UICollectionViewCell {
  static var identifier = "PictureCell"
  
  private lazy var headerImageView: UIImageView  = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont(name: "Helvetica Bold", size: 24.0)
    label.textColor = .white
    return label
  }()
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.font = UIFont(name: "Helvetica Bold", size: 16.0)
    label.textColor = .white
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    self.contentView.addSubview(headerImageView)
    self.contentView.addSubview(titleLabel)
    self.contentView.addSubview(dateLabel)
    
    
    
    NSLayoutConstraint.activate([
      headerImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      headerImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      headerImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      headerImageView.heightAnchor.constraint(equalToConstant: 400),
      
      titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
      
      dateLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
      dateLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
      dateLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
      dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -25),
    ])
  }
  
  func render(imageUrl: String, title: String, date: String) {
    headerImageView.sd_setIndicatorStyle(.white)
    headerImageView.sd_addActivityIndicator()
    headerImageView.sd_imageTransition = .fade
    headerImageView.sd_setImage(with: URL(string: imageUrl)!, completed: {(image, error, cache, url) in
      self.headerImageView.image = image
      
    })
    titleLabel.text = title
    dateLabel.text = date
  }
}

