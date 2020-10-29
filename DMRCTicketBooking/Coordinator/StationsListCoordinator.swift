//
//  StationsListCoordinator.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import UIKit
class StationsListCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private var selectedStation: Metro?
    private var stationListViewController: StationListViewController?
    private var dashboardViewController: DashboardViewController?

    
    init(presenter: UINavigationController, selectedStation: Metro?) {
        self.presenter = presenter
        self.selectedStation =  selectedStation
    }
    
    func start() {
        let listVC = StationListViewController(title: "Choose Station")
     //   listVC.listDelegate = self
        listVC.selectedStation = self.selectedStation
        presenter.pushViewController(listVC, animated: true)
        self.stationListViewController = listVC
    }
}
