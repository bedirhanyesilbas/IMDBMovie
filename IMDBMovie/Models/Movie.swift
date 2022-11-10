//
//  Movie.swift
//  IMDBMovie
//
//  Created by Bedirhan Yeşilbaş on 9.11.2022.
//

import Foundation

struct DetailModel: Codable {
    let page, totalResults, totalPages: Int
    let results: [MovieModel]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
}

struct MovieModel: Codable {
    let movieID: Int
    let title: String
    let posterPath: String?
    let overview, releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case movieID = "id"
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
}

