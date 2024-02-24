//
//  Movie.swift
//  MovieAPI
//
//  Created by Bangkit on 26/01/24.
//

import Foundation
import ObjectMapper

class Movie: Mappable, Identifiable, Equatable {
    var title: String = ""
    var year: String = ""
    var rated: String = ""
    var released: String = ""
    var runtime: String = ""
    var genre: String = ""
    var director: String = ""
    var writer: String = ""
    var actors: String = ""
    var plot: String = ""
    var language: String = ""
    var country: String = ""
    var poster: String = ""
    var metascore: String = ""
    var imdbRating: String = ""
    var imdbVotes: String = ""
    var imdbID: String = ""
    var type: String = ""
    var dvd: String = ""
    var boxOffice: String = ""
    var ratings: [Rating] = []
    
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        title <- map["Title"]
        year <- map["Year"]
        rated <- map["Rated"]
        released <- map["Released"]
        runtime <- map["Runtime"]
        genre <- map["Genre"]
        director <- map["Director"]
        writer <- map["Writer"]
        actors <- map["Actors"]
        plot <- map["Plot"]
        language <- map["Language"]
        country <- map["Country"]
        poster <- map["Poster"]
        metascore <- map["Metascore"]
        imdbRating <- map["imdbRating"]
        imdbVotes <- map["imdbVotes"]
        imdbID <- map["imdbID"]
        type <- map["Type"]
        boxOffice <- map["BoxOffice"]
        ratings <- map["Ratings"]
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.imdbID == rhs.imdbID
    }
}
