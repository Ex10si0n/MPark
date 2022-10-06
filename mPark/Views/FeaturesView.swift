//
//  FeaturesView.swift
//  Landmarks
//
//  Created by Ex10si0n Yan on 9/29/22.
//  Copyright © 2022 Apple. All rights reserved.
//


import SwiftUI
import Combine
import CoreLocation
import MapKit
import AVFoundation


struct FeaturesView: View {
    @State var featuredParkings: [Parking] = []
    @StateObject var deviceLocationService = DeviceLocationService.shared
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (22.208183, 113.549278)
    @State var utterance = AVSpeechUtterance()
    @State var synthesizer = AVSpeechSynthesizer()
    
    var clCooridnate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.coordinates.lat, longitude: self.coordinates.lon)
    }
    
    var body: some View {
        let list = NavigationView {
            VStack {
                List(featuredParkings) { landmark in
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)
                    } label: {
                        FeaturesRow(landmark: landmark, coordinate: coordinates)
                    }
                }
                .navigationTitle("Featured Parkings")
                .toolbar{
                    Button(action: {
                        let speechContent = self.featuredParkings.map { $0.name + ": 私家车车位" + ($0.car >= 10 ? "充足" : "少量") + ": 单车车位" + ($0.motor >= 10 ? "充足" : "少量") }.joined(separator: ", ")
                        utterance = .init(string: speechContent)
                        let speechVoice = AVSpeechSynthesisVoice(language: "zh-HK")
                        utterance.voice = speechVoice
                        utterance.rate = 0.55
                        synthesizer.speak(utterance)
                    }) {
                        Text("播報")
                        Image(systemName: "ellipsis.bubble")
                    }
                }
            }
        }.onAppear {
            observeCoordinateUpdates()
            observeDeniedLocationAccess()
            deviceLocationService.requestLocationUpdates()
            getData() { (parkings) in
                self.featuredParkings = parkings.sorted { (parking1, parking2) -> Bool in
                    let distance1 = self.clCooridnate.distance(to: CLLocationCoordinate2D(latitude: parking1.locationCoordinate.latitude, longitude: parking1.locationCoordinate.longitude))
                    
                    let distance2 = self.clCooridnate.distance(to: CLLocationCoordinate2D(latitude: parking2.locationCoordinate.latitude, longitude: parking2.locationCoordinate.longitude))
                    return distance1 < distance2
                }.filter { (parking) -> Bool in
                    return parking.motor > 0 && parking.car > 0
                }
                self.featuredParkings = Array(self.featuredParkings[...3])
            }
        }
        VStack {
            list
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

struct FeaturesView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone XS Max"], id: \.self) { deviceName in
            FeaturesView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
