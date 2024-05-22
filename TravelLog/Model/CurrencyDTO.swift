//
//  CurrencyDTO.swift
//  TripLog
//
//  Created by 최승범 on 2024/04/03.
//

import Foundation

struct CurrencyDTO: Decodable {
    let result: Int
    let currencyUnit, currencyName, exchangeRate: String

    enum CodingKeys: String, CodingKey {
        case result
        case currencyUnit = "cur_unit"
        case exchangeRate = "kftc_deal_bas_r"
        case currencyName = "cur_nm"
    }
}
