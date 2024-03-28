//
//  MapViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/13.
//

import MapKit

final class MapViewController: UIViewController {
    
    private let locationViewModel = SearchLocationViewModel()
    private lazy var mapSearchService = MapSearchSevice()
    weak var delegate: MapViewControllerDelegate?
    
    private let mapView = MKMapView()
    private let searchView: SearchLocationView
    
    private var modalHeightConstraint: NSLayoutConstraint?
    private lazy var currentModalHeight: CGFloat = ModalHeight.mideum.height(of: view)
    
    private let mainQueue = DispatchQueue.main
    
    init(delegate: MapViewControllerDelegate? = nil, location: LocationModel?) {
        self.delegate = delegate
        self.searchView = SearchLocationView(locationViewModel: locationViewModel)
        super.init(nibName: nil, bundle: nil)
        
        if let location = location {
            locationViewModel.updateSavedLocation(location: location)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        bind()
        configureDelegate()
        configureMapView()
        configureNavigationBar()
        loadSearchView()
        configureSearchView()
    }
    
}

extension MapViewController {
    
    private func bind() {
        
        locationViewModel.list.observe { [weak self] locationModels in
            self?.searchView.saveSnapshot(id: locationModels.map{ $0.id })
        }
        
        locationViewModel.savedLocation.observe { [weak self] location in
            self?.searchView.updateInformationView()
        }
    }
    
    @objc private func popViewController() {
        delegate?.updateLocation(location: locationViewModel.savedLocation.value)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: searchView)
        let isDraggingDown = translation.y > 0
        
        let newHeight = currentModalHeight - translation.y
        
        if gesture.state == .changed {
            if newHeight < view.frame.height {
                modalHeightConstraint?.constant = newHeight
                searchView.layoutIfNeeded()
                
            }
        } else if gesture.state == .ended {
            if newHeight < ModalHeight.min.height(of: view) {
                
                animateModalHeight(ModalHeight.min.height(of: view))
                
            } else if newHeight > ModalHeight.mideum.height(of: view) &&
                        newHeight < ModalHeight.low.height(of: view) {
                
                isDraggingDown ? animateModalHeight(ModalHeight.min.height(of: view)) : animateModalHeight(ModalHeight.low.height(of: view))
                
            } else if newHeight > ModalHeight.low.height(of: view) &&
                        newHeight < ModalHeight.mideum.height(of: view) {
                
                isDraggingDown ? animateModalHeight(ModalHeight.low.height(of: view)) : animateModalHeight(ModalHeight.mideum.height(of: view))
                
            } else if newHeight > ModalHeight.mideum.height(of: view) {
                
                isDraggingDown ? animateModalHeight(ModalHeight.mideum.height(of: view)) : animateModalHeight(ModalHeight.max.height(of: view))
                
            }
        }
    }
    
    private func animateModalHeight(_ height: CGFloat) {
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.modalHeightConstraint?.constant = height
            self?.view.layoutIfNeeded()
        }
        
        currentModalHeight = height
    }
}

extension MapViewController: InformationViewDelegate {
    
    func popMapViewController() {
        delegate?.updateLocation(location: locationViewModel.savedLocation.value)
        navigationController?.popViewController(animated: true)
    }
    
    func hideInformationView() {
        searchView.isCollectionViewHidden(value: false)
        animateModalHeight(ModalHeight.max.height(of: view))
    }
    
}

extension MapViewController: SearchLocationViewDelegate {
    
    func updateMapView(where coordinate: CLLocationCoordinate2D, title: String?) {
        
        mainQueue.async { [weak self] in
            guard let self = self else { return }
            
           
            mapView.removeAnnotations(self.mapView.annotations)
            
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
    
    func changeModalLowConstraint() {
        mainQueue.async { [weak self] in
            guard let self = self else { return }
            animateModalHeight(ModalHeight.low.height(of: view))
        }
    }
    
    func changeModalMaxConstraint() {
        mainQueue.async { [weak self] in
            guard let self = self else { return }
            animateModalHeight(ModalHeight.max.height(of: view))
        }
    }
}

//MARK: - MKMapViewDelegate

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

extension MapViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        changeModalMaxConstraint()
    }

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if searchText == "" {
            mapSearchService.upadteCompleterResults(results: nil)
        }
        
        mapSearchService.updateCompleter(query: searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        mapSearchService.search(for: searchBar.text)
    }
}

//MARK: - Configuration

extension MapViewController {
    
    private func configureDelegate() {
        mapView.delegate = self
        searchView.delegate = self
        searchView.configureSearchBarDelegate(who: self)
        searchView.configureInformationViewDelegate(who: self)
        mapSearchService.delegate = locationViewModel
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    private func loadSearchView() {

        if let mapItem = locationViewModel.savedLocation.value.mapItem {
            currentModalHeight = ModalHeight.low.height(of: view)
            searchView.isCollectionViewHidden(value: true)
            updateMapView(where: mapItem.placemark.coordinate,
                          title: mapItem.name)
        }
    }
    
    private func configureSearchView() {
        view.addSubview(searchView)
        
        searchView.translatesAutoresizingMaskIntoConstraints = false

        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        
        searchView.addGestureRecognizer(panGesture)
        
        modalHeightConstraint = searchView.heightAnchor.constraint(equalToConstant: currentModalHeight)
        guard let height = modalHeightConstraint else { return }
        
        let searchViewConstraints = [
            searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            height
        ]
        
        NSLayoutConstraint.activate(searchViewConstraints)
    }
    
    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(title: "뒤로가기",
                                         style: .plain,
                                         target: self,
                                         action: #selector(popViewController))
        
        navigationItem.leftBarButtonItem = backButton
    }
    
}
