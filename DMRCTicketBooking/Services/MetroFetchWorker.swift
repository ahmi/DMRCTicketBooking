//
//  MetroFetchWorker.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import Foundation
// MARK:- APIError
enum APIError: Error {
    case internalError //Base url, incorrect endpoint etc
    case serverError // restricted access or something like that
    case parsingError // parsing issues, wrong json or something like that
}

// MARK: - MetroStore Protocol

/// This protocol is a wrapper, it will allow us to decouple the app and the API, which in turn will allow us to mock it easily for testing, have several providers… even change completely the API code without changing a single line in the rest of the app!

protocol MetroStoreProtocol {
    func fetchMetroStationsInfo<T:Codable>(completion: @escaping (Result<[T],APIError>) -> Void)
    func fetchFunctionNotImplementedByAnyClass()
}

//Protocol extension methods are called only if protocol method isnt implemented by conforming class/struct
extension MetroStoreProtocol {
    func fetchFunctionNotImplementedByAnyClass() {
        print("MetroStoreProtocol called in extension since no class has implmented it - More details: \n \(AppSingleton.shared.protocolExtensionDetailString )")
    }
}

class MetroFetchWorker {
    var metroStore: MetroStoreProtocol
    init(metroStore: MetroStoreProtocol) {
        self.metroStore = metroStore
    }
    func fetchMetroStations(completion: @escaping (Result<[Metro], APIError>) -> Void)  {
        self.metroStore.fetchMetroStationsInfo { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
