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
    @Namespace private var animation
    @State private var showDetailView: Bool = false
    @State private var selectedBook: Book?
    @State private var animateCurrentBook: Bool = false
    
    var filteredBooks: [Book] {
            if searchText.isEmpty {
                return booksApi.books
            } else {
                return booksApi.books.filter { book in
                    let titleMatch = book.volumeInfo?.title?.lowercased().contains(searchText.lowercased()) ?? false
                    let authorMatch = (book.volumeInfo?.authors?.joined(separator: " ") ?? "").lowercased().contains(searchText.lowercased())
                    return titleMatch || authorMatch
                }
            }
        }
   
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
            GeometryReader { geometry in
              
                VStack {
                    LogoView()
                    
                    VStack {
                        SearchBar(searchText: $searchText)
                        TagsView(activateTag: $activateTag, tags: tags) { selectedTag in
                            
                            Task {
                                do {
                                    try await booksApi.getBooks(forTag: selectedTag)
                                } catch {
                                    print("Error loading books for tag: \(selectedTag)")
                                }
                            }
                        }
                        
                        List() {
                            ForEach(filteredBooks) { book in
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
                                    .frame(width: geometry.size.width / 2, height: geometry.size.height * 0.2)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.white)
                                            .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                                            .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                                    }
                                    .zIndex(1)
                                    .offset(x: animateCurrentBook && selectedBook?.id == book.id ? -20 : 0)
                                    
                                    if let smallThumbnail = book.volumeInfo?.imageLinks?.smallThumbnail,
                                       let url = URL(string: smallThumbnail) {
                                        AsyncImage(url: url, content: { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.25, alignment: .center)
                                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                                .shadow(color: .black.opacity(0.01), radius: 5, x: 5, y: 5)
                                                .shadow(color: .black.opacity(0.01), radius: 5, x: -5, y: -5)
                                        }, placeholder: {
                                            ProgressView()
                                        })
                                    }
                               
                                }
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)){
                                        animateCurrentBook = true
                                        selectedBook = book
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15){
                                        showDetailView = true
                                    }
                                }
                            }
                        }
                        .task {
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
                .overlay {
                    if let selectedBook, showDetailView {
                        BookDetailView(db: db, booksApi: booksApi, show: $showDetailView, animation: animation, book: selectedBook)
                        //for more fluent animation transition
                            .transition(.asymmetric(insertion: .identity, removal: .offset(y:5)))
                    }
                }
                .onChange(of: showDetailView) { _, newValue in
                    if !newValue {
                        //resetting book animation
                        withAnimation(.easeInOut(duration: 0.15).delay(0.4)){
                            animateCurrentBook = false
                        }
                    }
                }
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
