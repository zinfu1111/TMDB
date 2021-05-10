//
//  TopRateModel.swift
//  TMDB
//
//  Created by 連振甫 on 2021/5/8.
//

import Foundation

struct TVResponse:Codable {
    var page:Int
    var total_results:Int
    var total_pages:Int
    var results:[TVModel]
}

struct TVModel:Codable {
    
    var poster_path:String?
    var popularity:Float
    var id:Int
    var backdrop_path:String?
    var vote_average:Float
    var overview:String
    var first_air_date:String
    var origin_country:[String] = []
    var genre_ids:[Int] = []
    var original_language:String
    var name:String
    var vote_count:Int
    var original_name:String
    
}

