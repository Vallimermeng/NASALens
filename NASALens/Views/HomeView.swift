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
                    Text("NASALens")
                        .font(.title)
                        
                    
                    switch apodViewModel.state{
                    case .loading:
                        ProgressView("Загрузка")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundStyle(.white)
                        
                    case .loaded(let apods):
                        
                        ScrollView{
                            
                            ForEach(apods, id:\.date ){apod in
                                var filteredText: String{
                                    apodViewModel.cleanHTML(html: apod.explanation ?? "")
                                        .replacingOccurrences(of: "Explanation:", with: "")
                                }
                                
                                
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
                                            Text(filteredText)
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
    RootView()
}
