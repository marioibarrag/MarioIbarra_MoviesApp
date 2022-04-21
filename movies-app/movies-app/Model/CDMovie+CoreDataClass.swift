//
//  CDMovie+CoreDataClass.swift
//  movies-app
//
//  Created by Consultant on 4/19/22.
//
//

import Foundation
import CoreData

class Movie: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
      }

    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
    }
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
