//
//  MainView.swift
//  swiftui-traffic-cams
//
//  Created by Joona Heinikari on 17/02/2020.
//  Copyright © 2020 Joona Heinikari. All rights reserved.
//

import SwiftUI
import UIKit

struct MainView: View {
    
    @State private var cameraData = CameraData()
    @State private var searchID = ""
    @State private var presets = [CameraPreset]()
    @State private var stations = [CameraStation]()
    @State private var test = [1, 2, 3, 4, 5]
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            VStack {
                TextField("Search for camera", text: $searchID, onCommit: {
                    self.searchCameraById()
                }).textFieldStyle(RoundedBorderTextFieldStyle())
                
              NavigationView {
                    if (presets.count != 0) {
                        ForEach(presets, id: \.self) { preset in
                            VStack {
                                NavigationLink(destination: ContentView()) {
                                    Text(preset.presentationName ?? "hmmM")
                                }
                                
                                Text(String(self.presets.count))
                                Text(String(preset.id ?? "id"))
                            }
                        }
                    } else {
                        Text("Wait")
                    }
                    
                }
                
                 NavigationView {
                 VStack {
                    if (stations.count != 0) {
                        ForEach(self.stations, id: \.self) { station in
                            VStack {
                                NavigationLink(destination: ContentView()) {
                                    Text(station.id ?? "not found")
                                }
                                
                                Text("count: \(self.stations.count)")
                                Text("Station id: \(station.id ?? "id")")
                            }
                        }
                    } else {
                        Text("Wait")
                    }
                 }
                    
                }
                
                VStack {
                    ForEach(self.test, id: \.self) { num in
                                Text("Count \(self.test.count)")
                    }
                }
                
                Spacer()
                
            }.onAppear(perform: loadData)
        }.padding()
    }
    
    func makeList() {
        loadData()
        print("MAKELIST")
        let count = (cameraData.cameraStations?.count ?? 0)
        print("COUNT: \(count)")

        for station in cameraData.cameraStations! {
            self.stations.append(station)
            for preset in station.cameraPresets! {
                // print(preset.presentationName)
                self.presets.append(preset)
            }
        }
        
        print("stations, \(self.stations.count):", self.stations[0])
        print("presets, \(self.presets.count):", self.presets[0])
    }
    
    
    
    func searchCameraById() {
        print("ID: \($searchID)")
        makeList()
    }
    
    func loadData() {
        print("COUTNTNTNTNTNT: ", presets.count)
        
        guard let url = URL(string: "https://tie.digitraffic.fi/api/v1/data/camera-data/\($searchID.wrappedValue)")
        else {
            print("loading data failed..")
            print("URL: https://tie.digitraffic.fi/api/v1/data/camera-data\($searchID)")
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            print(response ?? "no response")
            
            if error != nil {
                print(error ?? "error in dataTask")
                return
            }
            
            do {
                let json = try JSONDecoder().decode(CameraData.self, from: data!)
                DispatchQueue.main.async { self.cameraData = json }
                // print("JSON data: ", json)
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
            }).resume()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

/* extension String: Identifiable {
    public var id: String {
        return self
    }
} */
