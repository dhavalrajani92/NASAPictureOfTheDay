//
//  OperationFactory.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

final class OperationFactory {
  static func getSelectedDatePictureDetailsOperation(selectedDate: String) -> NetworkOperation {
    return NetworkOperation(path: "/planetary/apod", parameters: [URLKeys.date: selectedDate])
  }
}

