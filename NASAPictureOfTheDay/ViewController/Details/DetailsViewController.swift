//
//  DetailsViewController.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

import CoreData
import SDWebImage
import UIKit

class DetailsViewController: UIViewController {
  static var identifier = "details_view"
  @IBOutlet weak var headerImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var datePublishedLabel: UILabel!
  @IBOutlet weak var explanationLabel: UILabel!
  
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
  
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  private lazy var fetchRequest: NSFetchRequest<PictureDefinationManagedObject> = {
    let fetchRequest = NSFetchRequest<PictureDefinationManagedObject>(entityName: "NasaPod")
    fetchRequest.fetchLimit = 1
    fetchRequest.predicate = NSPredicate(format: "date = %@", viewModel?.selectedDate ?? "")
    
    return fetchRequest
  }()
  
  var viewModel: DetailsViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel?.fetchCallback = { [weak self] fetchState in
      switch fetchState {
      case .inProgress:
        self?.showSpinner()
      case .success:
        DispatchQueue.main.async {
          self?.picturesFromResults()
          self?.removeSpinner()
          self?.setupView()
        }
        
      case .failure(_):
        DispatchQueue.main.async {
          self?.removeSpinner()
          if self?.managedObjects != nil {
            self?.setupView()
          } else {
            // Show error screen like internet not working or not found error
          }
        }
      default:
        break
      }
    }
    viewModel?.fetchData()
  }
  
  func picturesFromResults() {
    
    guard let viewModel = viewModel, let results = viewModel.selectedDatePictureData, let picture = NSEntityDescription.insertNewObject(forEntityName: "NasaPod", into: context) as? PictureDefinationManagedObject else {
        print("Error: Failed to create a new Picture object!")
        return
    }
    try? picture.update(with: results)
    try? self.context.save()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  var managedObjects: PictureDefinationManagedObject? {
    do {
      return try context.fetch(fetchRequest).first
    } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }

  
  private func setupView() {
    guard let managedObjects = managedObjects else { return }
    
    headerImageView.sd_setIndicatorStyle(.medium)
    headerImageView.sd_addActivityIndicator()
    headerImageView.sd_imageTransition = .fade
    headerImageView.sd_setImage(with: URL(string: managedObjects.imageUrl), completed: {(image, error, cache, url) in
      self.headerImageView.image = image
      
    })
    DispatchQueue.main.async {
      self.headerImageView.contentMode = .scaleAspectFill
      self.headerImageView.clipsToBounds = true
      self.titleLabel.text = self.managedObjects?.title
      self.datePublishedLabel.text = self.managedObjects?.date
      self.explanationLabel.text = self.managedObjects?.explanation
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

