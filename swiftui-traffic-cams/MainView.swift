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
    @State private var drawlist = true
    @State private var contentViewActive = false
    @State private var searchPreset = CameraPreset()
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            HStack (alignment: .top) {
                
                NavigationView {
                    VStack (alignment: .leading) {
                        
                        TextField("Search for a station, f.e. C01502", text: $searchID, onCommit: {
                         self.searchCameraById()
                         }).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                        
                        if (contentViewActive) {
                            Button(action: { self.contentViewActive = false }) {
                                Text("Back")
                            }.padding()
                            ContentView(cameraPreset: searchPreset)
                        } else {
                            ScrollView (showsIndicators: true) {
                                VStack (alignment: .leading) {
                                    ForEach(presets, id: \.self) { preset in
                                        NavigationLink(destination: ContentView(cameraPreset: preset)) {
                                            CameraPresetRowView(preset: preset)
                                        }.buttonStyle(PlainButtonStyle())
                                    }
                                }.padding()
                            }
                        }
                        Spacer()
                    }
                        
                    .navigationBarTitle("Cameras")
                }
            }.onAppear(perform: loadData)
        }
    }
    
    func prepareData() {
        var i = 0
        /* if cameraData exists, clear stations and presets before fetching them again */
        if (cameraData.cameraStations != nil) {
           print("cameradata exists")
           self.presets.removeAll()
           self.stations.removeAll()
        
           // fetch stations and presets from data
           for station in cameraData.cameraStations! {
               self.stations.append(station)
            
                if (i == 30) { break }
                i += 1
               
               for preset in station.cameraPresets! {
                   if (preset.presentationName != nil) {
                       self.presets.append(preset)
                   }
               }
           }
       } else {
           print("no data")
       }
    }
    
    func makeList() {
        prepareData()
        self.drawlist = true
    }
    
    
    
    func searchCameraById() {
        var found = false
        print("ID: \($searchID)")
        if (presets.count != 0) {
            for preset in presets {
                if (searchID == preset.id) {
                    found = true
                    print(preset.presentationName ?? "not found")
                    self.searchPreset = preset
                    contentViewActive = true
                }
            }
        } else {
            print("no presets found")
        }
        
        if (found) {
            print("preset found!")
        } else {
            print("preset not found!")
        }
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
                DispatchQueue.main.async { self.cameraData = json
                    self.prepareData()
                }
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
