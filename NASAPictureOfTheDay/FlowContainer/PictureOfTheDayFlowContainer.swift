//
//  PictureOfTheDayFlowContainer.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

import CoreData
import UIKit

final class PictureOfTheDayFlowContainer {
  unowned var navController: UINavigationController
  private let persistentContainer: NSPersistentContainer
  
  private let flowViewModel: PictureOfTheDayFlowViewModel
  
  lazy var initialViewController: UIViewController? = {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    guard let initialVc = mainStoryboard.instantiateInitialViewController() as? SelectDateViewController else { return nil }
    initialVc.delegate = self
    return initialVc
  }()
  
  init(flowViewModel: PictureOfTheDayFlowViewModel, navController: UINavigationController, persistentContainer: NSPersistentContainer) {
    self.navController = navController
    self.persistentContainer = persistentContainer
    self.flowViewModel = flowViewModel
    setupRootViewController()
  }
  
  private func setupRootViewController() {
    guard let vc = initialViewController else {
      return
    }
    self.navController.pushViewController(vc, animated: false)
  }
}

extension PictureOfTheDayFlowContainer: SelectDateDelegate {
  private func navigateToDetails(selectedDate: String) {
    let viewModel = flowViewModel.getDetailsViewModel(selectedDate: selectedDate)
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    guard let viewController = storyboard.instantiateViewController(identifier: DetailsViewController.identifier) as? DetailsViewController else {
      return
    }
    viewController.persistentContainer = persistentContainer
    viewController.viewModel = viewModel
    viewController.delegate = self
    self.navController.pushViewController(viewController, animated: true)
  }
  
  private func navigateToFavoriteListing() {
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    guard let viewController = storyboard.instantiateViewController(identifier: ManageFavoriteListingViewController.identifier) as? ManageFavoriteListingViewController else {
      return
    }
    viewController.persistentContainer = persistentContainer
    viewController.delegate = self
    self.navController.pushViewController(viewController, animated: true)
  }
  
  
  func didAction(_ action: SelectDateActions) {
    switch action {
    case .navigateToDetails(let date):
      navigateToDetails(selectedDate: date)
    case .navigateToFavoriteListing:
      navigateToFavoriteListing()
    }
  }
}

extension PictureOfTheDayFlowContainer: ManageFavoriteListingDelegate {
  func didAction(_ action: ManageFavoriteListingActions) {
    switch action {
    case .backNavigation:
      self.navController.popViewController(animated: true)
    default:
      break
    }
  }
}

extension PictureOfTheDayFlowContainer: DetailsViewDelegate {
  func didAction(_ action: DetailsViewDelegateActions) {
    self.navController.popViewController(animated: true)
  }
}
