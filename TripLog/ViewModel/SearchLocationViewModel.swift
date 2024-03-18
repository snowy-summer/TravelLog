//
//  SearchLocationViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/18.
//

import MapKit

final class SearchLocationViewModel {
    
    var list: Observable<[LocationModel]> = Observable([])
    
    
    func appendLocationModel(completion: MKLocalSearchCompletion, mapitem: MKMapItem?) {
        let locationModel = LocationModel(searchCompletion: completion, mapItem: mapitem)
        list.value.append(locationModel)
    }
    
    func appendLocationModel(mapitem: MKMapItem) {
        
    }
    
    
    

}
