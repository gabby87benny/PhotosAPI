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

public class APIManager {
    lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        let nUrlSession = URLSession(configuration: config)
        return nUrlSession
    }()
    
    public init() {
        
    }
    
    var pError = PhotosError.PhotosErrorNone
    
    /**
    Fetches photos from Photos API.

    - Parameters:
       - completion: The completion handler to be fired once the operations are over
     
    - Returns: None.
    */
    
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
    
    /**
    Parses the data using JSON Decoder.

    - Parameters:
       - data: The data to be parsed
     
    - Returns: An optional Photo model.
    */
    
    private func parseData(_ data: Data) -> [Photo]? {
                
        do {
            let photos = try JSONDecoder().decode([Photo].self, from: data)
            return photos
        } catch  {
            print("Json parsing has failed")
            return nil
            
        }
        
    }
    
    /**
    Validates if the response is valid.

    - Parameters:
       - optionalResponse: The url response obtained from the request
     
    - Returns: A Boolean that indicates if the response is valid.
    */
    
    private func isValidResponse(optionalResponse: URLResponse?) -> Bool {
        guard let response = optionalResponse as? HTTPURLResponse, response.statusCode == 200 else { return false }
        return true
    }
}

