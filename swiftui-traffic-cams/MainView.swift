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
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            VStack {
                TextField("Search for camera", text: $searchID, onCommit: {
                    self.searchCameraById()
                }).textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                
            }.onAppear(perform: loadData)
        }.padding()
    }
    
    func makeList() {
        loadData()
        print("MAKELIST")
        let count = (cameraData.cameraStations?.count ?? 0)
        print("COUNT: \(count)")
        for i in 0...10 { //count.hashValue
            print("Index: \(i) Camera: ", cameraData.cameraStations?[i].id ?? "null")
            // for i in 0...cameraData.cameraStations?[i].cameraPresets?.count {
                
           // }
        }
    }
    
    func searchCameraById() {
        print("ID: \($searchID)")
        makeList()
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
