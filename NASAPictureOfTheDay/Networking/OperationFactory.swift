//
//  OperationFactory.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

final class OperationFactory {
  static func getSelectedDatePictureDetailsOperation(selectedDate: String) -> NetworkOperation<PictureDefination> {
    let path = "https://api.nasa.gov/planetary/apod?api_key=NKWb2BPiZkE1zHjAoKjlgKemwjSMnGvdD3WS9ZSE&date="+selectedDate
    return NetworkOperation(requestMethod: .GET, path: path, resultType: PictureDefination.self)
  }
}

