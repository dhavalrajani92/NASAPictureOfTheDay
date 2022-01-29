//
//  NetworkOperatiom.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

import Foundation

enum RequestMethod {
  case GET
  case POST
}

enum OperationResult<T> {
  case success(object: T)
  case failure(message: String?)
}

final class NetworkOperation<T: Decodable> {
  private let requestMethod: RequestMethod
  private let path: String
  private let resultType: T.Type
  
  private var requestUrl: URL {
    return URL(string: path)!
  }
  
  init(requestMethod: RequestMethod, path: String, resultType: T.Type) {
    self.requestMethod = requestMethod
    self.path = path
    self.resultType = resultType
  }
  
  func execute(completionHandler: @escaping (_ result: OperationResult<T>?) -> Void) {
    URLSession.shared.dataTask(with: requestUrl) { (responseData, response, error) in
      if error == nil && responseData != nil && responseData?.count != 0 {
        do {
          let result = try JSONDecoder().decode(T.self, from: responseData!)
          completionHandler(.success(object: result))
        } catch let error {
          completionHandler(.failure(message: error.localizedDescription))
        }
      } else {
        completionHandler(.failure(message: error?.localizedDescription))
      }
    }.resume()
  }
  
}
