//
//  APIServiceConfig.swift
//  TMDB
//
//  Created by 連振甫 on 2021/4/26.
//

import Foundation


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
    
    public var route: String {
        return getRoute()
    }
    
    public var url: URL {
        let urlStr = "\(baseURL)\(route)"
        return URL(string: urlStr)!
    }
    
    
    case tv_GetTopRated
    case tv_GetPopular
    case movie_GetTopRated
    case movie_GetPopular
    
    public func getRoute() -> String {
        var resource = ""
        
        switch self {
        case .tv_GetTopRated:
            resource = "/tv/top_rated"
        case .tv_GetPopular:
            resource = "/tv/popular"
        case .movie_GetTopRated:
            resource = "/movie/top_rated"
        case .movie_GetPopular:
            resource = "/movie/popular"
        }
        
        return "\(apiVersion)\(resource)?api_key=\(apiKey)"
    }
    
}
