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
class DashboardViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var btnSelectInitial: UIButton!
    @IBOutlet weak var btnSelectDestination: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var lblPriceInfo: UILabel!
    weak var delegate: DashboardViewControllerDelegate?
    fileprivate var selectedButton: UIButton?
    private var locationManager = CLLocationManager()
    var current_location:CLLocation = CLLocation()
    var selectedStation: Metro? {
        didSet{
            if (selectedStation != nil) {
                selectedButton?.setTitle(selectedStation?.name, for: .normal)
            }
        }
    }
    
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
        setupView()
        setUpLocationManager()
        _ = Metro(name: "Test", location: [112,223], detail: "details")
        let listVC = StationListViewController(title: "")
        listVC.delegate = self
        
        
        let london = MKPointAnnotation()
        london.title = "London"
        london.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        map.addAnnotation(london)
    }
    
    fileprivate func setupMapView(){
        
    }
}
extension DashboardViewController: StationListViewControllerDelegate {
    func stationListViewControllerDidSelectStation(_ selectedStation: Metro?) {
        print("User selected: \(selectedStation?.name ?? "nil returned") station")
    }
}

extension DashboardViewController: MKMapViewDelegate  {
    func setUpLocationManager() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.map.showsUserLocation = true
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.map.showsUserLocation = true
        self.map.delegate = self
        if let coor = self.map.userLocation.location?.coordinate{
            self.map.setCenter(coor, animated: true)
        }
    }
    
    // MARK: - MKMapViewDelegate methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    // MARK: - location manager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            map.showsUserLocation = true
        }
        if(status == CLAuthorizationStatus.denied) {
            print ( "Please check settings for location permissions")
        }
    }
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        zoomMapaFitAnnotations()
    }
    func zoomMapaFitAnnotations() {
        
        var zoomRect = MKMapRect.null
        for annotation in map.annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
            
            if (zoomRect.isNull) {
                zoomRect = pointRect
            } else {
                zoomRect = zoomRect.union(pointRect)
            }
        }
        self.map.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
    }
}
