//
//  Parking.swift
//  Landmarks
//
//  Created by Ex10si0n Yan on 9/28/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

struct Response: Hashable, Codable {
    let status: Int
    let data: [Parking]
}


struct Parking: Hashable, Codable, Identifiable {
    
    var id: Int
    var name: String
    var car: Int
    var motor: Int
    var address: String

    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.lat,
            longitude: coordinates.lng)
    }

    struct Coordinates: Hashable, Codable {
        var lat: Double
        var lng: Double
    }
}
