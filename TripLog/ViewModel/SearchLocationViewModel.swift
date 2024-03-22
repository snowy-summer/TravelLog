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
    
    deinit {
        print("viewModel 해제")
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
    
    func openInMap(id: UUID) {
        selectedLocation(id: id).mapItem?.openInMaps()
    }
    
    func mapCoordinate(id: UUID) -> CLLocationCoordinate2D? {
        selectedLocation(id: id).mapItem?.placemark.coordinate
    }
    
    func mapCoordinate(location: LocationModel) -> CLLocationCoordinate2D? {
        location.mapItem?.placemark.coordinate
    }
    
    func changeSavedLocation(location: LocationModel) {
        savedLocation.value = location
        print(savedLocation.value)
    }

}
