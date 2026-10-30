//
//  HomeView.swift
//  NASALens
//
//  Created by Петя on 26.10.2026.
//

import SwiftUI

struct HomeView: View{
    @State var apodViewModel = APODViewModel()
    
    let currentDate = Date()
    var thirtyOneDaysAgo: Date{
        Calendar.current.date(byAdding: .day, value: -31, to: currentDate) ?? currentDate
    }//get 31 previous days
    var formatter:DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    }
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color.black.ignoresSafeArea()
                
                VStack{
                    
                    switch apodViewModel.state{
                    case .loading:
                        ProgressView("Загрузка")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundStyle(.white)
                        
                    case .loaded(let apods):
                        
                        ScrollView{
                            NavigationLink("Найти по дате"){
                                ContentView()
                            }
                            .font(.headline)
                            
                            ForEach(apods, id:\.date ){apod in
                                Divider()
                                    .frame(height: 1.2)
                                    .background(.white)
                                Text(apod.title)
                                    .padding(4)
                                
                                NavigationLink{
                                    APODDetailView(apod: apod)
                                    
                                }label:{
                                    AsyncImage(url: apod.hdurl){phase in
                                        
                                        if let image = phase.image{
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .padding(4)
                                            
                                        }
                                        else if phase.error != nil{
                                            Color.red
                                        }else{
                                            ProgressView()
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                        
                        
                    case .error(let error):
                        Text("Произошла ошибка: \(error)")
                        
                        
                    }
                    
                }
                .task {
                    await apodViewModel.loadRangeAPOD(from: formatter.string(from: thirtyOneDaysAgo), to: formatter.string(from: currentDate))
                }
                
            }
            .foregroundStyle(.white)
        }
    }
    
}


#Preview {
    HomeView()
}
