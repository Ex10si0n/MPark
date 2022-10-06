/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A single row to be displayed in a list of landmarks.
*/

import SwiftUI
import CoreLocation
import MapKit

extension CLLocationCoordinate2D {

    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        MKMapPoint(self).distance(to: MKMapPoint(to))
    }

}

struct LandmarkRow: View {
    var landmark: Parking
    var coordinate: (lat: Double, lon: Double)
    var clCooridnate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lon)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(landmark.name)
                HStack() {
                    Image(systemName: "car.fill")
                    Text("\(landmark.car)")
                    Image(systemName: "bicycle")
                    Text("\(landmark.motor)")
                    Spacer()
                    Image(systemName: "mappin.and.ellipse")
                    Text("\(Int(clCooridnate.distance(to: CLLocationCoordinate2D(latitude: landmark.locationCoordinate.latitude, longitude: landmark.locationCoordinate.longitude)))) m")
                }
            }
            Spacer()
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LandmarkRow(landmark: parkings[0], coordinate: (22.208183, 113.549278))
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
