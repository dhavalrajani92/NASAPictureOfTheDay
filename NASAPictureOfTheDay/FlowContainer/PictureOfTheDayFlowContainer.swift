//
//  PictureOfTheDayFlowContainer.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

import UIKit

final class PictureOfTheDayFlowContainer {
  unowned var navController: UINavigationController
  var flowViewModel: PictureOfTheDayFlowViewModel = PictureOfTheDayFlowViewModel()
  lazy var initialViewController: UIViewController? = {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let initialVc = mainStoryboard.instantiateInitialViewController() as? SelectDateViewController
    initialVc?.delegate = self
    return initialVc
  }()
  
  init(navController: UINavigationController) {
    self.navController = navController
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
    viewController.viewModel = viewModel
    self.navController.pushViewController(viewController, animated: true)
  }
  
  
  func didAction(_ action: SelectDateActions) {
    switch action {
    case .navigateToDetails(let date):
      navigateToDetails(selectedDate: date)
    }
  }
  
  
}
