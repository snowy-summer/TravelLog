//
//  MapViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/13.
//

import MapKit

final class MapViewController: UIViewController {
    
    private let locationViewModel = SearchLocationViewModel()
    weak var delegate: MapViewControllerDelegate?
    
    private let mapView = MKMapView()
    private let searchViewController: SearchLocationViewController
    
    init(delegate: MapViewControllerDelegate? = nil, location: LocationModel?) {
        self.delegate = delegate
        self.searchViewController = SearchLocationViewController(locationViewModel: locationViewModel)
        super.init(nibName: nil, bundle: nil)
      
        if let location = location {
            locationViewModel.updateSavedLocation(location: location)
        }
        
        print("mapView 생성")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        savedLocationBind()
        configureMapView()
        configureNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentModal()
    }
    
    deinit {
        print("mapView 해제")
    }
    
}

extension MapViewController {
    
    private func savedLocationBind() {
         locationViewModel.savedLocation.observe { [weak self] location in
             self?.searchViewController.updateInformationView()
             
         }
     }
    
    private func presentModal() {
        
        searchViewController.isModalInPresentation = true
        searchViewController.delegate = self
        searchViewController.configureInformationViewDelegate(delegate: self)

        if let sheet = searchViewController.sheetPresentationController {
            
            sheet.detents = [
                CustomDetent.base.detent(view: self.view),
                .large(),
                CustomDetent.low.detent(view: self.view)
            ]
            
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.selectedDetentIdentifier = CustomDetent.base.idetifier
    
        }
        
        self.present(searchViewController, animated: false)
    }
    
    @objc private func popViewController() {
        delegate?.updateLocation(location: locationViewModel.savedLocation.value)
        searchViewController.isModalInPresentation = false
        searchViewController.dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
}

extension MapViewController: InformationViewDelegate {
    
    func popMapViewController() {
        delegate?.updateLocation(location: locationViewModel.savedLocation.value)
        searchViewController.dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    func hideInformationView() {
        searchViewController.isCollectionViewHidden(value: false)
        searchViewController.sheetPresentationController?.selectedDetentIdentifier = .large
    }
    
}

extension MapViewController: SearchLocationViewControllerDelegate {
    
    func updateMapView(where coordinate: CLLocationCoordinate2D, title: String?) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.005,
                                        longitudeDelta: 0.005)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinate
            annotation.title = title
            
            self.mapView.setRegion(MKCoordinateRegion(center: coordinate,
                                                 span: span),
                              animated: true)

            self.mapView.addAnnotation(annotation)
        }
        
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        guard let featureAnnotation = annotation as? MKMapFeatureAnnotation else { return }
        
        let request = MKMapItemRequest(mapFeatureAnnotation: featureAnnotation)
        request.getMapItem {[weak self] mapItem, error in
            
            if let mapItem {
                
                self?.locationViewModel.updateSavedLocationMapItem(mapItem: mapItem)
                self?.updateMapView(where: mapItem.placemark.coordinate,
                                    title: mapItem.name)

            }
        }
    }
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "CustomAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation,
                                                    reuseIdentifier: identifier)
        
        } else {
            annotationView?.annotation = annotation
         
        }
        annotationView?.setSelected(true, animated: true)
        annotationView?.titleVisibility = .visible
        annotationView?.markerTintColor = locationViewModel.savedLocationMapItem?.pointOfInterestCategory?.annotationColor
        annotationView?.glyphImage = locationViewModel.savedLocationMapItem?.pointOfInterestCategory?.annotationSymbol
        
                
        return annotationView
    }

}

//MARK: - Configuration

extension MapViewController {
    
    private func configureMapView() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = false
        mapView.selectableMapFeatures = [.pointsOfInterest]
        
        let mapConfiguration = MKStandardMapConfiguration()
        mapView.preferredConfiguration = mapConfiguration
        
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
                                         action: #selector(popViewController))
        
        navigationItem.leftBarButtonItem = backButton
    }
    
}
