//
//  DashboardViewController.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
   let metroLocalData = MetroLocalStore()
        let metroFetchWorker = MetroFetchWorker(metroStore: metroLocalData)
        metroFetchWorker.fetchMetroStations { (result) in
            switch result {
                case .success(let metros): do {
                    print(metros)
                }
                case .failure(let error):
                    print(error)
            }
        }
    }
}
