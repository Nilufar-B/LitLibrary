//
//  FavoritesView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-11-01.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                
                LogoView()
                
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
       
    }
}

#Preview {
    FavoritesView()
}
