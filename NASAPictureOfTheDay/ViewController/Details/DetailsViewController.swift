//
//  DetailsViewController.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

import CoreData
import SDWebImage
import UIKit

protocol DetailsViewDelegate {
  func didAction(_ action: DetailsViewDelegateActions)
}

enum DetailsViewDelegateActions {
  case backNavigation
}

class DetailsViewController: UIViewController {
  static var identifier = "details_view"
  @IBOutlet weak var headerImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var datePublishedLabel: UILabel!
  @IBOutlet weak var explanationLabel: UILabel!
  
  var persistentContainer: NSPersistentContainer?
  var delegate: DetailsViewDelegate?
  
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
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
        self?.updatePicturesaToCoreData()
        DispatchQueue.main.async {
          self?.removeSpinner()
          self?.setupView()
        }
        
      case .failure(let message):
        DispatchQueue.main.async {
          self?.removeSpinner()
          if self?.managedObjects != nil {
            self?.setupView()
          } else {
            // Show error screen like internet not working or not found error
            self?.showAlert(error: message)
          }
        }
      default:
        break
      }
    }
    viewModel?.fetchData()
  }
  
  func updatePicturesaToCoreData() {
    guard let persistentContainer = self.persistentContainer, let viewModel = viewModel, let results = viewModel.selectedDatePictureData, let date = results["date"] as? String else { return }
    
    let taskContext = persistentContainer.newBackgroundContext()
    taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    taskContext.undoManager = nil
    
    taskContext.performAndWait {
      
      let matchingPictureRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NasaPod")
      matchingPictureRequest.predicate = NSPredicate(format: "date = %@", date)
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingPictureRequest)
      batchDeleteRequest.resultType = .resultTypeObjectIDs
      
      
      do {
        let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
        
        if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
          NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                              into: [persistentContainer.viewContext])
        }
      } catch {
        print("Error: \(error)\ndelete operation failed")
        return
      }
      
      guard let picture = NSEntityDescription.insertNewObject(forEntityName: "NasaPod", into: taskContext) as? PictureDefinationManagedObject else {
        print("Error: failed to create object")
        return
      }
      
      do {
        try picture.update(with: results)
      } catch {
        print("Error: \(error)\nobject will be deleted")
        taskContext.delete(picture)
      }
      
      
      if taskContext.hasChanges {
        do {
          try taskContext.save()
        } catch {
          print("Error: \(error)\nnot able to save to coredata")
        }
        taskContext.reset()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
    let rightButton = UIBarButtonItem(title: "Make favorite", style: .plain, target: self, action: #selector(makeFavorite))
    self.navigationItem.rightBarButtonItem = rightButton
  }
  
  @objc func makeFavorite() {
    managedObjects?.isFavorite = true
    do {
      try persistentContainer?.viewContext.save()
    } catch {
      print("error in update record")
    }
  }
  
  var managedObjects: PictureDefinationManagedObject? {
    guard let persistentContainer = self.persistentContainer else { return nil }
    
    let context = persistentContainer.viewContext
    do {
      return try context.fetch(fetchRequest).first
    } catch {
        let nserror = error as NSError
        fatalError("error \(nserror), \(nserror.userInfo)")
    }
  }

  
  private func setupView() {
    guard let managedObjects = managedObjects else { return }
    titleLabel.font = UIFont(name: "Helvetica Bold", size: 24.0)
    
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
  
  func showAlert(error: String?) {
    
    let alert = UIAlertController(title: "Network Error", message: error, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in
      self.delegate?.didAction(.backNavigation)
    }))
    self.present(alert, animated: true)
    
  }

  
}

