//
//  fetchCardDeta.swift
//  yuugioh
//
//  Created by 高橋沙久哉 on 2025/01/17.
//

import Foundation
import Alamofire
class fetchCardData {
    func fecthCard(completion: @escaping ([cards]?, Bool) -> Void) {
        AF.request("http://127.0.0.1:8080/api/card",method: .get).response { response in
            guard let data = response.data else { return }
           
            let decoder = JSONDecoder()
            do {
               let decodedObject = try decoder.decode([cards].self, from: data)
                completion(decodedObject, true)
            }
            catch {
                print("読み込み失敗")
                completion(nil,false)
            }
        }
    }
    func conditionalSearch(card:cards?,completion: @escaping ([cards]?, Bool) -> Void) {
        AF.request("http://127.0.0.1:8080/api/card",method: .put,parameters: ["searchTag":card?.trueName],encoding: JSONEncoding.default).response { response in
            guard let data = response.data else { return }
           
            let decoder = JSONDecoder()
            do {
               let decodedObject = try decoder.decode([cards].self, from: data)
                completion(decodedObject, true)
            }
            catch {
                print("読み込み失敗")
                completion(nil,false)
            }
        }
    }
}
