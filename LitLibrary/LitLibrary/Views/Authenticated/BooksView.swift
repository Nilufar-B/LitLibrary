//
//  BooksView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//

import SwiftUI

struct BooksView: View {
    
    @ObservedObject var db: DBConnection
    @ObservedObject var booksApi: BooksAPI
    
    @State private var searchText = ""
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                LogoView()
              
                VStack{
             
                SearchBar(searchText: $searchText)
                    
                List() {
                    
                    ForEach(booksApi.books) { book in
                        AsyncImage(url: URL(string: book.volumeInfo.imageLinks?.thumbnail ?? ""), content: {image in
                            
                            HStack {
                                image
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.2, alignment: .center)
                                    .cornerRadius(10)
                                
                                VStack {
                                    
                                    Text(book.volumeInfo.title)
                                        .bold()
                                    Text(book.volumeInfo.description.prefix(150) + "...")
                                    
                                    
                                }
                                
                            }
                            
                            
                        }, placeholder: {
                            ProgressView()
                        })
                    }
                    
                }
              
                }  .task {
                    do {
                        try await booksApi.getBooks()
                    } catch APIErrors.invalidData {
                        print("Invalid Data")
                    } catch APIErrors.invalidURL {
                        print("Invalid Url")
                    } catch APIErrors.invalidResponse {
                        print("Invalid Response")
                    } catch {
                        print("General error")
                    }
                }
            
            }
           // .frame(width: geometry.size.width, height: geometry.size.height)
        
            
        }
    }
}

#Preview {
    BooksView(db: DBConnection(), booksApi: BooksAPI())
}
