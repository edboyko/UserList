//
//  ImageProvider.swift
//  UserList
//
//  Created by Edwin Boyko on 06/12/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit

class ImageProvider {
    
    private var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager(urlSession: URLSession.shared)
    }
    
    func getImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        networkManager.loadData(url: url) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            }
            else if let error = error{
                print("Error downloading image:", error.localizedDescription)
            }
        }
    }
    
    func stopImageDownload() {
        networkManager.cancel()
    }
}
