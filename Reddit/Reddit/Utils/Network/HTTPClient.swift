//
//  HTTPClient.swift
//  Reddit
//
//  Created by Cristian Morales on 10/6/17.
//  Copyright © 2017 Cristian Morales. All rights reserved.
//

import Foundation

class HTTPClient: NSObject {
    static let shared = HTTPClient()
    
    class func getQueryStringFrom(url: String, params: [String:Any]?) -> String {
        
        guard let params = params else {
            return url
        }
        
        var qs: String = "?"
        for (key, value) in params {
            if qs != "?" {
                qs += "&"
            }
            qs += key
            qs += "="
            qs += value is Int ? String(describing: value) : value as! String
        }
        
        return url + qs
    }
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func GET(url: String, params: [String:Any]?,
               completion: @escaping (_ response: [String:Any]) -> (),
               failure: @escaping () -> ()) {
        
        let urlWithQueryString = HTTPClient.getQueryStringFrom(url: url, params: params)
        var request = URLRequest(url: URL(string: urlWithQueryString)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error)")
                failure()
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse,
                httpStatus.statusCode < 200,
                httpStatus.statusCode >= 300 {
                // check for http errors
                print("statusCode should be >= 200 or < than 300, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                failure()
                return
            }
            
            let responseJSONString = String(data: data, encoding: .utf8)
            let jsonDictionary = HTTPClient.convertToDictionary(text: responseJSONString!)
            completion(jsonDictionary!)
        }
        
        task.resume()
    }
}

