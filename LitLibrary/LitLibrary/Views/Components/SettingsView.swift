//
//  SettingsView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-10-31.
//



import SwiftUI

struct SettingsView: View {
    
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    SettingsView(imageName: "gear", title: "version", tintColor: Color(.systemGray))
}
