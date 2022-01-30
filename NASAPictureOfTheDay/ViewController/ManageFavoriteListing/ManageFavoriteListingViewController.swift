//
//  ManageFavoriteListingViewController.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 30/01/22.
//

import CoreData
import UIKit

protocol ManageFavoriteListingDelegate {
  func didAction(_ action: ManageFavoriteListingActions)
}

enum ManageFavoriteListingActions {
  case backNavigation
}

final class ManageFavoriteListingViewController: UIViewController {
  static var identifier = "manage_favorite"
  @IBOutlet weak var collectionView: UICollectionView!
  
  
  var delegate: ManageFavoriteListingDelegate?
  var persistentContainer: NSPersistentContainer?
  var fetchedPictures = [PictureDefinationManagedObject]()
  var itemCount: Int = 0
  
  lazy var fetchedResultsController: NSFetchedResultsController<PictureDefinationManagedObject> = {
    let fetchRequest = NSFetchRequest<PictureDefinationManagedObject>(entityName: "NasaPod")
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchRequest.predicate = NSPredicate(format: "isFavorite = true")
    
    let fetchedResultsController = NSFetchedResultsController<PictureDefinationManagedObject>(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer!.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    fetchData()
    registerNib()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  private func setupView() {
    collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .black
  }
  
  private func fetchData() {
    do {
      try fetchedResultsController.performFetch()
      self.fetchedPictures = fetchedResultsController.fetchedObjects!
      self.itemCount = fetchedPictures.count
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  private func registerNib() {
    collectionView.register(PictureCell.self, forCellWithReuseIdentifier: PictureCell.identifier)
  }
}

extension ManageFavoriteListingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return itemCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let imageUrl = fetchedPictures[indexPath.row].imageUrl
    let title = fetchedPictures[indexPath.row].title
    let date = fetchedPictures[indexPath.row].date
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCell.identifier, for: indexPath) as? PictureCell else {
      return UICollectionViewCell()
    }
    
    cell.render(imageUrl: imageUrl, title: title, date: date)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let persistentContainer = persistentContainer else { return }
    fetchedPictures[indexPath.row].isFavorite = false
    let context = persistentContainer.viewContext
    do {
      try context.save()
      delegate?.didAction(.backNavigation)
    } catch let error {
      print("Not able to update", error)
    }
  }
}

extension ManageFavoriteListingViewController : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    let totalSpace = flowLayout.sectionInset.left
      + flowLayout.sectionInset.right
    let size = Int((collectionView.bounds.width - totalSpace))
    return CGSize(width: size, height: size)
  }
}
