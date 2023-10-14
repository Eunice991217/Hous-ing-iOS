//
//  mapDataModel.swift
//  Hows-ing
//
//  Created by 김민경 on 10/14/23.
//

import Foundation

// 지도 조회
// MARK: - MapGet
struct MapGet: Codable {
    let result: [Result]
}

// MARK: - Result
struct Result: Codable {
    let divCode: String // 구분 코드 (매몰 / 단지)
    let xCoord, yCoord: Double // 좌표
    let monthlyDeposit, monthlyPrice, jeonsePrice, salePrice: Int?
    let groupName: String // 종류 (아파트, 오피스텔, 주택)
    let saleName, features: String?
    let imageFile: String
    let dediArea, supplyArea: Double?
    let identiNum: IdentiNum
    let address: String?
    let saleMinAvgPrice, saleMaxAvgPrice, junsaeMinAvgPrice, junsaeMaxAvgPrice: Int?
    let areaName: String?

    enum CodingKeys: String, CodingKey {
        case divCode = "div_code"
        case xCoord = "x_coord"
        case yCoord = "y_coord"
        case monthlyDeposit = "monthly_deposit"
        case monthlyPrice = "monthly_price"
        case jeonsePrice = "jeonse_price"
        case salePrice = "Sale_price"
        case groupName = "group_name"
        case saleName = "name"
        case features
        case imageFile = "image_file"
        case dediArea = "dedi_area"
        case supplyArea = "supply_area"
        case identiNum = "identi_num"
        case address
        case saleMinAvgPrice = "sale_min_avg_price"
        case saleMaxAvgPrice = "sale_max_avg_price"
        case junsaeMinAvgPrice = "junsae_min_avg_price"
        case junsaeMaxAvgPrice = "junsae_max_avg_price"
        case areaName = "area_name"
    }
}

enum IdentiNum: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(IdentiNum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for IdentiNum"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// 지도 상세 조회
// MARK: - MapGetDetail
struct MapGetDetail: Codable {
    let result: ResultDetail
}

// MARK: - ResultDetail
struct ResultDetail: Codable {
    let name, address, saleType, feature: String
    let saleMinPrice, salePrice, saleMaxPrice, saleGenPrice: Int
    let junsaeMinPrice, junsaePrice, junsaeMaxPrice, junsaeGenPrice: Int
    let monthlyTotalPrice, monthlyDepositPrice, monthlyPrice: Int
    let groupName: String
    let dediArea, supplyArea: Double
    let roomCount, toiletCount: Int
    let moveAvailDate: String
    let image: String
    let agencyName, agencyTel: String
    
    // CodingKeys 열거형 추가
    enum CodingKeys: String, CodingKey {
        case name, address, saleType = "sale_type", feature
        case saleMinPrice = "sale_min_price", salePrice = "sale_price", saleMaxPrice = "sale_max_price", saleGenPrice = "sale_gen_price"
        case junsaeMinPrice = "junsae_min_price", junsaePrice = "junsae_price", junsaeMaxPrice = "junsae_max_price", junsaeGenPrice = "junsae_gen_price"
        case monthlyTotalPrice = "monthly_total_price", monthlyDepositPrice = "monthly_deposit_price", monthlyPrice = "monthly_price"
        case groupName = "group_name"
        case dediArea = "dedi_area", supplyArea = "supply_area", roomCount = "room_cnt", toiletCount = "toilet_cnt"
        case moveAvailDate = "move_avail_date", image = "image", agencyName = "agency_name", agencyTel = "agency_tel"
    }
}

struct MapGetDetailMarket: Codable {
    let result: Result

    struct Result: Codable {
        let name: String
        let address: String
        let groupName: String
        let totalDongSu: Int
        let totalSaedaesu: Int
        let image: String
        let data: [MarketData]
   
        enum CodingKeys: String, CodingKey {
            case name="name", address="address", groupName = "group_name", totalDongSu = "total_dongSu", totalSaedaesu="total_saedaesu", image="image", data="data"
        }
    }

    struct MarketData: Codable {
        let dediArea: Double
        let saleMaxPrice: Double
        let saleMinPrice: Double
        let saleGenPrice: Double
        let junsaeMinPrice: Double
        let junsaeMaxPrice: Double
        let junsaeGenPrice: Double
        let monthlyDepositPrice: Double
        let monthlyPrice: String
        // Add more properties as needed

        enum CodingKeys: String, CodingKey {
            case dediArea = "dedi_area"
            case saleMaxPrice = "sale_max_price"
            case saleMinPrice = "sale_min_price"
            case saleGenPrice = "sale_gen_price"
            case junsaeMinPrice = "junsae_min_price"
            case junsaeMaxPrice = "junsae_max_price"
            case junsaeGenPrice = "junsae_gen_price"
            case monthlyDepositPrice = "monthly_deposit_price"
            case monthlyPrice = "monthly_price"
            // Add more cases as needed
        }
    }
}


