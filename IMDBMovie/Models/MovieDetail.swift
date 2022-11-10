//
//  MovieDetail.swift
//  IMDBMovie
//
//  Created by Bedirhan Yeşilbaş on 9.11.2022.
//

import Foundation
import Foundation

struct MovieDetailModel: Codable {
    let movieID: Int
    let imdbID: String?
    let originalTitle, overview: String
    let posterPath: String?
    let releaseDate: String
    let title: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case movieID = "id"
        case imdbID = "imdb_id"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}






