//
//  ContentView.swift
//  NASALens
//
//  Created by Петя on 21.10.2026.
//

import SwiftUI

struct ContentView: View {
    
    
    
    @State var apodViewModel = APODViewModel()
    @State private var showDetail = false
    @State var selectedDate = Date()
    @State private var selectedAPOD: APOD?
    @State private var isTapped = false
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.black.ignoresSafeArea()
                
                VStack {
                    Text("NASALens")
                        .font(.title)
                        .padding()
                    DatePicker("Выберите дату снимка", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                        .colorScheme(.dark)
                    
                    Button("Готово"){
                        Task{
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyMMdd"
                            await apodViewModel.loadAPOD(date: formatter.string(from: selectedDate)
                            )
                            
                            if case .loaded(let apods) = apodViewModel.state{
                                selectedAPOD = apods.first
                                showDetail = true
                                isTapped = false
                                
                            }
                        }
                        
                        isTapped.toggle()
                    }
                    .font(.headline)
                    .padding()
                    if case .loading = apodViewModel.state{
                        if(isTapped){
                            ProgressView("Загрузка")
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        
                    }
                    
                    
                }
                    
                .foregroundStyle(.white)
                .navigationDestination(isPresented: $showDetail) {
                    if let apod = selectedAPOD {
                        APODDetailView(apod: apod)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
