//
//  ViewController.swift
//  FindPlacesNearME
//
//  Created by Divya Aggarwal on 17/04/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    var locationManager: CLLocationManager?
    private var places = [PlaceAnnotation]()
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        return map
    }()

    lazy var searchTextField: UITextField = {
        var search = UITextField()
        search.layer.cornerRadius = 10
        search.clipsToBounds = true
        search.backgroundColor = .white
        search.placeholder = "Search"
        search.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: 0))
        search.leftViewMode = .always
        search.translatesAutoresizingMaskIntoConstraints = false
        search.returnKeyType = .go
        search.delegate = self
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        setupUI()
    }

    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(searchTextField)
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        searchTextField.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    private func checkLocationAuthorization() {
        guard let locationManager, let location = locationManager.location else { return }
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mapView.setRegion(region, animated: true)
        case .denied:
            print("denied")
        case .notDetermined:
            print("denied")
        case .restricted:
            print("denied")
        default:
            print("denied")
        }
    }

    func findNearbyPlaces(by query: String) {
        mapView.removeAnnotations(mapView.annotations)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response, error == nil else { return }
            let places = response.mapItems.map(PlaceAnnotation.init)
            self?.places = places
            places.forEach { place in
                self?.mapView.addAnnotation(place)
            }
            self?.presentPlacesSheet(places)
        }
    }

    func presentPlacesSheet(_ places: [PlaceAnnotation]) {
        guard let locationManager, let location = locationManager.location else { return }
        let places = PlacesTableViewController(userCurrentLocation: location, places: places)
        places.modalPresentationStyle = .pageSheet
        if let sheet = places.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(places, animated: true)
        }
    }
}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

extension ViewController: UITextFieldDelegate  {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            findNearbyPlaces(by: text)
        }
        return true
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        clearAllSelections()
        guard let selection = annotation as? PlaceAnnotation else { return }
        let place = self.places.first(where: { $0.id == selection.id })
        place?.isSelected = true
        presentPlacesSheet(places)
    }

    func clearAllSelections() {
        self.places = places.map { place in
            place.isSelected = false
            return place
        }
    }
}
