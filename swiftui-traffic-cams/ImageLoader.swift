//
//  ImageLoader.swift
//  swiftui-traffic-cams
//
//  Created by Joona Heinikari on 14/02/2020.
//  Copyright © 2020 Joona Heinikari. All rights reserved.
//

// TODO -> fetches image, but does not update the view

import Combine // import PassthroughSubject
import Foundation

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self.data)
            }
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else {
            print("Error fetching image..")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}
