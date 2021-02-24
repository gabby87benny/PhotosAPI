//
//  APIManager.swift
//  PhotosApp
//
//  Created by Gabriel on 2/23/21.
//

import Foundation

struct APIManagerConstants {
    static let url = "https://jsonplaceholder.typicode.com/photos"
}

public enum PhotosError: Error {
    case PhotosErrorNone
    case PhotosErrorServer
}

public enum Result {
    case success([Photo])
    case failure(Error)
}

typealias QueryResult = (Result) -> ()

public class APIManager {
    lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        let nUrlSession = URLSession(configuration: config)
        return nUrlSession
    }()
    
    public init() {
        
    }
    
    var pError = PhotosError.PhotosErrorNone
    
    public func fetchPhotos(completion: @escaping (Result) -> ()) {
        
        guard let url = URL(string: APIManagerConstants.url) else {
            completion(.failure(PhotosError.PhotosErrorServer))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (optionalData, optionalResponse, optionalError) in
            guard let strongRef = self else {
                DispatchQueue.main.async {
                    completion(.failure(PhotosError.PhotosErrorServer))
                }
                return
            }
            
            guard optionalError == nil,
                  strongRef.isValidResponse(optionalResponse: optionalResponse),
                  let data = optionalData else {
                DispatchQueue.main.async {
                    completion(.failure(PhotosError.PhotosErrorServer))
                }
                return
            }
            
            if let photos = self?.parseData(data) {
                DispatchQueue.main.async {
                    completion(.success(photos))
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(.failure(PhotosError.PhotosErrorServer))
                }
            }
        }.resume()

    }
    
    private func parseData(_ data: Data) -> [Photo]? {
                
        do {
            let photos = try JSONDecoder().decode([Photo].self, from: data)
            return photos
        } catch  {
            print("Json parsing has failed")
            return nil
            
        }
        
    }
    
    private func isValidResponse(optionalResponse: URLResponse?) -> Bool {
        guard let response = optionalResponse as? HTTPURLResponse, response.statusCode == 200 else { return false }
        return true
    }
}

