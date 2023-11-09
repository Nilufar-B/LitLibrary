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
    @State private var activateTag = "Fiction"
    @Namespace private var animation //to make the tab indicator run smoothly we need to add a matched geometry effect so we also need an animation namespace
    @State private var showDetailView: Bool = false
    @State private var selectedBook: Book?
    @State private var animateCurrentBook: Bool = false
    
    var tags: [String] = [
                      "Fiction",
                      "Adventure",
                      "Fantasy",
                      "Drama",
                      "Poetry",
                      "Comics",
                      "Romance",
                      "Mystery",
                      "Thrillers"
    ]
    
    var body: some View {
        NavigationStack {
            GeometryReader{ geometry in
                VStack {
                    LogoView()
                    
                    VStack{
                        
                        SearchBar(searchText: $searchText)
                        TagsView(activateTag: $activateTag, tags: tags){ selectedTag in
                            
                            Task{
                                do {
                                    try await booksApi.getBooks(forTag: selectedTag)
                                }catch {
                                    print("Error loading books for tag: \(selectedTag)")
                                }
                            }
                            
                        }
                        List() {
                            
                            ForEach(booksApi.books) { book in
                                AsyncImage(url: URL(string: book.volumeInfo?.imageLinks?.smallThumbnail ?? ""), content: {image in
                                    
                                    HStack {
                                        image
                                            .resizable()
                                            .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.18, alignment: .center)
                                            .cornerRadius(10)
                                        
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
                                        
                                    }
                                    
                                }, placeholder: {
                                    ProgressView()
                                })
                            }
                            
                        }
                        
                    }  .task {
                        do {
                            try await booksApi.getBooks(forTag: activateTag)
                        } catch APIErrors.invalidData {
                            print("Invalid Data")
                        } catch APIErrors.invalidURL {
                            print("Invalid Url")
                        } catch APIErrors.invalidResponse {
                            print("Invalid Response")
                        } catch {
                            print("General error:\(error.localizedDescription)")
                        }
                    }
                    
                }
                 .frame(width: geometry.size.width, height: geometry.size.height)
                
            }
        }
    }
    @ViewBuilder
        func TagsView(activateTag: Binding<String>, tags: [String], onTagSelected: @escaping (String) -> Void) -> some View {
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 10){
                    ForEach(tags, id: \.self){ tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background{
                                if activateTag.wrappedValue == tag {
                                    Capsule()
                                        .fill(Color.orange)
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                } else {
                                    Capsule()
                                        .fill(.gray.opacity(0.2))
                                }
                            }
                            .foregroundColor(activateTag.wrappedValue == tag ? .black : .gray)
                            .onTapGesture {
                                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)){
                                    activateTag.wrappedValue = tag
                                    onTagSelected(tag)
                                }
                            }
                    }
                }
                .padding(.horizontal, 15)
            }
        }
    }
#Preview {
    BooksView(db: DBConnection(), booksApi: BooksAPI())
}
