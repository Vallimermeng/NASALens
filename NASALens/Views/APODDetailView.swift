//
//  APODDetailView.swift
//  NASALens
//
//  Created by Петя on 27.10.2026.
//

import SwiftUI

struct APODDetailView: View{
    let apod: APOD
    
    
    var body: some View{
        let apodViewModel = APODViewModel()
        
        ZStack{
            Color.black.ignoresSafeArea()
            ScrollView{
                VStack{
                    Text(apod.title)
                    AsyncImage(url: apod.hdurl){phase in
                        if let image = phase.image{
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width:350,height: 350)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .backgroundStyle(.thinMaterial)
                                .padding()
                            
                        }else if phase.error != nil{
                            Color.red
                        }else{
                            ProgressView()
                        }
                        
                    }
                    
                    Text(apodViewModel.cleanHTML(html: apod.explanation ?? ""))
                        .padding()
                        .background(Color(red: 31/255, green: 37/255, blue: 51/255))
                    
                    
                    
                    
                }
            }
            .foregroundStyle(.white)
            
        }
    }
    
}

#Preview {
    HomeView()
}
