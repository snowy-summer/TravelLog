//
//  MapSearchSevice.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/19.
//

import MapKit

final class MapSearchSevice: NSObject {
    
    private let locationViewModel: SearchLocationViewModel?
    private let debouncer = Debouncer(seconds: 1)
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion = MKCoordinateRegion(MKMapRect.world)
    private var completerResults: [MKLocalSearchCompletion]?
    private var localSearch: MKLocalSearch?
    
    private var places = [MKMapItem]() {
        didSet {
            locationViewModel?.list.value.removeAll()
            
            for place in places {
                locationViewModel?.appendLocationModel(mapitem: place)
            }
            
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
        searchCompleter?.region = searchRegion
    }

}

extension MapSearchSevice: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if searchText == "" {
            completerResults = nil
        }
        searchCompleter?.queryFragment = searchBar.text!
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        search(for: searchBar.text)
    }
}

extension MapSearchSevice: MKLocalSearchCompleterDelegate {
 
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
      
        completerResults = completer.results
        
        guard let completerResults = completerResults else { return }
        
        if !completerResults.isEmpty {
            debouncer.run { [weak self] in
                self?.places.removeAll()
                
                for completion in completerResults {
                    self?.search(for: completion)
                }
            }
            
        }
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
    
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        
        searchRequest.naturalLanguageQuery = suggestedCompletion.title
        
        search(using: searchRequest)
    }
    
   private func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
       
        searchRequest.naturalLanguageQuery = queryString
       
        search(using: searchRequest)
    }
    
    private func search(using searchRequest: MKLocalSearch.Request) {
        searchRequest.resultTypes = .pointOfInterest
    
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [weak self] response, error in
    
            guard let self = self,
                  let mapItems = response?.mapItems else { return }
            
            if !mapItems.isEmpty { 
                self.places.append(mapItems.first!)
            }
        }
    }
}
