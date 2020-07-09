//
//  ViewController.swift
//  AppleMap
//
//  Created by Tong Yi on 7/2/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var waitingWorkItem: DispatchWorkItem?
    private let locationManager = CLLocationManager()
    private let pinID = "_MapViewPinID"
    private var mostAccurateLocation: CLLocation?
    private var previousAccurateLocation: CLLocation?
    private var viewModel = ViewModel()
    
    lazy var geocoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    var items = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        checkAuthorition()
        setupMapKit()
        setupLocationM()
        setupDataSource()
    }
    
    func setupDataSource()
    {
        viewModel.fetchLocationData {
            self.remoteDataShowingOnTheMap()
        }
    }
    
    func setupMapKit()
    {
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        mapView.isPitchEnabled = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
    }
    
    func setupUI() {
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Standard", "Satellite", "Hybrid"]
        searchController.searchBar.showsScopeBar = true
        navigationItem.searchController = searchController
    }
    
    func setupLocationM()
    {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 5
        self.locationManager.startUpdatingLocation()
    }
    
    func checkAuthorition()
    {
        let status = CLLocationManager.authorizationStatus() // need to check for ios 14.0
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Approved")
                locationManager.startUpdatingLocation()
            case .denied:
                // show alert to a user that their location service is disabled
                break
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .restricted:
                break
            default:
                break
        }
    }
    
    func remoteDataShowingOnTheMap()
    {
//        var annotations: [CustomAnnotation] = []
        for data in self.viewModel.dataSource {
            
            guard let latitude = data.latitude, let longtitude = data.longitude else { return }
            
            let geoCoder = CLGeocoder()
    
            let location = CLLocation(latitude: Double(latitude)!, longitude: Double(longtitude)!)
            
            geoCoder.reverseGeocodeLocation(location) { (clplaceMarks, error) in
                guard let placeMarks = clplaceMarks, let placeMark = placeMarks.first, error == nil else { return }
                
                guard let address = placeMark.completeAddress else { return }
            
//                annotations.append(CustomAnnotation(viewModel: CustomCalloutModel(title: data.creator ?? "No title", subtitle: data.locat ?? "No subtitle", image: #imageLiteral(resourceName: "cafe")), coordinate: coordinate))
                self.mapView.addAnnotation(CustomAnnotation(viewModel: CustomCalloutModel(title: data.creator ?? "No title", subtitle: data.locat ?? "No subtitle", image: #imageLiteral(resourceName: "cafe"), at: location.coordinate, address: address), coordinate: location.coordinate))
            }
        }
        
//        DispatchQueue.global(qos: .background).async(execute: workItem)
//
//        workItem.notify(queue: .main) {
//            for annotation in annotations {
//                self.mapView.addAnnotation(annotation)
//            }
//        }
    }
    
    func centerTo(location: CLLocation, regionRadius: CLLocationDistance) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.setRegion(region, animated: true)
    }
    
    func setCamera(positionFor location: CLLocation, regionRadius: CLLocationDistance) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        let cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
        self.mapView.setCameraBoundary(cameraBoundary, animated: true)
        
//        let zoom = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 10000000)
//        self.mapView.setCameraZoomRange(zoom, animated: true)
    }
}

extension ViewController: CustomCalloutViewModelDelegate {
    func detailbuttonTapped(_ address: String?) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address!) { (clplaceMarks, error) in
            guard let placeMarks = clplaceMarks, let placeMark = placeMarks.first, error == nil else { return }
            
            guard let location = placeMark.location else { return }
            
            let latitude = location.coordinate.latitude
            let longtitude = location.coordinate.longitude
            
            AlertManager.shared.alert(title: "Coordinate", message: "latitude: \(latitude)\nlongtitude: \(longtitude)", controller: self)
        }
    }
    
    func addressButtonTapped(title: String, _ coordinate: CLLocationCoordinate2D?) {
        let geoCoder = CLGeocoder()
        
        guard let latitude = coordinate?.latitude, let longitude = coordinate?.longitude else { return }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geoCoder.reverseGeocodeLocation(location) { (clplaceMarks, error) in
            guard let placeMarks = clplaceMarks, let placeMark = placeMarks.first, error == nil else { return }
            
            let address = placeMark.completeAddress
            
            AlertManager.shared.alert(title: title, message: address ?? "no address", controller: self)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        waitingWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let weakSelf = self else { return }
            searchBar.resignFirstResponder()
            
            guard let searchText = searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces), !searchText.isEmpty else { return }
            
            weakSelf.performSearch(using: searchText)
        }
        
        waitingWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: waitingWorkItem!)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces), !searchText.isEmpty else { return }
        
        self.performSearch(using: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch searchBar.selectedScopeButtonIndex {
        case 0:
            self.mapView.mapType = .standard
        case 1:
            self.mapView.mapType = .satellite
        default:
            self.mapView.mapType = .hybrid
        }
    }
    
    func performSearch(using searchText: String) {
        print(searchText)
        self.items.removeAll()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = self.mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response,
                error == nil,
                !response.mapItems.isEmpty else { return }
            
            print(response.mapItems.count)
            
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}

