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

    fileprivate var selectedButton: UIButton?
    fileprivate var locationManager = CLLocationManager()
    fileprivate var current_location:CLLocation = CLLocation()
    fileprivate var initialStation: Metro?
    fileprivate var destinationStation: Metro?
    fileprivate var allStations: [Metro] = []
    fileprivate var tripDetails: String?
    
    weak var delegate: DashboardViewControllerDelegate?

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
    
    //MARK:- Use Cases
    
    func updateFare() {
        if ((initialStation != nil) && destinationStation != nil)  {
            var totalFare = 0
            if var initialIdx = allStations.firstIndex(where: {$0 == initialStation}) {
                if var finalIdx = allStations.firstIndex(where: {$0 == destinationStation}){
                    if initialIdx > finalIdx {
                        // swap values to run high order function reduce
                        (initialIdx, finalIdx) = (finalIdx, initialIdx)
                    }
                    totalFare = allStations[initialIdx..<finalIdx].reduce(0) { $0 + $1.fare
                    }
                }
            } else {
                //item could not be found
            }
            tripDetails = initialStation!.name + " to " + destinationStation!.name + " fare is \(totalFare) INR"
            lblPriceInfo.text = tripDetails
            
            let initialLocation = CLLocationCoordinate2D(latitude: initialStation!.location[0], longitude: initialStation!.location[1])
            let destination = CLLocationCoordinate2D(latitude: destinationStation!.location[0], longitude: destinationStation!.location[1])
            showRouteOnMap(pickupCoordinate: initialLocation, destinationCoordinate: destination)
            
            self.view.makeToast(tripDetails)
        }
    }
    
    @objc func resetEverythingRestratApp(){
        self.selectedButton = nil
        self.selectedStation = nil
        self.initialStation = nil
        self.destinationStation = nil
        self.tripDetails = nil
        lblPriceInfo.text = "Trip Details go here"
        self.map.removeOverlays(map.overlays)
        self.map.removeAnnotations(map.annotations)
        self.btnSelectInitial.setTitle("Select Initial", for: .normal)
        self.btnSelectDestination.setTitle("Select Destination", for: .normal)
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
        btnSelectInitial.layer.cornerRadius = 10
        btnSelectDestination.layer.cornerRadius = 10
        //Bar button item
        let done = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetEverythingRestratApp))
        self.navigationItem.rightBarButtonItem = done

        //load static array of metro stations
        let localMetroStore = MetroLocalStore()
        allStations =  localMetroStore.returnAllMetroStations()
    }
    //MARK:- Button Actions
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
    @IBAction func btnShare_tapped(_ sender: Any) {
        if ((initialStation == nil) || destinationStation == nil)  {
            self.view.makeToast("Please select departure and destination station to share this information")
            return
        }
        let image = UIImage(named: "metro")!
        let text = lblPriceInfo.text!
        let activityVC = UIActivityViewController(activityItems: [image, text], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
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
        renderer.strokeColor = .mapRouteColor
        renderer.lineWidth = 5.0
        return renderer
    }
}
