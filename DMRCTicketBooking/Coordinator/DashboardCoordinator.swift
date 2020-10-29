//
//  DashboardCoordinator.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 29/10/20.
//

import UIKit


class DashboardCoordinator: Coordinator,DashboardViewControllerDelegate {
    func dashboardViewControllerSelectStationTapped(_ selectedStation: Metro?) {
        let stationCoordinator = StationsListCoordinator(presenter: self.presenter, selectedStation: selectedStation)
        stationCoordinator.start()
        stationListCoordinator = stationCoordinator
    }
    
    private let presenter: UINavigationController
    private var dashboardVC: DashboardViewController?
    private var stationsListViewController: StationListViewController?
    private var stationListCoordinator: StationsListCoordinator?
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
       let dashboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        dashboard.title = "Select Trip"
        dashboard.delegate = self
        presenter.pushViewController(dashboard, animated: true)
        dashboardVC = dashboard
    }
    
    func presentStationListViewController(selectedMetro: Metro) {
        let stationCoordinator = StationsListCoordinator(presenter: presenter, selectedStation: selectedMetro)
        stationCoordinator.start()
        stationListCoordinator = stationCoordinator
    }
}
