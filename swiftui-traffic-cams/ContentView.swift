//
//  ContentView.swift
//  swiftui-traffic-cams
//
//  Created by Joona Heinikari on 14/02/2020.
//  Copyright © 2020 Joona Heinikari. All rights reserved.
//

import SwiftUI
import Foundation
import UIKit
import Combine

struct ContentView: View {
    
    @State private var cameraData = CameraData()
    
    
    var body: some View {
        
        ZStack {
            VStack {
                Text("Hello World")
                ImageView(withURL: cameraData.cameraStations?[0].cameraPresets?[0].imageUrl ?? "https://weathercam.digitraffic.fi/C0150200.jpg")
                
                Text("Image: \(cameraData.cameraStations?[0].cameraPresets?[0].imageUrl ?? "no data")")
            }
        }.onAppear(perform: loadData)
        

    }
    
    func loadData() {
        guard let url = URL(string: "https://tie.digitraffic.fi/api/v1/data/camera-data/C01502")
        else {
            print("loading data failed..")
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
                print("Data type: ", type(of: data))
                let json = try JSONDecoder().decode(CameraData.self, from: data!)
                
                DispatchQueue.main.async {
                    self.cameraData = json
                }
                
                print("JSON data: ", json)
            } catch {
                print("Error decoding JSON: \(error)")
            }
            }).resume()
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
