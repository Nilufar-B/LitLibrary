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
    
    @Binding var show: Bool
    var animation: Namespace.ID
    var book: Book
    @State private var animationContent: Bool = false
    @State private var offsetAnimation: Bool = false
    @State private var isFavorite: Bool = false
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                LogoView()
                
                VStack(spacing: 15) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)){
                            offsetAnimation = false
                        }
                        withAnimation(.easeInOut(duration: 0.2)){
                            animationContent = false
                            show = false
                        }
                        
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .contentShape(Rectangle())
                    })
                    .padding([.leading, .vertical], 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(animationContent ? 1 : 0)
                    
                    //book preview with matched geometry effect
                    GeometryReader {
                        let size = $0.size
                        
                        HStack(spacing: 20) {
                            if let thumbnailURLString = book.volumeInfo?.imageLinks?.thumbnail,
                               let thumbnailURL = URL(string: thumbnailURLString) {
                                AsyncImage(url: thumbnailURL) { phase in
                                    if case .success(let image) = phase {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
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
                                
                                Button(action: {
                                    
                                }, label: {
                                    Label("Favorite", systemImage: "suit.heart")
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                })
                                .frame(maxWidth: .infinity)
                                .padding(.top, 20)
                            }
                            .padding(.trailing, 15)
                            .padding(.top, 30)
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
    @ViewBuilder
    func BookDetails() -> some View {
        VStack{
            Divider()
                .padding(.top, 25)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    Text("About the book")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(book.volumeInfo?.description ?? "")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 15)
                .padding(.top, 20)
            }
            Button(action: {
                
            }, label: {
                Text("Read Now")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 45)
                    .padding(.vertical, 10)
//                    .background{
//                        Capsule()
//                            .fill(Color.orange.gradient)
//                    }
                    .foregroundColor(.orange)
            })
            .padding(.bottom, 15)
        }
        .padding(.top, 120)
        .padding([.horizontal, .top], 15)
    }
}
