import Alamofire
import WANetwork
import Foundation
import RealmSwift

class CatHistoryViewModel {
    
    var catImages: Results<CatImageModel>?
    private let networkManager = NetworkManager()
    
    func loadImagesFromRealm() {
        let realm = try! Realm()
        catImages = realm.objects(CatImageModel.self).sorted(byKeyPath: "timeStamp", ascending: true)
    }
    
    func fetchCatImageAlamoFire(completion: @escaping (Bool, Error?) -> Void) {
        networkManager.fetchCatImageAlamoFire { result in
            print("\(result)")
            switch result {
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
    
    func fetchCatImageWANetwork(completion: @escaping (Bool, Error?) -> Void) {
        networkManager.fetchCatImageWANetwork { result in
            switch result {
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



