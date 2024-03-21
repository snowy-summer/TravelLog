//
//  MapSearchSevice.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/19.
//

import MapKit

final class MapSearchSevice: NSObject {
    
    private var locationViewModel: SearchLocationViewModel?
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
        
        print("MapSearchService 생성")
    }
    
    deinit {
        print("MapSearchService 해제")
    }
    
    private func configureSearchCompleter() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .pointOfInterest
        searchCompleter?.region = searchRegion
    }
    
    func de() {
        searchCompleter = nil
    }
}

extension MapSearchSevice: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if searchText == "" {
            completerResults = nil
        }
    
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
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
            places.removeAll()
            
            for completion in completerResults {
                search(for: completion)
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
    
    //문자 기반 검색 실행
   private func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
       
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
            
            if !mapItems.isEmpty { 
                self.places.append(mapItems.first!)
            }
        }
    }
}
