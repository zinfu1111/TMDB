//
//  DataManger.swift
//  TMDB
//
//  Created by 連振甫 on 2021/4/26.
//

import UIKit
import Foundation

enum ShowType {
    case TopRate
    case Popular
}

enum DataType:Int {
    case TV = 0
    case Movie = 1
}

class DataManager {
    
    static let shared = DataManager()
    let imageCache = NSCache<NSURL, UIImage>()
    
    var token = ""
    
    func createTaskAndDecode<T>(url:URL,type: T.Type,completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let dataResponse = try jsonDecoder.decode(type, from: data)
                    completion(.success(dataResponse))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchMovieData(type: ShowType,completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        
        var url:URL?
        let urlPathData = APIURLParam()
        
        if type == .TopRate {
            url = APIURL.movie_GetTopRated.getRoute(data: urlPathData).url
        }else {
            url = APIURL.movie_GetPopular.getRoute(data: urlPathData).url
        }
        
        guard let taskURL = url else { return }
        createTaskAndDecode(url: taskURL, type: MovieResponse.self, completion: completion)
    }
    
    func fetchMovieDetail(id:String,completion: @escaping (Result<MovieModel, Error>) -> Void) {
        
        let urlPathData = APIURLParam(id: id)
        
        let taskURL = APIURL.movie_Detail.getRoute(data: urlPathData).url
        createTaskAndDecode(url: taskURL, type: MovieModel.self, completion: completion)
    }
    
    func fetchTVData(type: ShowType,completion: @escaping (Result<TVResponse, Error>) -> Void) {
        var url:URL?
        let urlPathData = APIURLParam()
        if type == .TopRate {
            url = APIURL.tv_GetTopRated.getRoute(data: urlPathData).url
        }else {
            url = APIURL.tv_GetPopular.getRoute(data: urlPathData).url
        }
        
        guard let taskURL = url else { return }
        createTaskAndDecode(url: taskURL, type: TVResponse.self, completion: completion)
    }
    
    func fetchTVDetail(id:String,completion: @escaping (Result<TVModel, Error>) -> Void) {
        
        let urlPathData = APIURLParam(id: id)
        
        let taskURL = APIURL.tv_Detail.getRoute(data: urlPathData).url
        createTaskAndDecode(url: taskURL, type: TVModel.self, completion: completion)
    }
    
    func fetchImage(url: URL, completionHandler: @escaping (UIImage?,URL) -> ()) {
        if let image = imageCache.object(forKey: url as NSURL) {
            completionHandler(image,url)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: url as NSURL)
                completionHandler(image,url)
            } else {
                completionHandler(nil,url)
            }
        }.resume()
    }
    
    
}
