//
//  PlaceDetailViewController.swift
//  FindPlacesNearMe
//
//  Created by Divya Aggarwal on 17/04/23.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    let place:PlaceAnnotation

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.6
        return label
    }()

    var directionsButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Directions", for: .normal)
        return button
    }()

    var callButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call", for: .normal)
        return button
    }()

    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    func setupUI() {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = UIStackView.spacingUseSystem
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)


        nameLabel.text = place.name
        addressLabel.text = place.address
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(addressLabel)
        addressLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true

        let contactStack = UIStackView()
        contactStack.axis = .horizontal
        contactStack.translatesAutoresizingMaskIntoConstraints = false
        contactStack.spacing = UIStackView.spacingUseSystem

        directionsButton.addTarget(self, action: #selector(openDirections), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(makeCall), for: .touchUpInside)
        contactStack.addArrangedSubview(directionsButton)
        contactStack.addArrangedSubview(callButton)
        stack.addArrangedSubview(contactStack)
        view.addSubview(stack)
    }

    @objc func openDirections() {
        let coordinate = place.location.coordinate
        guard let url = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") else { return }
        UIApplication.shared.open(url)
    }

    @objc func makeCall() {
        guard let url = URL(string: "tel://\(place.phone)".formatPhoneCall) else { return }
        UIApplication.shared.open(url)
    }
}


extension String {
    var formatPhoneCall: String {
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
