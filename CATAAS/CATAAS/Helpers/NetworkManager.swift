import Alamofire
import Foundation
import WANetwork
import WACore

class NetworkManager {
    
    var networkSettings = NetworkClientSettings(
        id: "cat",
        baseURL: "https://cataas.com"
    )

    var cacheManager = CacheManager(
        storage: CacheStorage(default: CacheScope("default"),
                              with: .none),
        sessionInfo: SessionInfo()
    )
    
    class SessionInfo: SessionInfoHolder {
        var sessionId: Int? = 1
        var authSession: String? = "guest"
    }

    let catRoute = NetworkRoute(path: "/cat")
    
    func fetch() {
        let networkProvider = NetworkClientProvider(cacheManager: cacheManager).client(with: networkSettings)
        networkProvider.load(route: catRoute, policy: .server, completion: {
            response in
            print("\(response)")
        })
    }
    
    
    
    
    var settings: NetworkClientSettingsProtocol!
    private let urlGenerationError = "Could not generate url request object"
    
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



