//
//  AppCoordinator.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    
    init (window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewcontroller = DashboardViewController()
        let navController = UINavigationController(rootViewController: viewcontroller)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        let singlton = AppSingleton.shared
        print("singlton shared instande: \(singlton)")
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
