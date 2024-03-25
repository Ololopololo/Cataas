import Alamofire
import Foundation
import RealmSwift

class CatHistoryViewModel {
    
    var catImages: Results<CatImageModel>?
    
    var onDataUpdated: (() -> Void)?
    
    func loadImagesFromRealm() {
        let realm = try! Realm()
        catImages = realm.objects(CatImageModel.self).sorted(byKeyPath: "timeStamp", ascending: true)
    }
    
    func fetchCatImage(completion: @escaping (Bool, Error?) -> Void) {
        AF.request("https://cataas.com/cat", method: .get).responseData { response in
            switch response.result {
            case .success(let data):
                let catImage = CatImageModel()
                catImage.id = UUID().uuidString
                catImage.imageData = data
                catImage.timeStamp = Date()
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(catImage)
                    }
                    completion(true, nil)
                } catch let error {
                    completion(false, error)
                }
            case .failure(let error):
                completion(false, error)
            }
        }
    }
}



