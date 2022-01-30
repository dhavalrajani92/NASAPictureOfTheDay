//
//  NetworkOperatiom.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

import Foundation

struct Failure: Error {
  var message: String?
}

final class NetworkOperation {
  private let path: String
  private var parameters: [String: String]
  
  private lazy var requestUrl: URL = {
    return constructURL(path: self.path, parameters: self.parameters)
  }()
  
  init(path: String, parameters: [String: String]) {
    self.path = path
    self.parameters = parameters
  }
  
  func execute(completionHandler: @escaping (_ result: Result<[String: Any]?, Error>?) -> Void) {
    parameters.updateValue(URLValues.NASAAPIKey, forKey: URLKeys.APIKey)
    URLSession.shared.dataTask(with: requestUrl) { (responseData, response, error) in
      
      guard (error == nil) else {
        completionHandler(.failure(Failure(message: error?.localizedDescription)))
        return
      }
      
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
        let code: String = String((response as? HTTPURLResponse)?.statusCode ?? 0)
        completionHandler(.failure(Failure(message: "Something went wrong!!! We have received \(code)")))
        return
      }
      
      guard let data = responseData, data.count != 0 else {
        completionHandler(.failure(Failure(message: error?.localizedDescription)))
        return
      }
      
      do {
        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        completionHandler(.success(result as? [String: Any]))
      } catch let error {
        completionHandler(.failure(Failure(message: error.localizedDescription)))
      }
    }.resume()
  }
  
  private func constructURL(path: String, parameters: [String: String]?) -> URL {
    var components = URLComponents()
    components.scheme = Constants.ApiScheme
    components.host = Constants.ApiHost
    components.path = path
    guard let parameters = parameters else { return components.url! }
    var queryItems: [URLQueryItem] = [URLQueryItem]()
    for (key,value) in parameters {
      queryItems.append(URLQueryItem(name: key, value: value))
    }
    components.queryItems = queryItems
    return components.url!
  }
  
}

struct Constants {
  static let ApiScheme = "https"
  static let ApiHost = "api.nasa.gov"
}

struct URLKeys {
  static let APIKey = "api_key"
  static let date = "date"
}

struct URLValues {
  static let NASAAPIKey = "NKWb2BPiZkE1zHjAoKjlgKemwjSMnGvdD3WS9ZSE"
}
