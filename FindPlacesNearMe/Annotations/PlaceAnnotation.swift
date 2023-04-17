//
//  PlaceAnnotation.swift
//  FindPlacesNearMe
//
//  Created by Divya Aggarwal on 17/04/23.
//

import Foundation
import MapKit
import CoreLocation

class PlaceAnnotation: MKPointAnnotation {
    let mapItem: MKMapItem
    let id = UUID()
    var isSelected = false
    init( mapItem: MKMapItem) {
        self.mapItem = mapItem
        super.init()
        self.coordinate = mapItem.placemark.coordinate
    }

    var name: String {
        mapItem.name ?? ""
    }

    var phone: String {
        mapItem.phoneNumber ?? ""
    }

    var location: CLLocation {
        mapItem.placemark.location ?? CLLocation.default
    }

    var address: String {
        "\(mapItem.placemark.subThoroughfare ?? "") \(mapItem.placemark.thoroughfare ?? "") \(mapItem.placemark.locality ?? "") \(mapItem.placemark.countryCode ?? "")"
    }
}


extension CLLocation {
    static var `default`: CLLocation {
        CLLocation(latitude: 36.063, longitude: -95.880)
    }
}