//MARK: - CL Location Manager Delegate methods

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          // get the most updated and accuracy result then stop the location service
        // swiftLocation 3PL
        guard let latestLoc = locations.last else { return }
        guard let mostAccuLoc = self.mostAccurateLocation else {
            self.mostAccurateLocation = latestLoc
            return
        }
     
        if latestLoc.timestamp > mostAccurateLocation!.timestamp + 5 {
            for location in locations {
                if mostAccuLoc.horizontalAccuracy > location.horizontalAccuracy
                    || mostAccuLoc.verticalAccuracy > location.verticalAccuracy {
                    
                    mostAccurateLocation = location
                }
                
                manager.stopUpdatingLocation()
                manager.startUpdatingLocation()
            }
        }
        
        guard mostAccurateLocation != previousAccurateLocation else { return }
        
        previousAccurateLocation = mostAccurateLocation
        
        AlertManager.shared.alert(title: "LOCATION INFO", message: mostAccurateLocation!.description, controller: self)
        
        print("\(mostAccuLoc.coordinate)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AlertManager.shared.alert(title: "ERROR!", message: error.localizedDescription, controller: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Approved")
                locationManager.startUpdatingLocation()
            case .denied:
                // show alert to a user that their location service is disabled
                break
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .restricted:
                break
            default:
                break
        }
    }
}

//MARK: - Map View Delegate methods

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else { return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pinID) as? CustomAnnotationView
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: pinID) as CustomAnnotationView
        }

        annotationView?.annotation = annotation
        annotationView?.canShowCallout = false
        annotationView?.centerOffset = CGPoint(x: 0, y: -annotationView!.bounds.size.height * 0.5)
        annotationView?.isDraggable = true
        annotationView?.calloutView = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)!.first as? CustomCalloutView
        annotationView?.calloutView?.delegate = self

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let location = userLocation.location else { return }
        
        let honoluluLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        
        let annotation: CustomAnnotation = CustomAnnotation(viewModel: CustomCalloutModel(title: "107 Coffee Dessert", subtitle: "Tina's cafe, Welcome!!", image: #imageLiteral(resourceName: "house"), at: location.coordinate, address: "820 SW 2 Ave, Miami, FL 33022, USA"), coordinate: location.coordinate)
        
        self.centerTo(location: location, regionRadius: 10000)
     
        self.setCamera(positionFor: honoluluLocation, regionRadius: 20000)

        mapView.addAnnotation(annotation)
    }
        
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        guard let point = touches.first?.location(in: mapView) else { return }
//
//        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
//
//        if mapView.annotations.count != 0 {
//            mapView.removeAnnotations(mapView.annotations)
//        }
//
//        let annotation = addAnnotation(coordinate, title: "title", subTitle: "subTitle")
//        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//
//        geocoder.reverseGeocodeLocation(location) { (pls, error) in
//            if error == nil {
//                guard let pl = pls?.first else { return }
////                    print(pl)
//                annotation.viewModel = CustomCalloutViewModel(title: "\(String(describing: pl.locality))", subtitle: "\(String(describing: pl.name))", image: UIImage(systemName: "photo.fill")!)
//            }
//        }
//    }
//
//    func addAnnotation(_ coordinate: CLLocationCoordinate2D, title: String, subTitle: String) -> CustomAnnotation {
//        let annotation: CustomAnnotation = CustomAnnotation(viewModel: CustomCalloutViewModel(title: title, subtitle: subTitle, image: UIImage(systemName: "photo.fill")!), coordinate: coordinate)
//
//        mapView.addAnnotation(annotation)
//        return annotation
//    }
}




