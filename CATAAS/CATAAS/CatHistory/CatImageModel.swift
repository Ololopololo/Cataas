//
//  CatImageModel.swift
//  CATAAS
//
//  Created by Владислав Положай on 25.03.2024.
//

import Foundation
import RealmSwift

class CatImageModel: Object {
    @Persisted (primaryKey: true) var id: String
    @Persisted var imageData: Data
    @Persisted var timeStamp: Date
}
