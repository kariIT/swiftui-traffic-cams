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
    @State private var drawlist = false
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
                            ContentView(cameraPreset: searchPreset)
                        } else {
                            ScrollView {
                                VStack (alignment: .leading) {
                                    if (self.drawlist == true) {
                                        ForEach(presets, id: \.self) { preset in
                                            HStack {
                                                NavigationLink(destination: ContentView(cameraPreset: preset)) {
                                                    CameraPresetRowView(preset: preset)
                                                }.buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                    } else {
                                        Button(action: self.makeList) {
                                            Text("Get stations")
                                                .padding(10)
                                                .background(Color.blue)
                                                .foregroundColor(Color.black)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .stroke(Color.black, lineWidth: 2)
                                            )
                                        }
                                    }
                                }.padding()
                            }
                        }
                        Spacer()
                    }.border(Color.red)
                        
                    .navigationBarTitle("Cameras")
                    Spacer()
                }.border(Color.blue)
            }.onAppear(perform: loadData)
        }
    }
    
    func prepareData() {
        /* if cameraData exists, clear stations and presets before fetching them again */
       if (cameraData.cameraStations != nil) {
           print("cameradata exists")
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
           print("no data")
       }
    }
    
    func makeList() {
        print("makelist called!")
        
        /* if cameraData exists, clear stations and presets before fetching them again */
        if (cameraData.cameraStations != nil) {
            print("makelist cameradata exists")
            self.drawlist = false
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
            
            self.drawlist = true
        } else {
            print("makelist no data")
        }
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
