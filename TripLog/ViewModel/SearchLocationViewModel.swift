//
//  SearchLocationViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/18.
//

import MapKit

final class SearchLocationViewModel {
    
    var list: Observable<[LocationModel]> = Observable([])
    var savedLocation: Observable<LocationModel> = Observable<LocationModel>(LocationModel())
    
    var savedLocationMapItem: MKMapItem? {
        savedLocation.value.mapItem
    }
    
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
    
    func mapCoordinate(id: UUID) -> CLLocationCoordinate2D? {
        selectedLocation(id: id).mapItem?.placemark.coordinate
    }
    
    func mapCoordinate(location: LocationModel) -> CLLocationCoordinate2D? {
        location.mapItem?.placemark.coordinate
    }
    
}

extension SearchLocationViewModel {
    
    func updateSavedLocation(location: LocationModel) {
        savedLocation.value = location
    }
    
    func updateSavedLocationMapItem(mapItem: MKMapItem?) {
        savedLocation.value.mapItem = mapItem
    }
    
    func openInMap() {
       savedLocationMapItem?.openInMaps()
    }
    
    
}
