//
//  PictureDefinationManagedObject.swift
//  NASAPictureOfTheDay
//
//  Created by Dhaval Rajani on 30/01/22.
//

import CoreData

class PictureDefinationManagedObject: NSManagedObject {
  @NSManaged var date: String
  @NSManaged var explanation: String
  @NSManaged var imageUrl: String
  @NSManaged var mediaType: String
  @NSManaged var title: String
  @NSManaged var url: String
  @NSManaged var isFavorite: Bool
  
  func update(with jsonDictionary: [String: Any]) throws {
    guard let date = jsonDictionary["date"] as? String,
          let explanation = jsonDictionary["explanation"] as? String,
          let imageUrl = jsonDictionary["hdurl"] as? String,
          let mediaType = jsonDictionary["media_type"] as? String,
          let title = jsonDictionary["title"] as? String,
          let url = jsonDictionary["url"] as? String
    else {
      throw NSError(domain: "", code: 100, userInfo: nil)
    }
    
    self.date = date
    self.explanation = explanation
    self.imageUrl = imageUrl
    self.mediaType = mediaType
    self.title = title
    self.url = url
  }
}
