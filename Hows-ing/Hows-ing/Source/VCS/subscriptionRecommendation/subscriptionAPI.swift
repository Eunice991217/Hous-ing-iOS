//
//  subscriptionAPI.swift
//  Hows-ing
//
//  Created by 윤지성 on 2023/10/14.
//

import Foundation
import Alamofire


struct SubscriptionCondition{
    var adr_do: String
    let recruit_date: String
    let age: String
    let position: String
    let family: String
    let no_house_period: String
    let account_period: String
    let account_money: String
    var house_around: String
}
struct SubscriptionRecommendationResponse: Codable {
    let status: Int
    let msg: String
    let probability: String?
    let result: Result?
}

struct Result: Codable {
    let currentCount: Int
    let data: [Datum]
    let matchCount, page, perPage, totalCount: Int
}

struct API {
    static let shared = API()
    func getSubscriptionRecommend(_ req: SubscriptionCondition, completion: @escaping (Swift.Result<SubscriptionRecommendationResponse, Error>) -> Void) {
        
        let url = "https://2715928430.for-seoul.synctreengine.com/subscription"
        let params: [String: Any] = [
            "adr_do": req.adr_do,
            "recruit_date": req.recruit_date,
            "age": req.age,
            "position": req.position,
            "family": req.family,
            "no_house_period": req.no_house_period,
            "account_period": req.account_period,
            "account_money": req.account_money,
            "house_around": req.house_around
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: HTTPHeaders(["Content-Type": "application/json", "Accept": "application/json"]))
        .responseDecodable(of: SubscriptionRecommendationResponse.self) { response in
            switch response.result {
            case .success(let subscriptionResponse):
                completion(.success(subscriptionResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
