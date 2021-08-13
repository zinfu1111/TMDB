//
//  AuthenticationManager.swift
//  TMDB
//
//  Created by 連振甫 on 2021/5/28.
//

import Foundation

struct Token:Codable {
    let request_token:String
    let expires_at:String
    let success:Bool
}

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    func newToken(completion: @escaping (Result<Token, Error>) -> Void) {
        
        let taskURL = APIURL.newToken.getRoute(data: APIURLParam()).url
        
        let task = URLSession.shared.dataTask(with: taskURL) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let tokenResponse = try jsonDecoder.decode(Token.self, from: data)
                    completion(.success(tokenResponse))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    
    func login(account:String, password:String,completion: @escaping (Result<Token, Error>) -> Void) {
        //error處理方式問一下
        
        
        let login:(String)->() = { token in
            let taskURL = APIURL.login.getRoute(data: APIURLParam()).url
            
            var request = URLRequest(url: taskURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let data = ["username": account,"password": password,"request_token":token]
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(data)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let tokenResponse = try jsonDecoder.decode(Token.self, from: data)
                        completion(.success(tokenResponse))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
        
        newToken(completion: {[weak self] result in
            
            switch result {
            case .success(let token):
                login(token.request_token)
                break
            case .failure(let error):
                break
            }
            
        })
        
        
        
    }
}
