//
//  DetailsViewModel.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

import CoreData
import Foundation
import UIKit

final class DetailsViewModel: Fetching {
  var fetchState: FetchState = .none {
    didSet {
      notifyObserver()
    }
  }
  
  var fetchCallback: ((FetchState) -> Void)?
  
  let selectedDate: String
  private let operation: NetworkOperation<PictureDefination>
  var selectedDatePictureData: [String: Any]? = nil
  
  init(selectedDate: String, getPictureOperation: NetworkOperation<PictureDefination>) {
    self.selectedDate = selectedDate
    self.operation = getPictureOperation
  }
}

extension DetailsViewModel {
  func fetchData() {
    fetchState = .inProgress
    operation.execute(completionHandler: { result in
      switch result {
      case .success(let data):
        self.selectedDatePictureData = data
        self.fetchState = .success
      case .failure(let message):
        self.fetchState = .failure(message)
        // Show error screen or alert
        break
      case .none:
        break
      }
    })
  }
  
//  var headerImage: String {
//    return selectedDatePictureData?.imageUrl ?? ""
//  }
//
//  var title: String? {
//    return selectedDatePictureData?.title
//  }
//
//  var publishedDate: String? {
//    return selectedDatePictureData?.date
//  }
//
//  var explanation: String? {
//    return selectedDatePictureData?.explanation
//  }
}
