//
//  RootView.swift
//  NASALens
//
//  Created by Петя on 01.11.2026.
//
import SwiftUI

struct RootView: View{
    
    var body: some View{
        TabView{
            Tab("Главная", systemImage: "house"){
                HomeView()
            }
            
            Tab("Поиск", systemImage: "magnifyingglass"){
                ContentView()
            }
            
        }
    }
}

#Preview {
    RootView()
}
