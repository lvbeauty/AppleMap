//
//  Service.swift
//  AppleMap
//
//  Created by Tong Yi on 7/7/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation

class Service
{
    static let shared = Service()
    private init() {}
    
    func fetchLocationJSONData(url: URL?) -> Data? {
        
        guard let url = url else { return nil }
        
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            <#code#>
//        }
//
//        task.resume()
        var data: Data?
        
        do {
           data = try Data(contentsOf: url)
        }
        catch {
            print(error.localizedDescription)
        }
        
        return data
    }
}
