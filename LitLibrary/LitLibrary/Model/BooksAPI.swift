//
//  BooksAPI.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//

import Foundation


class BooksAPI: ObservableObject {
    
    @Published var books: [Book] = []
    @Published var searchText: String = ""
    
    func getBooks(forTag tag: String) async throws {
        let API_KEY = "AIzaSyBizhlE4qjjNcMTYMDGTp9JmLM7xmIn7SM"
        let endpoint = "https://www.googleapis.com/books/v1/volumes?q=subject:\(tag.lowercased())&maxResults=40&key=\(API_KEY)"
        
        guard let url = URL(string: endpoint) else { throw APIErrors.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIErrors.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            let booksResponse = try decoder.decode(BooksResponse.self, from: data)
            
            DispatchQueue.main.sync {
                self.books = booksResponse.items
            }
            
        } catch let error {
            print("ERROR:: \(error)")
            throw APIErrors.invalidData
        }
    }
}


enum APIErrors: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}



