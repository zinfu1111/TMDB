//
//  DataManger.swift
//  TMDB
//
//  Created by 連振甫 on 2021/4/26.
//

import UIKit
import Foundation

struct PopularResponse:Codable {
    var page = 0
    var total_results = 0
    var total_pages = 0
    var results:[PopularModel] = []
}

struct TopRatedResponse:Codable {
    var page = 0
    var total_results = 0
    var total_pages = 0
    var results:[TopRatedModel] = []
}

struct PopularModel:Codable {
    
    var poster_path:String? = nil
    var adult = false
    var overview = ""
    var release_date = ""
    var genre_ids:[Int] = []
    var id = 0
    var original_title = ""
    var original_language = ""
    var title = ""
    var backdrop_path:String? = nil
    var popularity = 0.0
    var vote_count = 0
    var video = false
    var vote_average = 0.0
    
}

struct TopRatedModel:Codable {
    
    var poster_path:String? = nil
    var popularity = 0.0
    var id = 0
    var backdrop_path:String? = nil
    var vote_average = 0.0
    var overview = ""
    var first_air_date = ""
    var origin_country:[String] = []
    var genre_ids:[Int] = []
    var original_language = ""
    var name = ""
    var vote_count = 0
    var original_name = ""
    
}


class DataManager {
    
    static let shared = DataManager()
    let imageCache = NSCache<NSURL, UIImage>()
    
    func fetchPopular(completion: @escaping (Result<PopularResponse, Error>) -> Void) {
        let popularURL = APIURL.GetPopular.url
        print("url \(popularURL)")
        let task = URLSession.shared.dataTask(with: popularURL) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let popularResponse = try jsonDecoder.decode(PopularResponse.self, from: data)
                    completion(.success(popularResponse))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchTopRated(completion: @escaping (Result<TopRatedResponse, Error>) -> Void) {
        let popularURL = APIURL.GetTopRated.url
        print("url \(popularURL)")
        let task = URLSession.shared.dataTask(with: popularURL) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let topRatedResponse = try jsonDecoder.decode(TopRatedResponse.self, from: data)
                    completion(.success(topRatedResponse))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchImage(url: URL, completionHandler: @escaping (UIImage?) -> ()) {
        if let image = imageCache.object(forKey: url as NSURL) {
            completionHandler(image)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: url as NSURL)
                completionHandler(image)
            } else {
                completionHandler(nil)
            }
        }.resume()
    }
}
