//
//  ModelParking.swift
//  Landmarks
//
//  Created by Ex10si0n Yan on 9/28/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation

var parkings: [Parking] = load("parkings.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


func getData(completion: @escaping ([Parking]) -> ()) {

    var request = URLRequest(url: URL(string: "https://ios-dev.shortcutsapi.com/parking-info/parking-info-macau-ios-dev")!)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        
        var parsedParkings: [Parking]
        do {
            parsedParkings = try JSONDecoder().decode(Response.self, from: data).data
            DispatchQueue.main.async {
                completion(parsedParkings)
            }
        }
        catch {
            print("Failed to parse parkings")
        }

    }
    task.resume()
}
