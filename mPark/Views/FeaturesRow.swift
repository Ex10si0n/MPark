//
//  FeaturesRow.swift
//  Landmarks
//
//  Created by Ex10si0n Yan on 9/29/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI
import CoreLocation
import MapKit

struct FeaturesRow: View {
    
    var landmark: Parking
    var coordinate: (lat: Double, lon: Double)
    var clCooridnate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lon)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(landmark.name)
                Text("\(Int(clCooridnate.distance(to: CLLocationCoordinate2D(latitude: landmark.locationCoordinate.latitude, longitude: landmark.locationCoordinate.longitude)))) m")
                HStack() {
                    Image(systemName: "car.fill")
                    Text("\(landmark.car)")
                    Image(systemName: "bicycle")
                    Text("\(landmark.motor)")
                    Spacer()
                }
            }
            Spacer()
            MapView(coordinate: landmark.locationCoordinate, name: landmark.name).frame(width: 100, height: 100, alignment: .bottom).ignoresSafeArea().allowsHitTesting(false)

        }.frame(height: 100)
    }
}

struct FeaturesRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeaturesRow(landmark: parkings[0], coordinate: (22.208183, 113.549278))
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
