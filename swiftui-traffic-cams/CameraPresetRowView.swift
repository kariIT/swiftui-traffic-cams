//
//  cameraPresetRowView.swift
//  swiftui-traffic-cams
//
//  Created by Joona Heinikari on 21/02/2020.
//  Copyright © 2020 Joona Heinikari. All rights reserved.
//

import SwiftUI

struct CameraPresetRowView: View {
    var preset: CameraPreset
    var body: some View {
        HStack {
            Image("dome").resizable().frame(width: 30, height: 30)
            Text(preset.presentationName ?? "presentation name not found")
            Text(String(preset.id ?? "id"))
        }
    }
}
