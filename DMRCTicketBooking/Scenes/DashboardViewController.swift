//
//  DashboardViewController.swift
//  DMRCTicketBooking
//
//  Created by Ahmad Waqas on 28/10/20.
//

import UIKit
import MapKit
protocol DashboardViewControllerDelegate: class {
  func dashboardViewControllerSelectStationTapped(_ selectedStation: Metro?)
}
class DashboardViewController: UIViewController {

    @IBOutlet weak var btnSelectInitial: UIButton!
    @IBOutlet weak var btnSelectDestination: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var lblPriceInfo: UILabel!
    
    var selectedStation: Metro? {
        didSet{
            if (selectedStation != nil) {
                selectedButton?.setTitle(selectedStation?.name, for: .normal)
            }
        }
    }
    weak var delegate: DashboardViewControllerDelegate?
    fileprivate var selectedButton: UIButton?
    
    
    fileprivate func setupView() {
        btnSelectInitial.setTitleColor(.init(light: .titleColorforLight, dark: .titleColorforDark), for: .normal)
        btnSelectDestination.setTitleColor(.init(light: .titleColorforLight, dark: .titleColorforDark), for: .normal)
        lblPriceInfo.textColor = .init(light: .titleColorforLight, dark: .titleColorforDark)
        map.tintColor = .init(light: .titleColorforLight, dark: .titleColorforDark)
        
    }
    @IBAction func btnSelection_tapped(_ sender: UIButton) {
        print ("btn tapped \(String(describing: sender.tag))")
        switch sender.tag {
            case 0:
                selectedButton = btnSelectInitial
                self.delegate?.dashboardViewControllerSelectStationTapped(selectedStation)
            case 1:
                selectedButton = btnSelectDestination
                self.delegate?.dashboardViewControllerSelectStationTapped(selectedStation)
                
            default:
                break
        }
        
    }
    
    private let mapView : UIView = {
        let map = UIView()
        map.backgroundColor = .init(light: .gray, dark: .lightText)

        return map
    }()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Metro(name: "Test", location: [112,223], detail: "details")

    }
    

    fileprivate func setupMapView(){
        
    }
}
extension DashboardViewController: StationListViewControllerDelegate {
    func stationListViewControllerDidSelectStation(_ selectedStation: Metro?) {
        print("User selected: \(selectedStation?.name ?? "nil returned") station")
    }
}
