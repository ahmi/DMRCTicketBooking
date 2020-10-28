//
//  StationsListCoordinator.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import UIKit
class StationsListCoordinator: Coordinator {
    private let presenter: UINavigationController
    private let selectedStation: Metro?
    private var stationListViewController: StationListViewController?
    
    init(presenter: UINavigationController, selectedStation: Metro) {
        self.presenter = presenter
        self.selectedStation =  selectedStation
    }
    
    func start() {
        let listVC = StationListViewController(title: "Choose Station")
        presenter.pushViewController(listVC, animated: true)
        self.stationListViewController = listVC
    }
}
