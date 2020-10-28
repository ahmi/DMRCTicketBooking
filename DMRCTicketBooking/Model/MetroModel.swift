//
//  MetroModel.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import Foundation
// MARK: -  Metro Station
struct Metro: Codable {
    let name: String
    let location: [Double]
    let detail: String
}
