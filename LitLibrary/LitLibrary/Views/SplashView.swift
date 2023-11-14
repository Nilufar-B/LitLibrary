//
//  SplaschView.swift
//  LitLibrary
//
//  Created by Nilufar Bakhridinova on 2023-11-11.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive = false
    @State var size = 0.7
    @State var opacity = 0.4
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                Color.yellow.edgesIgnoringSafeArea(.all)
                if isActive {
                    ContentView()
                }else {
                    
                    VStack{
                        Image("app")
                            .resizable()
                            .frame(width: 150, height: 160)
                        Text("LitLibrary")
                            .bold()
                            .font(.title)
                            .foregroundColor(.black)
                            .opacity(0.7)
                        
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear{
                        withAnimation(.easeIn(duration: 1.0)){
                            self.size = 1.1
                            self.opacity = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                            withAnimation{
                                self.isActive = true
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
       
    }
}

#Preview {
    SplashView()
}
