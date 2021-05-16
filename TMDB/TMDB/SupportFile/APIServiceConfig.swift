//
//  APIServiceConfig.swift
//  TMDB
//
//  Created by 連振甫 on 2021/4/26.
//

import Foundation


struct APIURLParam {
    var id = ""
}

enum APIURL:String {
    
    public var baseURL:String {
        return "https://api.themoviedb.org/"
    }
    
    public var imageBaseURL:String {
        return "https://image.tmdb.org/t/p/w500/"
    }
    
    public var apiKey: String {
        return  "08743905ce52526a91653411697469c5"
    }
    
    public var apiVersion: String {
        return  "3"
    }
    
    case tv_GetTopRated
    case tv_GetPopular
    case tv_Detail
    case movie_GetTopRated
    case movie_GetPopular
    case movie_Detail
    
    public func getRoute(data:APIURLParam) -> String {
        var resource = ""
        
        switch self {
        case .tv_GetTopRated:
            resource = "/tv/top_rated"
        case .tv_GetPopular:
            resource = "/tv/popular"
        case .tv_Detail:
            resource = "/tv/\(data.id)"
        case .movie_GetTopRated:
            resource = "/movie/top_rated"
        case .movie_GetPopular:
            resource = "/movie/popular"
        case .movie_Detail:
            resource = "/movie/\(data.id)"
        }
        
        return "\(baseURL)\(apiVersion)\(resource)?api_key=\(apiKey)&language=zh-TW"
    }
    
}
extension String {
    public var url:URL {
        URL(string: self)!
    }
}
