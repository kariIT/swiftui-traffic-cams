//
//  CameraData.swift
//  swiftui-traffic-cams
//
//  Created by Joona Heinikari on 14/02/2020.
//  Copyright © 2020 Joona Heinikari. All rights reserved.
//

import SwiftUI
import Foundation

struct CameraData {
    var id: Int?
    var cameraUpdatedTime: String?
    var cameraStations: [CameraStation]?
}

struct CameraStation {
    var id: Int?
    var roadStationId: Int?
    var nearestWeatherStationId: Int?
    var cameraPresets: [CameraPreset]?
}

struct CameraPreset {
    var id: String?
    var presentationName: String?
    var imageUrl: String?
    var measuredTime: String?
}
