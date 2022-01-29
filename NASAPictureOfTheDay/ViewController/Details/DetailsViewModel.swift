//
//  DetailsViewModel.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

final class DetailsViewModel: Fetching {
  var fetchState: FetchState = .none {
    didSet {
      notifyObserver()
    }
  }
  
  var fetchCallback: ((FetchState) -> Void)?
  
  private let selectedDate: String
  private let operation: NetworkOperation<PictureDefination>
  private var selectedDatePictureData: PictureDefination? = nil
  
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
        print(message)
        break
      case .none:
        break
      }
    })
  }
  
  var headerImage: String {
    return selectedDatePictureData?.imageUrl ?? ""
  }
  
  var title: String? {
    return selectedDatePictureData?.title
  }
  
  var publishedDate: String? {
    return selectedDatePictureData?.date
  }
  
  var explanation: String? {
    return selectedDatePictureData?.explanation
  }
}
