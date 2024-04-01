//
//  MapModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/18.
//

import MapKit

struct LocationModel: Identifiable {
    var id = UUID()
    var mapItem: MKMapItem?
        
}

extension LocationModel: Hashable {
    
    static func == (lhs: LocationModel, rhs: LocationModel) -> Bool {
        lhs.id.hashValue == rhs.id.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
