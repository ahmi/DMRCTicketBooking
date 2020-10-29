//
//  AppCoordinator.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    let rootViewController: UINavigationController
    let dashboardCoordinator: DashboardCoordinator
    let listCoordinator: StationsListCoordinator

    init (window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = false
        dashboardCoordinator = DashboardCoordinator(presenter: rootViewController)
        listCoordinator = StationsListCoordinator(presenter: rootViewController, selectedStation: Metro(name: "", location: [1,1], detail: ""))
    }
    
    func start() {
        window.rootViewController = rootViewController
        dashboardCoordinator.start()
      //  listCoordinator.start()
        window.makeKeyAndVisible()
    }
}

// MARK:- Singlton to fetch strings from plist

struct AppSingleton {
    static let shared = AppSingleton()
    var protocolExtensionDetailString: String = ""
    var jsonFileName: String = ""
    
    private init() {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {return}
        let nsDictionary = NSDictionary(contentsOfFile: path)!
        protocolExtensionDetailString = nsDictionary["protocolExtensionExample"] as! String
        jsonFileName = nsDictionary["jsonFileName"] as! String
    }
}
