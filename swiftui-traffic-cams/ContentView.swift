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
    
    var body: some View {
        
        ZStack (alignment: .top) {
            VStack {
                Text(cameraPreset.presentationName ?? "loading..").font(.largeTitle)

                ImageView(withURL: cameraPreset.imageUrl ?? "https://upload.wikimedia.org/wikipedia/fi/4/4f/Cheek_-_Kuka_sä_oot2.jpg")
                    .padding()
                Text((cameraPreset.imageUrl ?? "loading.."))
                }
            Spacer()
            }
        }
   }
