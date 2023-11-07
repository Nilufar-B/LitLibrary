//
//  BooksAPI.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//

import Foundation

class BooksAPI: ObservableObject {
    
    @Published var books: [Book] = []
//    
//    func getBooks() async throws {
//        let baseURL = "https://www.googleapis.com/books/v1/volumes"
//        var urlComponents = URLComponents(string: baseURL)
//        urlComponents?.queryItems = [URLQueryItem(name: "q", value: "subject:fiction")]
//
//        guard let url = urlComponents?.url else {
//            throw APIErrors.invalidURL
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                throw APIErrors.invalidResponse
//            }
//
//            let decoder = JSONDecoder()
//            let booksResponse = try decoder.decode(BooksResponse.self, from: data)
//
//            Task {
//                self.books = booksResponse.results
//            }
//        } catch {
//            throw APIErrors.invalidData
//        }
//    }

    
    
    func getBooks() async throws {
        
       let endpoint = "https://www.googleapis.com/books/v1/volumes?q=subject:fiction"
        
        
        guard let url = URL(string: endpoint) else {throw APIErrors.invalidURL}
     
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
            
        } catch {
            throw APIErrors.invalidData
        }
        
        
    }
 
}

enum APIErrors: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}



