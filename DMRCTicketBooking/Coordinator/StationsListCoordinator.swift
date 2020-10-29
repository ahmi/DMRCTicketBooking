//
//  StationsListCoordinator.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import UIKit
class StationsListCoordinator: Coordinator, StationListViewControllerDelegate {
    func stationListViewControllerDidSelectStation(_ selectedStation: Metro?) {
        self.dashboardViewController?.selectedStation = selectedStation
        print("selected metro: \(selectedStation?.name ?? "nil returned")")
        presenter.popViewController(animated: true)
    }
    
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
        listVC.listDelegate = self
        listVC.selectedStation = self.selectedStation
        presenter.pushViewController(listVC, animated: true)
        self.stationListViewController = listVC
    }
//    func DashboadViewController(selectedMetro: Metro) {
//        let dashboardCoordinator = DashboardCoordinator(presenter: presenter)
//        dashboardCoordinator.start()
//        stationListCoordinator = dashboardCoordinator
//    }
}
