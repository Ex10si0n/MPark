/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a landmark.
*/

import SwiftUI
import MapKit
import Foundation

struct LandmarkDetail: View {
    var landmark: Parking

    var body: some View {
        ScrollView {
            MapView(coordinate: landmark.locationCoordinate, name: landmark.name)
                .ignoresSafeArea(edges: .top)
                .frame(height: 450)

            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name).font(.title)
                    Spacer()
                    Button(action: {
                        let latitude: CLLocationDegrees = landmark.locationCoordinate.latitude
                        let longitude: CLLocationDegrees = landmark.locationCoordinate.longitude
                        let regionDistance:CLLocationDistance = 1000
                        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                        let options = [
                            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                        ]
                        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                        let mapItem = MKMapItem(placemark: placemark)
                        mapItem.name = landmark.name
                        mapItem.openInMaps(launchOptions: options)
                    }) {
                        Text("Open in")
                        Image(systemName: "map.fill")
                    }
                }

                HStack {
                    Text(landmark.address)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Divider()

                HStack {
                    Image(systemName: "car.fill").font(.title)
                    Text("\(landmark.car)").font(.title)
                    Spacer()
                    Image(systemName: "bicycle").font(.title)
                    Text("\(landmark.motor)").font(.title)
                }
            }
            .padding()
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail(landmark: parkings[0])
    }
}
