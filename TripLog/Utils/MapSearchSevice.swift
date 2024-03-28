//
//  MapSearchSevice.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/19.
//

import MapKit

protocol MapSearchSeviceDelegate: AnyObject {
    
    func appendLocationModel(mapitem: MKMapItem?)
    func clearPlaces()
}

final class MapSearchSevice: NSObject {
    
    weak var delegate: MapSearchSeviceDelegate?
    
    private let debouncer = Debouncer(seconds: 0.5)
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion = MKCoordinateRegion(MKMapRect.world)
    private var completerResults: [MKLocalSearchCompletion]?
    private var localSearch: MKLocalSearch?
    
    private var places = [MKMapItem]() {
        didSet {
            delegate?.clearPlaces()
            
            for place in places {
                delegate?.appendLocationModel(mapitem: place)
            }
            
        }
    }
    
   override init() {
        super.init()
        
        configureSearchCompleter()
    }

    private func configureSearchCompleter() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .pointOfInterest
        searchCompleter?.region = searchRegion
    }

    func upadteCompleterResults(results: [MKLocalSearchCompletion]?) {
        completerResults = results
    }
    
    func updateCompleter(query: String) {
        searchCompleter?.queryFragment = query
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
    
    func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        
        searchRequest.naturalLanguageQuery = suggestedCompletion.title
        
        search(using: searchRequest)
    }
    
    func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
       
        searchRequest.naturalLanguageQuery = queryString
       
        search(using: searchRequest)
    }
    
    func search(using searchRequest: MKLocalSearch.Request) {
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
