//
//  PictureDefination.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 29/01/22.
//

import Foundation

struct PictureDefination: Decodable {
  var date: String
  var explanation: String
  var imageUrl: String
  var mediaType: String
  var title: String
  var url: String
  
  enum CodingKeys: String, CodingKey {
    case date = "date"
    case explanation = "explanation"
    case imageUrl = "hdurl"
    case mediaType = "media_type"
    case title =  "title"
    case url = "url"
  }
}
