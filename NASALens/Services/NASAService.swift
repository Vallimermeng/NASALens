//
//  NASAService.swift
//  NASALens
//
//  Created by Петя on 22.10.2026.
//

import Foundation


struct NASAService{
    
    
    func getAPOD(date: String) async throws -> [APOD] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "science.nasa.gov"
        components.path = "/wp-json/wp/v2/apod-basic/\(date)"
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let apod = try JSONDecoder().decode(APOD.self, from: data)
        
        return [apod]
    }
    
    
    func getAPODRange(from: String, to: String) async throws -> [APOD]{
        var components = URLComponents()
        components.scheme = "https"
        components.host = "science.nasa.gov"
        components.path = "/wp-json/wp/v2/apod-basic"

        components.queryItems = [
            URLQueryItem(name: "date_from", value: from),
            URLQueryItem(name: "date_to", value: to)
        ]
        
        guard let url = components.url else{
            throw URLError(.badURL)
        }
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let respone = response as? HTTPURLResponse,
              (200...299).contains(respone.statusCode) else{
            throw URLError(.badServerResponse)
        }
        
        let apods = try JSONDecoder().decode([APOD].self, from: data)
        
        return apods
        
    }

}

