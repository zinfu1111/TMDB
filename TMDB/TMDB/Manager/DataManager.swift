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
    
    func fetchMovieData(type: ShowType,completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        
        var url:URL?
        let urlPathData = APIURLParam()
        
        if type == .TopRate {
            url = APIURL.movie_GetTopRated.getRoute(data: urlPathData).url
        }else {
            url = APIURL.movie_GetPopular.getRoute(data: urlPathData).url
        }
        
        guard let taskURL = url else { return }
        
        let task = URLSession.shared.dataTask(with: taskURL) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let popularResponse = try jsonDecoder.decode(MovieResponse.self, from: data)
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
    
    func fetchMovieDetail(id:String,completion: @escaping (Result<MovieModel, Error>) -> Void) {
        
        let urlPathData = APIURLParam(id: id)
        
        let taskURL = APIURL.movie_Detail.getRoute(data: urlPathData).url
        
        let task = URLSession.shared.dataTask(with: taskURL) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let detail = try jsonDecoder.decode(MovieModel.self, from: data)
                    completion(.success(detail))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
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
        
        let task = URLSession.shared.dataTask(with: taskURL) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let topRatedResponse = try jsonDecoder.decode(TVResponse.self, from: data)
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
    
    func fetchTVDetail(id:String,completion: @escaping (Result<TVModel, Error>) -> Void) {
        
        let urlPathData = APIURLParam(id: id)
        
        let taskURL = APIURL.tv_Detail.getRoute(data: urlPathData).url
        
        let task = URLSession.shared.dataTask(with: taskURL) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let detail = try jsonDecoder.decode(TVModel.self, from: data)
                    completion(.success(detail))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
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
