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
import SwiftUI

final class ImageLoader: ObservableObject {
    
    var willChange = PassthroughSubject<Data?, Never>()
    var data: Data? = nil {
        willSet {
            DispatchQueue.main.async {
                self.willChange.send(self.data)
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

struct ImageView: View {
    
    @State var image: UIImage = UIImage()

    init(withURL url: String) {
        imageLoader = ImageLoader(urlString:url)
        print("ImageURL: \(url)")
    }

    @ObservedObject private var imageLoader: ImageLoader
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                // .frame(width:100, height:100)
        }.onReceive(imageLoader.willChange) { data in
            self.image = UIImage(data: data!) ?? UIImage()
        }
    }
}
