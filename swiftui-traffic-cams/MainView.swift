//
//  MainView.swift
//  swiftui-traffic-cams
//
//  Created by Joona Heinikari on 17/02/2020.
//  Copyright © 2020 Joona Heinikari. All rights reserved.
//

import SwiftUI


struct MainView: View {
    
    @State private var cameraData = CameraData()
    @State private var searchID = ""
    @State private var presets = [CameraPreset]()
    @State private var stations = [CameraStation]()
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            VStack {
                TextField("Search for a station", text: $searchID, onCommit: {
                    self.searchCameraById()
                }).textFieldStyle(RoundedBorderTextFieldStyle())
                
              NavigationView {
                    ScrollView {
                        VStack {
                            if (presets.count != 0) {
                                ForEach(presets, id: \.self) { preset in
                                    HStack {
                                        // Image("placeholder_small")
                                        // ImageView(withURL: preset.imageUrl ?? "use preset image as preview")
                                        NavigationLink(destination: ContentView(cameraPreset: preset)) {
                                            CameraPresetRowView(preset: preset)
                                        }.buttonStyle(PlainButtonStyle())
                                    }
                                }
                            } else {
                                Text("Search for station")
                            }
                        }
                    }
                }
                  
                Spacer()
                
            }// .onAppear(perform: loadData)
        }.padding()
    }
    
    func makeList() {
        print("makelist called!")
        /* if cameraData exists, clear stations and presets before fetching them again */
        if (cameraData.cameraStations != nil) {
            print("makelist cameradata exists")
            self.presets.removeAll()
            self.stations.removeAll()
            
            // fetch stations and presets from data
            for station in cameraData.cameraStations! {
                print("station: " + station.id!)
                self.stations.append(station)
                
                for preset in station.cameraPresets! {
                    self.presets.append(preset)
                }
            }
        } else {
            print("makelist no data")
        }
    }
    
    
    
    func searchCameraById() {
        print("ID: \($searchID)")
        loadData()
    }
    
    func loadData() {
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
            } catch {
                print("Error decoding JSON: \(error)")
            }
            }).resume()
        
        print("after -> making list..")
        self.makeList()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
