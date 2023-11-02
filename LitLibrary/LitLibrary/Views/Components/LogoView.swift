//
//  LogoView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-11-01.
//

import SwiftUI

struct LogoView: View {
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image("appLogo")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.leading, 5)
                Text("LitLibrary")
                    .bold()
            }
    
            Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.gray)
        }
    
        Spacer()
    }
  

}

#Preview {
    LogoView()
}
