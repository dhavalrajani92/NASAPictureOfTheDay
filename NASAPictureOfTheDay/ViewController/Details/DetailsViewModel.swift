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
  private let operation: NetworkOperation
  var selectedDatePictureData: [String: Any]? = nil
  
  init(selectedDate: String, getPictureOperation: NetworkOperation) {
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
      case .failure(let error):
        guard let error = error as? Failure else {
          return
        }
        self.fetchState = .failure(error.message)
      case .none:
        break
      }
    })
  }
}
