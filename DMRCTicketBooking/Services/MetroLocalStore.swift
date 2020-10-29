//
//  MetroLocalStore.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import Foundation
class MetroLocalStore: MetroStoreProtocol {

    func fetchMetroStationsInfo<T:Codable>(completion: @escaping (Result<[T], APIError>) -> Void) {
        guard let jsonFileURL = Bundle.main.url(forResource: AppSingleton.shared.jsonFileName, withExtension: "json") else {
            completion(.failure(.parsingError))
            return
        }
        do {
            let jsonData = try Data(contentsOf: jsonFileURL)
            let json = try JSONDecoder().decode([T].self, from: jsonData)
            completion(.success(json))
        }
        catch {
            completion(.failure(.parsingError))
        }
    }
}
