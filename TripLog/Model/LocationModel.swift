//
//  MapModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/18.
//

import MapKit

struct LocationModel: Hashable,Identifiable {
    var id = UUID()
    var searchCompletion: MKLocalSearchCompletion?
    var mapItem: MKMapItem?
    
    
}
