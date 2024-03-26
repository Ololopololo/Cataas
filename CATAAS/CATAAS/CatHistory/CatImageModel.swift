import Foundation
import RealmSwift

class CatImageModel: Object {
    @Persisted (primaryKey: true) var id: String
    @Persisted var imageData: Data
    @Persisted var timeStamp: Date
}
