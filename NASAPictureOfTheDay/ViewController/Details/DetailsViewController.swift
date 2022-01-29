//
//  DetailsViewController.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
  static var identifier = "details_view"
  @IBOutlet weak var headerImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var datePublishedLabel: UILabel!
  @IBOutlet weak var explanationLabel: UILabel!
  
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
  
  var viewModel: DetailsViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel?.fetchCallback = { [weak self] fetchState in
      switch fetchState {
      case .inProgress:
        self?.showSpinner()
      case .success:
        DispatchQueue.main.async {
          self?.removeSpinner()
        }
        self?.setupView()
      case .failure(let message):
        DispatchQueue.main.async {
          self?.removeSpinner()
        }
      default:
        break
      }
    }
    viewModel?.fetchData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
  }

  
  private func setupView() {
    guard let viewModel = viewModel else { return }
    
    headerImageView.sd_setIndicatorStyle(.medium)
    headerImageView.sd_addActivityIndicator()
    headerImageView.sd_imageTransition = .fade
    headerImageView.sd_setImage(with: URL(string: viewModel.headerImage), completed: {(image, error, cache, url) in
      self.headerImageView.image = image
      
    })
    DispatchQueue.main.async {
      self.headerImageView.contentMode = .scaleAspectFill
      self.headerImageView.clipsToBounds = true
      self.titleLabel.text = viewModel.title
      self.datePublishedLabel.text = viewModel.publishedDate
      self.explanationLabel.text = viewModel.explanation
    }
  }
  
  private func showSpinner() {
    self.view.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    activityIndicator.center = self.view.center
  }
  
  private func removeSpinner() {
    activityIndicator.stopAnimating()
    activityIndicator.removeFromSuperview()
  }
  
}

