import Alamofire
import Foundation
import WANetwork
import WACore

class SessionInfo: SessionInfoHolder {
    var sessionId: Int? = 1
    var authSession: String? = "guest"
}

enum NetworkSettings {
    static let networkSettings = NetworkClientSettings(
        id: "cat",
        baseURL: "https://cataas.com"
    )
}

class NetworkManager {
    
    let cacheManager = CacheManager(
        storage: CacheStorage(default: CacheScope("default"), with: nil),
        sessionInfo: SessionInfo()
    )
    
    let catRoute = NetworkRoute(path: "/cat")
//    func fetch() {
//        let networkProvider = NetworkClientProvider(cacheManager: cacheManager)
//        let networkClient = networkProvider.client(with: NetworkSettings.networkSettings)
//        networkClient.load(route: catRoute, policy: .server, completion: { response in
//            print(response.data ?? "Nil")
//        })
//    }
    
    func fetchCatImageWANetwork(completion: @escaping (Result<Data, Error>) -> Void) {
        let networkProvider = NetworkClientProvider(cacheManager: cacheManager)
        let networkClient = networkProvider.client(with: NetworkSettings.networkSettings)
        networkClient.load(route: catRoute, policy: .server, completion: { response in
            if let data = response.data {
                completion(.success(data))
            } else if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.failure(NSError(domain: "UnknownError", code: -1, userInfo: nil)))
            }
        })
    }

    func fetchCatImageAlamoFire(completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request("https://cataas.com/cat", method: .get).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error as Error))
            }
        }
    }
}



