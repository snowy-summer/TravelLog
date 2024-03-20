//
//  SearchLocationViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/18.
//

import MapKit

final class SearchLocationViewModel {
    
    var list: Observable<[LocationModel]> = Observable([])
    
}

extension SearchLocationViewModel {
    
    func appendLocationModel(mapitem: MKMapItem?) {
        let locationModel = LocationModel(mapItem: mapitem)
        list.value.append(locationModel)
    }
    
    func selectedLocation(id: UUID) -> LocationModel {
        let index = list.value.firstIndex { locationModel in
            locationModel.id == id
        }
        guard let index = index else { return LocationModel() }
        
        return list.value[index]
        
    }
    
    func openInMap(id: UUID) {
        let index = list.value.firstIndex { locationModel in
            locationModel.id == id
        }
        
        guard let index = index else { return }
        list.value[index].mapItem?.openInMaps()
    }
    
}
