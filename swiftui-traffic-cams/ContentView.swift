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
    
    var cameraPreset: CameraPreset
    
    @State private var cameraData = CameraData()
    @State private var search = "C01504"
    
    
    var body: some View {
        
        ZStack {
            VStack {
                Text(cameraPreset.presentationName ?? "loading..")

                ImageView(withURL: cameraPreset.imageUrl ?? "https://upload.wikimedia.org/wikipedia/fi/4/4f/Cheek_-_Kuka_sä_oot2.jpg")
                Text("Image: " + (cameraPreset.imageUrl ?? "loading.."))
                }
            }
        }// .onAppear(perform: loadData)
        

   }
    
   /* func searchCamera() {
        print("search: \($search)")
        // loadData()
    }
    
    func loadData() {
        guard let url = URL(string: "https://tie.digitraffic.fi/api/v1/data/camera-data/\($search.wrappedValue)")
        else {
            print("loading data failed..")
            print("URL: https://tie.digitraffic.fi/api/v1/data/camera-data\($search)")
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
                
                // print("JSON data: ", json)
            } catch {
                print("Error decoding JSON: \(error)")
            }
            }).resume()
    } */
    

// }

/* struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(cameraPreset: CameraPreset)
    }
} */
