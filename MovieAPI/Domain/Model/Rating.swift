//
//  Rating.swift
//  MovieAPI
//
//  Created by Bangkit on 23/02/24.
//

import Foundation
import ObjectMapper

class Rating: Mappable {
    var source: String = ""
    var value: String = ""
    
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        source <- map["Source"]
        value <- map["Value"]
    }
}
