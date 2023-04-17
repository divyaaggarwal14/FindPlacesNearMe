//
//  PlacesTableViewController.swift
//  FindPlacesNearMe
//
//  Created by Divya Aggarwal on 17/04/23.
//

import UIKit
import MapKit

class PlacesTableViewController: UITableViewController {
    let userCurrentLocation: CLLocation
    private var places: [PlaceAnnotation]

    init(userCurrentLocation: CLLocation, places: [PlaceAnnotation]) {
        self.userCurrentLocation = userCurrentLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.places.swapAt(indexSelectedRow() ?? 0, 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }

    private func indexSelectedRow() -> Int? {
        self.places.firstIndex(where: { $0.isSelected == true })
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let place = places[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = formatDistance(calculateDistance(from: userCurrentLocation, to: place.location))
        cell.contentConfiguration = content
        cell.backgroundColor = cell.isSelected ? UIColor.lightGray : UIColor.white
        return cell
    }

    private func calculateDistance(from: CLLocation, to: CLLocation) -> CLLocationDistance {
        from.distance(from: to)
    }

    func formatDistance(_ distance: CLLocationDistance) -> String {
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to: .miles).formatted()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        let placeDetailVC = PlaceDetailViewController(place: place)
        present(placeDetailVC, animated: true)

    }
}
