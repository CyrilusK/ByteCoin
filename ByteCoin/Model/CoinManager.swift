import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, _ rape: Double)
    func didFailwithError(_ error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "ECE480D1-6514-416C-8083-***"
    var delegate: CoinManagerDelegate?
    
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
                    self.delegate?.didFailwithError(error!)
                    return
                }
                if let safeData = data {
                    //print(String(data: data, encoding: .utf8)!)
                    if let priceBTC = parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(self, priceBTC)
                    }
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
            return price
        }
        catch {
            delegate?.didFailwithError(error)
            return nil
        }
    }
}
