//
//  ViewModel.swift
//  AppleMap
//
//  Created by Tong Yi on 7/7/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class ViewModel {
    var dataSource = [LocationModel]()
    
    func fetchLocationData() {
        DispatchQueue.global(qos: .default).async {
            let url = URL(string: "https://data.honolulu.gov/resource/yef5-h88r.json")
            guard let fetchData = Service.shared.fetchLocationJSONData(url: url) else { return }
            
            do {
                let json = try JSONDecoder().decode([LocationModel].self, from: fetchData)
                self.dataSource = json
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
