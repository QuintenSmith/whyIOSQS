//
//  PostController.swift
//  whyIOS
//
//  Created by Quinten Smith on 9/5/18.
//  Copyright © 2018 Quinten Smith. All rights reserved.
//

import Foundation

enum HttpProtocol: String {
    case put = "PUT"
    case get = "GET"
}

class PostController {
    
    static var baseURL = URL(string: "https://whydidyouchooseios.firebase.io.com/reasons")
    
    static func fetchPosts(completion: @escaping (([Post]?) -> Void)) {
        
        guard let url = baseURL?.appendingPathExtension("json") else {completion(nil); return}
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpProtocol.get.rawValue
        request.httpBody = nil
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error fetching posts \(error) \(error.localizedDescription)")
                completion(nil); return
            }
            
            guard let data = data else {completion(nil); return}
           
            do {
                let jsonDecoder = JSONDecoder()
                let postsDictionary = try jsonDecoder.decode([String: Post].self, from: data)
                let posts = postsDictionary.compactMap {$0.value}
                completion(posts)
                return
            } catch {
                print("Error fetching data: \(error) \(error.localizedDescription)")
                completion(nil); return
            }
       }.resume()
    }
    
    static func putPost(name: String, reason: String, cohort: String, completion: @escaping (_ success: Bool) -> Void){
        let post = Post(name: name, reason: reason)
        guard let url = baseURL else {fatalError("bad baseURL")}
        let builtURL = url.appendingPathComponent(post.uuid).appendingPathExtension("json")
        var request = URLRequest(url: builtURL)
        
        let jsonEncoder = JSONEncoder()
        do{
            let data = try jsonEncoder.encode(post)
            request.httpMethod = "PUT"
            request.httpBody = data
        }catch let error {
            print("Error putting with data task: \(error) \(error.localizedDescription)")
            completion(false); return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error Fetching with data task: \(error) \(error.localizedDescription)")
                completion(false); return
            }
            //for me
            guard let data = data,
                let responseString = String(data: data, encoding: .utf8) else {completion(false); return}
            print(responseString)
            
            //connect the local array to the instances in the cloud or wherever
            completion(true)
            }.resume()
    }
}
