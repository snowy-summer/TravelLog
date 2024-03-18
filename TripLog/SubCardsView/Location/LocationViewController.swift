//
//  LocationViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/13.
//

import MapKit

final class LocationViewController: UIViewController {
    
    private let mapView = MKMapView()
    private let searchViewController = SearchLocationViewController()
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        
        self.sheetPresentationController?.prefersGrabberVisible = true
        
        configureMapView()
        configureNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentModal()
    }
    
}

//MARK: - Configuration

extension LocationViewController {
    
    private func configureMapView() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        let mapViewConstraints = [
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(mapViewConstraints)
    }
    
    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(title: "뒤로가기",
                                         style: .plain,
                                         target: self,
                                         action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backAction() {
        searchViewController.dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
}

extension LocationViewController {
    
    func presentModal() {
        
        searchViewController.isModalInPresentation = true
        
        let lowDetentIdentifier = UISheetPresentationController.Detent.Identifier("low")
        let defaultDetentIdentifier = UISheetPresentationController.Detent.Identifier("default")
        
        let lowDetent = UISheetPresentationController.Detent.custom(identifier: lowDetentIdentifier) { [weak self] _ in
            guard let self = self else { return 0}
            return self.view.bounds.height * 0.1
        }
        
        let defaultDetent = UISheetPresentationController.Detent.custom(identifier: defaultDetentIdentifier) { [weak self] _ in
            guard let self = self else { return 0}
            return self.view.bounds.height * 0.35
        }
                
        if let sheet = searchViewController.sheetPresentationController {
            
            sheet.detents = [
                defaultDetent,
                .large(),
                lowDetent
            ]
            
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.selectedDetentIdentifier = defaultDetentIdentifier
    
        }
        self.present(searchViewController, animated: false)
    }
}
