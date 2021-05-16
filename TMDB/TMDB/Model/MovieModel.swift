//
//  PopularModel.swift
//  TMDB
//
//  Created by 連振甫 on 2021/5/8.
//

import Foundation

struct MovieResponse:Codable {
    var page:Int
    var total_results:Int
    var total_pages:Int
    var results:[MovieModel]
}

struct MovieModel:Codable {
    
    var poster_path:String?
    var adult:Bool
    var overview:String
    var release_date:String
    var genre_ids:[Int]?
    var genres:[Genres]?
    var id:Int
    var original_title:String
    var original_language:String
    var title:String
    var backdrop_path:String?
    var popularity:Float
    var vote_count:Int
    var video:Bool
    var vote_average:Float
    
}

struct Genres:Codable {
    let id:Int
    let name:String
}
