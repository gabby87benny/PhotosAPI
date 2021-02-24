//
//  ViewController.swift
//  TestPhotosApp
//
//  Created by Gabriel on 2/24/21.
//

import UIKit
import PhotosAPI

class ViewController: UIViewController {
    let apiManager = APIManager()
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
    }

    func fetchPhotos() {
        //Testing the API Manager
        self.apiManager.fetchPhotos { (result) in
            switch result {
            case .success(let photos):
                self.photos = photos
                print("Photos count: \(photos.count)")

            case .failure(let error):
                print("The photo fetch is failure: \(error)")
            }
        }
    }
}

