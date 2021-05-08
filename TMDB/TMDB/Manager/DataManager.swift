//
//  DataManger.swift
//  TMDB
//
//  Created by 連振甫 on 2021/4/26.
//

import UIKit
import Foundation

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
