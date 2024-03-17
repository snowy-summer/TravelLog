//
//  LocationViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/13.
//

import MapKit
//import UIKit

final class LocationViewController: UIViewController {
    
    private let mapView = MKMapView()
    private let searchBar = UISearchBar()
    
    //검색창
    //검색 리스트
    //자동완성
    //사진에서 위치 데이터 가지고 오기
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        
        self.sheetPresentationController?.prefersGrabberVisible = true
        
        configureMapView()
        
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
    
    private func configureSearchBar() {
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.9697164893, green: 0.9697164893, blue: 0.9697164893, alpha: 1)
        
        let safeArea = view.safeAreaLayoutGuide
        let searchBarConstraints = [
            searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                           constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                               constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                constant: -16),
            
        ]
        
        NSLayoutConstraint.activate(searchBarConstraints)
    }
}

extension LocationViewController {
    
    func presentModal() {
        let searchViewController = SearchLocationViewController()
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
