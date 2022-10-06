/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that presents a map of a landmark.
*/

import SwiftUI
import MapKit

struct Place: Identifiable {
  let id = UUID()
  var name: String
  var coordinate: CLLocationCoordinate2D
}

struct MapView: View {

    var coordinate: CLLocationCoordinate2D
    var name: String
    
    @State private var region = MKCoordinateRegion()
    @State private var place = Place(name: "Apple Park", coordinate: CLLocationCoordinate2D(latitude: 37.3327, longitude: -122.0054))

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [place]) { place in
            MapPin(coordinate: place.coordinate, tint: .red)
        }.onAppear {
            setRegion(coordinate)
            setPlace(name, coordinate)
        }
    }

    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    }
    
    private func setPlace(_ name: String, _ coordinate: CLLocationCoordinate2D) {
        place = Place(name: name, coordinate: coordinate)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868), name: "Test Name")
    }
}
