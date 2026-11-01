//
//  APOD.swift
//  NASALens
//
//  Created by Петя on 21.10.2026.
//

import Foundation

struct APOD: Codable, Equatable{
    let date: String
    let title: String
    let url: URL
    let mediaType: String
    let explanation: String?
    let hdurl: URL?
    

    
    enum CodingKeys: String, CodingKey{
        case date
        case title
        case url
        case mediaType = "media_type"
        case explanation
        case hdurl
        
    }
    
}
