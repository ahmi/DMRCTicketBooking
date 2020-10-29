//
//  MetroModel.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import Foundation
// MARK: -  Metro Station
struct Metro: Codable,Equatable {
    static func < (lhs: Metro, rhs: Metro) -> Bool {
        return lhs.name == rhs.name
          && lhs.location == rhs.location
          && lhs.detail == rhs.detail
    }
    
    let name: String
    let location: [Double]
    let detail: String
}
