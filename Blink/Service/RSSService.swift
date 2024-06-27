//
//  RSSService.swift
//  Blink
//
//  Created by trc vpn on 26.06.2024.
//

import Foundation

class RSSService {
    func fetchRSSFeed(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
}

