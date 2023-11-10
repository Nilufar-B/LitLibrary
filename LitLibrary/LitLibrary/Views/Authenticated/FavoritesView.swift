//
//  FavoritesView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-11-01.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var db: DBConnection
    @ObservedObject var booksApi: BooksAPI
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                LogoView()
           
                
                List {
                    ForEach(db.favoriteBooks, id: \.self) { bookId in
                        if let book = booksApi.books.first(where: { $0.id == bookId }) {
                            // Display each favorite book using your desired UI components
                            BookRowView(book: book, geometry: geometry)
                        }
                    }
                }
                .navigationTitle("Favorites")
            }
            .onAppear {
                // Fetch favorite books when the view appears
                db.fetchFavoriteBooks()
            }
        }
    }
    
    struct BookRowView: View {
        var book: Book
        var geometry: GeometryProxy
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text(book.volumeInfo?.title ?? "")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    if let authors = book.volumeInfo?.authors {
                        Text("By " + authors.joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    if let categories = book.volumeInfo?.categories {
                        Text("Categories: " + categories.joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(20)
                .frame(width: geometry.size.width / 2, height: geometry.size.height * 0.18)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                }
                .zIndex(1)
                
                if let smallThumbnail = book.volumeInfo?.imageLinks?.smallThumbnail,
                   let url = URL(string: smallThumbnail) {
                    AsyncImage(url: url, content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.18, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(color: .black.opacity(0.01), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.01), radius: 5, x: -5, y: -5)
                    }, placeholder: {
                        ProgressView()
                    })
                }
            }
        }
    }
}

#Preview {
    FavoritesView(db: DBConnection(), booksApi: BooksAPI())
}
