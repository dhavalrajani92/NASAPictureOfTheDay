//
//  PictureOfTheDayFlowViewModel.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

final class PictureOfTheDayFlowViewModel {
  init() {}
}

extension PictureOfTheDayFlowViewModel {
  func getDetailsViewModel(selectedDate: String) -> DetailsViewModel {
    return DetailsViewModel(selectedDate: selectedDate, getPictureOperation: OperationFactory.getSelectedDatePictureDetailsOperation(selectedDate: selectedDate))
  }
}
