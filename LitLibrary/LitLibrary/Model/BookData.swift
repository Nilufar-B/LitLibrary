//
//  BookData.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//

import Foundation


struct Book:  Identifiable, Codable{
    var id: String
    var volumeInfo: VolumeInfo?
}

struct VolumeInfo: Codable {
    var title: String?
    var authors: [String]?
    var categories: [String]?
    var description: String?
    var imageLinks: ImageLinks?
    let canonicalVolumeLink: String?
}

struct ImageLinks : Codable {
    var thumbnail: String?
    var smallThumbnail: String?
}

struct BooksResponse: Codable {
    var items: [Book]
}





