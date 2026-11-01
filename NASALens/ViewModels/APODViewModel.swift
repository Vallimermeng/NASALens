//
//  APODViewModel.swift
//  NASALens
//
//  Created by Петя on 22.10.2026.
//

import Foundation
import Observation

@Observable
class APODViewModel{
    enum LoadingState{
        case loading
        case loaded
        case error(String)
    }
    var apods: [APOD] = []
    let service = NASAService()
    var state:LoadingState = .loading
    var isLoadingMore: Bool = false
    var lastAPODDate: String = ""
    
    
    
    func loadAPOD(date: String) async{
        state = .loading
        do{
            let apod = try await service.getAPOD(date: date)
            apods.append(contentsOf: apod)
            state = .loaded
        }catch{
            state = .error("\(error)")
            print(state)
        }
    }
    
    func loadRangeAPOD(from: String, to: String) async{
        state = .loading
        do{
            let apodRange = try await service.getAPODRange(from: from, to: to)
            apods.append(contentsOf: apodRange)
            state = .loaded
        }catch{
            state = .error("\(error)")
            print(state)
        }
    }
    
    func loadNextPage(lastDate: String, currentDate: String) async{
        guard !isLoadingMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        
        
        if(lastDate != lastAPODDate){
            do{
                let nextPages = try await service.getAPODRange(from: lastDate, to: lastAPODDate)
                lastAPODDate = lastDate
                state = .loaded
                let existingDates = Set(apods.map(\.date))
                let uniqueAPODs = nextPages.filter { !existingDates.contains($0.date) }
                apods.append(contentsOf: uniqueAPODs)
            }catch{
                state = .error("\(error)")
                print(state)
            }
        }else{
            return
        }
    }
    
    func NdaysAgo(currentDate: Date) -> Date{
        Calendar.current.date(byAdding: .day, value: -7, to: currentDate) ?? currentDate
    }
    
    
    // what the fuck
    func cleanHTML(html: String) -> String {
        let pattern = "<[^>]+>"
        let regex = try! NSRegularExpression(pattern: pattern)

        let range = NSRange(html.startIndex..., in: html)
        let result = regex.stringByReplacingMatches(
            in: html,
            range: range,
            withTemplate: ""
        )

        return result
    }
    
    func filteredText(html: String?) -> String{
        cleanHTML(html: html ?? "")
            .replacingOccurrences(of: "Explanation:", with: "")
    }
    
}
