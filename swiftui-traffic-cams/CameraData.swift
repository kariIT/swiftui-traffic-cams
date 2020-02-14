//
//  CameraData.swift
//  swiftui-traffic-cams
//
//  Created by Joona Heinikari on 14/02/2020.
//  Copyright © 2020 Joona Heinikari. All rights reserved.
//

import SwiftUI
import Foundation

struct CameraData: Codable {
    var id: Int?
    var cameraUpdatedTime: String?
    var cameraStations: [CameraStation]?
}

struct CameraStation: Codable {
    var id: String?
    var roadStationId: Int?
    var nearestWeatherStationId: Int?
    var cameraPresets: [CameraPreset]?
}

struct CameraPreset: Codable {
    var id: String?
    var presentationName: String?
    var imageUrl: String?
    var measuredTime: String?
}
