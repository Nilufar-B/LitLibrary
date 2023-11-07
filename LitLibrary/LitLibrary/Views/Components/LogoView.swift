//
//  LogoView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-11-01.
//

import SwiftUI

struct LogoView: View {
    
    var body: some View {
       // GeometryReader { geometry in
            VStack(alignment: .leading){
                HStack{
                    Image("appLogo")
                        .resizable()
                        .frame(width: 50, height: 50)
                        //.frame(width: geometry.size.width * 0.13, height: geometry.size.height * 0.07, alignment: .leading)
                      
                    Text("LitLibrary")
                        .bold()
                }
                
                Rectangle()
                    .frame(height: 2)
                   // .frame(height: geometry.size.height * 0.002)
                    .foregroundColor(.gray)
            }
            
            //Spacer()
       // }
        
    }
}

#Preview {
    LogoView()
}


