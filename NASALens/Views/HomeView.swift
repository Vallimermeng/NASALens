//
//  HomeView.swift
//  NASALens
//
//  Created by Петя on 26.10.2026.
//

import SwiftUI

struct HomeView: View{
    @State private var apodViewModel = APODViewModel()
    
    let currentDate = Date()
    
    var formatter:DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    } // return yyMMdd
    
    var apodDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    } // return yyyy-MM-dd for apod in foreach (from string to Date)
    
    
    var body: some View{
        NavigationStack{
            ZStack{
                Color.black.ignoresSafeArea()
                
                VStack{
                    Text("NASALens")
                        .font(.title)
                        
                    switch apodViewModel.state{
                    case .loading:
                        ProgressView("Загрузка")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundStyle(.white)
                        
                    case .loaded:
                        ScrollView{
                            LazyVStack{
                                ForEach(apodViewModel.apods, id:\.date ){apod in
                                    
                                    Divider()
                                        .frame(height: 1.2)
                                        .background(.white)
                                    
                                    HStack{
                                        NavigationLink{
                                            APODDetailView(apod: apod)
                                            
                                        }label:{
                                            AsyncImage(url: apod.hdurl){phase in
                                                
                                                if let image = phase.image{
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(4)
                                                        .clipShape(RoundedRectangle(cornerRadius: 28))
                                                    
                                                }
                                                else if phase.error != nil{
                                                    Color.red
                                                }else{
                                                    ProgressView()
                                                }
                                            }
                                            LazyVStack{
                                                Text(apod.title)
                                                    .padding(4)
                                                    .font(.headline)
                                                Text(apodViewModel.filteredText(html: apod.explanation))
                                                    .lineLimit(2)
                                                    .opacity(0.8)
                                                
                                                Text("\(Image(systemName: "calendar")) \(apod.date)")
                                                    .padding(4)
                                                    .font(.subheadline)
                                                    .opacity(0.7)
                                                
                                                
                                            }
                                            
                                            Image(systemName: "chevron.right")
                                                .padding(16)
                                            
                                        }
                                    }
                                    .background(Color(uiColor: .systemBackground).opacity(0.08))
                                    .cornerRadius(24)
                                    .onAppear{
                                        if apod.date == apodViewModel.apods.last?.date{
                                            print(apod.date)
                                            if let lastDate = apodDateFormatter.date(from:apod.date){
                                                Task{
                                                    await apodViewModel.loadNextPage(lastDate: formatter.string(from: apodViewModel.NdaysAgo(currentDate: lastDate)), currentDate: formatter.string(from: currentDate))
                                                }
                                            }else{
                                                print("ошибка")
                                            }
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
                    await apodViewModel.loadRangeAPOD(from: formatter.string(from: apodViewModel.NdaysAgo(currentDate: currentDate)), to: formatter.string(from: currentDate))
                }
                
            }
            .foregroundStyle(.white)
        }
    }
    
}


#Preview {
    RootView()
}
