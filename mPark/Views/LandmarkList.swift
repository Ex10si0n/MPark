/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import SwiftUI
import Combine
import CoreLocation
import MapKit


struct LandmarkList: View {
    @State var realParkings: [Parking] = []
    @StateObject var deviceLocationService = DeviceLocationService.shared
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (22.208183, 113.549278)
    
    var clCooridnate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.coordinates.lat, longitude: self.coordinates.lon)
    }
    
    var body: some View {
        NavigationView {
            List(realParkings) { landmark in
                NavigationLink {
                    LandmarkDetail(landmark: landmark)
                } label: {
                    LandmarkRow(landmark: landmark, coordinate: coordinates)
                }
            }
            .navigationTitle("MPark")
            .toolbar{
                Button(action: {
                    observeCoordinateUpdates()
                    observeDeniedLocationAccess()
                    deviceLocationService.requestLocationUpdates()
                }) {
                    Image(systemName: "location.fill")
                }
            }
        }.onAppear {
            observeCoordinateUpdates()
            observeDeniedLocationAccess()
            deviceLocationService.requestLocationUpdates()
            getData() { (parkings) in
                // sort parkings by distance to user
                self.realParkings = parkings.sorted { (parking1, parking2) -> Bool in
                    let distance1 = self.clCooridnate.distance(to: CLLocationCoordinate2D(latitude: parking1.locationCoordinate.latitude, longitude: parking1.locationCoordinate.longitude))
                    
                    let distance2 = self.clCooridnate.distance(to: CLLocationCoordinate2D(latitude: parking2.locationCoordinate.latitude, longitude: parking2.locationCoordinate.longitude))
                    return distance1 < distance2
                }
            }
        }
    }
    
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }
    
    func observeDeniedLocationAccess() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Handle access denied event, possibly with an alert.")
            }
            .store(in: &tokens)
    }
    
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone XS Max"], id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
