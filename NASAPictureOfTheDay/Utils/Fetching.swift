//
//  Fetching.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

protocol Fetching {
  var fetchState: FetchState { get set }
  var fetchCallback: ((FetchState)->Void)? { get set }
}

enum FetchState {
  case inProgress
  case success
  case failure(String?)
  case none
}

extension Fetching {
  func notifyObserver() {
    fetchCallback?(fetchState)
  }
}
