//
//  MapSearchSevice.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/19.
//

import MapKit

final class MapSearchSevice: NSObject {
    
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion = MKCoordinateRegion(MKMapRect.world)
    private var completerResults: [MKLocalSearchCompletion]?
    private let locationViewModel: SearchLocationViewModel?
    
    private var places: [MKMapItem?]? {
        didSet {
            
        }
    }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            places = nil
            localSearch?.cancel()
        }
    }
    
    init(viewModel: SearchLocationViewModel) {
        self.locationViewModel = viewModel
        super.init()
        
        configureSearchCompleter()
    }
    
    private func configureSearchCompleter() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .pointOfInterest
        searchCompleter?.pointOfInterestFilter = MKPointOfInterestFilter(including: MKPointOfInterestCategory.travelPointsOfInterest)
        searchCompleter?.region = searchRegion
    }
}

extension MapSearchSevice: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if searchText == "" {
            completerResults = nil
        }

        searchCompleter?.queryFragment = searchText
        search(for: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        search(for: searchBar.text)
    }
}

extension MapSearchSevice: MKLocalSearchCompleterDelegate {
 
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        locationViewModel?.list.value.removeAll()
        completerResults = completer.results
      
    }
    
    func completer(_ completer: MKLocalSearchCompleter,
                   didFailWithError error: Error) {
        if let error = error as NSError? {
            print("위치 가져오기 에러 발생: \(error.localizedDescription)")
        }
    }
    
}

//MARK: - Search

extension MapSearchSevice {
    
    func didSelectSearch(index: Int) {
        guard let completerResults = completerResults else { return }
        
        let result = completerResults[index]
        search(for: result)
    }
    
    //completion 기반 검색 실행
    func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }
    
    //문자 기반 검색 실행
    func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: MKPointOfInterestCategory.travelPointsOfInterest)
        searchRequest.naturalLanguageQuery = queryString
        search(using: searchRequest)
    }
    
    //들어온 request를 기반으로 검색을 실행한다.
    private func search(using searchRequest: MKLocalSearch.Request) {
        searchRequest.resultTypes = .pointOfInterest
        
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [weak self] response, error in
    
            guard let self = self,
                  let mapItems = response?.mapItems else { return }
            self.places = mapItems
            
            guard let results = completerResults else { return }
            for i in 0..<results.count {
                
                locationViewModel?.appendLocationModel(completion: results[i], mapitem: self.places?[0])
                
            }

        }
    }
}
