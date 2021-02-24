//
//  Photo.swift
//  PhotosApp
//
//  Created by Gabriel on 2/23/21.
//

import Foundation

public struct Photo: Codable {
    public var albumId: Int
    public var id: Int
    public var title: String
    public var url: String
    public var thumbnailUrl: String
}
