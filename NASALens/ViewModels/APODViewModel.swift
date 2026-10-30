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
        case loaded([APOD])
        case error(String)
    }
    let service = NASAService()
    var state:LoadingState = .loading
    
    
    
    func loadAPOD(date: String) async{
        state = .loading
        do{
            let apod = try await service.getAPOD(date: date)
            state = .loaded(apod)
        }catch{
            state = .error("\(error)")
            print(state)
        }
    }
    
    func loadRangeAPOD(from: String, to: String) async{
        state = .loading
        do{
            let apodRange = try await service.getAPODRange(from: from, to: to)
            state = .loaded(apodRange)
        }catch{
            state = .error("\(error)")
            print(state)
        }
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
    
}
