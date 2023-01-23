//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "ECE480D1-6514-416C-8083-***"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) -> Void {
        let urlString = baseURL + "/\(currency)?apikey=\(apiKey)"
        //print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with: String) {
        if let url = URL(string: with) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, responce, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    //print(String(data: data, encoding: .utf8)!)
                    let priceBTC = parseJSON(safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let price = decodedData.rate
            print(price)
            return price
        }
        catch {
            print(error)
            return nil
        }
    }
}
