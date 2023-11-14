//
//  BookDetailView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-11-07.
//

import SwiftUI

struct BookDetailView: View {
    
    
    @ObservedObject var db: DBConnection
    @ObservedObject var booksApi: BooksAPI
    
    @Binding var show: Book?
    var animation: Namespace.ID
    var book: Book
    @State private var animationContent = false
    @State private var offsetAnimation = false
    @State private var isFavorite = false
    
    
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                
                LogoView()
                
                VStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)){
                            offsetAnimation = false
                        }
                        withAnimation(.easeInOut(duration: 0.3)){
                            animationContent = false
                            show = nil
                        }
                        
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .contentShape(Rectangle())
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                   // .padding()
                   // .opacity(animationContent ? 1 : 0)
                    
                    GeometryReader {
                        let size = $0.size
                        
                        HStack(spacing: 20) {
                            if let thumbnailURLString = book.volumeInfo?.imageLinks?.thumbnail,
                               let thumbnailURL = URL(string: thumbnailURLString) {
                                AsyncImage(url: thumbnailURL) { phase in
                                    if case .success(let image) = phase {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: (size.width - 30) / 2, height: size.height)
                                            .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 20))
                                            .matchedGeometryEffect(id: book.id, in: animation)
                                            .padding(.leading, 10)
                                    } else {
                                        // Handle failure, empty, or unknown state
                                        Text("Failed to load image")
                                            .frame(width: (size.width - 30) / 2, height: size.height)
                                            .background(Color.gray) // Placeholder color
                                            .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 20))
                                            .matchedGeometryEffect(id: book.id, in: animation)
                                    }
                                }
                            } else {
                                Rectangle()
                                    .frame(width: (size.width - 30) / 2, height: size.height)
                                    .background(Color.gray) // Placeholder color
                                    .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 20))
                                    .matchedGeometryEffect(id: book.id, in: animation)
                            }

                            
                            //book details
                            VStack(alignment: .leading, spacing: 8) {
                                Text(book.volumeInfo?.title ?? "Unknown")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Text("By " + (book.volumeInfo?.authors?.joined(separator: ", ") ?? ""))
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                VStack(spacing: 10){
                                    Button(action: {
                                        toggleFavorite()
                                    }, label: {
                                        Label("Favorite", systemImage: isFavorite ? "suit.heart.fill" : "suit.heart")
                                            .font(.callout)
                                            .foregroundColor(isFavorite ? .red : .gray)
                                    })
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 20)
                                    Button(action: {
                                        if let previewLink = book.volumeInfo?.previewLink, let url = URL(string: previewLink) {
                                            UIApplication.shared.open(url)
                                        }
                                    }, label: {
                                        Label("Read now", systemImage: "book")
                                            .font(.callout)
                                            .foregroundColor(.gray)
                                    })
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom, 15)
                                }
                            }
                            .padding(.trailing, 15)
                            .padding(.top, 30)
                        }
                        .onAppear {
                            // Set isFavorite based on whether the book is in favorites
                            isFavorite = db.isBookInFavorites(bookId: book.id)
                            }
                    }
                    .frame(height: 220)
                    //placing above
                    .zIndex(1)
                    
                    Rectangle()
                        .fill(.gray.opacity(0.04))
                        .ignoresSafeArea()
                        .overlay(alignment: .top) {
                            BookDetails()
                        }
                        .padding(.leading, 30)
                        .padding(.top, -180)
                        .zIndex(0)
                        .opacity(animationContent ? 1 : 0)

                                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding()
                .background{
                    Rectangle()
                        .fill(.white)
                        .ignoresSafeArea()
                        .opacity(animationContent ? 1 : 0)
                      
                }
                .onAppear{
                    withAnimation(.easeInOut(duration: 0.35)) {
                        animationContent = true
                    }
                    withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
                        animationContent = true
                    }
                }
            }
            
        }
    }
    
    func toggleFavorite() {
        if isFavorite {
            // If the book is already in favorites, we will remove it from there
            if let index = db.favoriteBooks.firstIndex(of: book.id) {
                db.favoriteBooks.remove(at: index)
            }
        } else {
            // If a book is not in your favorites, add it there
            db.favoriteBooks.append(book.id)
        }
        
        // Update the isFavorite state
        isFavorite.toggle()
        
        // Saving changes to the database
        db.updateFavoriteBooks()
    }

    
    @ViewBuilder
    func BookDetails() -> some View {
        VStack{
            Divider()
                .padding(.top, 25)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    Text("About the book")
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(book.volumeInfo?.description ?? "")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 15)
                .padding(.top, 20)
            }


        }
        .padding(.top, 120)
        .padding([.horizontal, .top], 15)
    }
}
