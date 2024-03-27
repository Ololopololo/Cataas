import Alamofire
import Foundation
import WANetwork
import WACore

class SessionInfoTest: SessionInfoHolder {
    var sessionId: Int? = 1
    var authSession: String? = "guest"
}

enum NetworkSettingsTest {
    static let networkSettings = NetworkClientSettings(
        id: "httpbin",
        baseURL: "https://httpbin.org/",
        reachabilityHost: "https://httpbin.org/"
    )
}

enum TestData {
    /// String that will returned from our cache
    static let testCacheString = "{\"cache_response\":\"response_already_in_cache\"}"
    static let testCacheUpdateString = "{\"cache_response\":\"cache_updated\"}"
    static let testCacheDataA = "{\"data\":\"A\"}"
    static let testCacheDataB = "{\"data\":\"B\"}"
    static let testCacheKey = "testKey"
    static let testCacheInterval: Double = 1000
    static let testUrl = URL(string: "https://www.google.com")!
    static let testRequestData1: [String: Any] = ["a": 1, "b": 2, "c": 3, "d": 4]
    static let testRequestData2: [String: Any] = ["a": 1, "b": 2, "c": 3, "d": 4]
}

class NetworkManagerTest {

    let requestData1 = CacheContext(
        hash: TestData.testCacheKey,
        request: URLRequest(url: TestData.testUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
    )
    
    let settings = NetworkSettingsTest.networkSettings
    let networkClientProvider = NetworkClientProvider(cacheManager: CacheManager(
        storage: CacheStorage(default: CacheScope("default"), with: nil),
        sessionInfo: SessionInfoTest()
    ))
    let client = NetworkClientProvider(cacheManager: CacheManager(
        storage: CacheStorage(default: CacheScope("default"), with: nil),
        sessionInfo: SessionInfoTest()
    )).client(with: NetworkSettingsTest.networkSettings)
}



