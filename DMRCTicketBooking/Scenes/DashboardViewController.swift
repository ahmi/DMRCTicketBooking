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
    fileprivate var locationManager = CLLocationManager()
    fileprivate var current_location:CLLocation = CLLocation()
    fileprivate var initialStation: Metro?
    fileprivate var destinationStation: Metro?
    fileprivate var allStations: [Metro] = []

    var selectedStation: Metro? {
        didSet{
            if (selectedStation != nil) {
                selectedButton?.setTitle(selectedStation!.name, for: .normal)
                
                if (selectedStation != initialStation && selectedStation != destinationStation ) {
                    addAnnotation(selectedStation: selectedStation!)
                }
                
                if selectedButton == btnSelectInitial {
                    initialStation = selectedStation
                } else {
                    destinationStation = selectedStation
                }
                updateFare()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpLocationManager()
    }
    
    func updateFare() {
        if ((initialStation != nil) && destinationStation != nil)  {
            
            let fare = initialStation!.fare + destinationStation!.fare
            let finalMessage = initialStation!.name + " to " + destinationStation!.name + " fare is \(fare) INR"
            lblPriceInfo.text = finalMessage
            
            let initialLocation = CLLocationCoordinate2D(latitude: initialStation!.location[0], longitude: initialStation!.location[1])
            let destination = CLLocationCoordinate2D(latitude: destinationStation!.location[0], longitude: destinationStation!.location[1])
            showRouteOnMap(pickupCoordinate: initialLocation, destinationCoordinate: destination)
        }
    }
    func addAnnotation(selectedStation: Metro) {
        let station = MKPointAnnotation()
        station.title = selectedStation.name
        station.coordinate = CLLocationCoordinate2D(latitude: selectedStation.location[0], longitude: selectedStation.location[1] )
        map.addAnnotation(station)
    }
    fileprivate func setupView() {
        btnSelectInitial.setTitleColor(.titleColor, for: .normal)
        btnSelectDestination.setTitleColor(.titleColor, for: .normal)
        lblPriceInfo.textColor = .titleColor
        map.tintColor = .titleColor
        //load static array of metro stations
        let localMetroStore = MetroLocalStore()
        allStations =  localMetroStore.returnAllMetroStations()
    }
    
    @IBAction func btnSelection_tapped(_ sender: UIButton) {
        self.delegate?.dashboardViewControllerSelectStationTapped(selectedStation)
        switch sender.tag {
            case 0:
                selectedButton = btnSelectInitial

            case 1:
                selectedButton = btnSelectDestination
                
            default:
                break
        }
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
            annotationView?.image = UIImage(named: "metro")
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
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let sourceAnnotation = MKPointAnnotation()

        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }

        let destinationAnnotation = MKPointAnnotation()

        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        self.map.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )

        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile

        // Calculate the direction
        let directions = MKDirections(request: directionRequest)

        directions.calculate {
            (response, error) -> Void in

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }

                return
            }

            let route = response.routes[0]
            self.map.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)

        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)

        renderer.lineWidth = 5.0

        return renderer
    }
}
