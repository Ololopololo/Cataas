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
    func fetch() {
        let networkProvider = NetworkClientProvider(cacheManager: cacheManager)
        let networkClient = networkProvider.client(with: NetworkSettings.networkSettings)
        networkClient.load(route: catRoute, policy: .server, completion: {
            response in
            print("response.data")
        })
    }
    
    func fetchCatImage(completion: @escaping (Result<Data, Error>) -> Void) {
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



