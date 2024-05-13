import Foundation

struct CryptoDataResponse: Codable {
    let status: String
    let data: CryptoData
}

struct CryptoData: Codable {
    let stats: Stats
    let coins: [CryptoCurrency]
}

struct Stats: Codable {
    let total: Int?
    let totalCoins: Int?
    let totalMarkets: Int?
    let totalExchanges: Int?
    let totalMarketCap: String?
    let total24hVolume: String?
}

struct CryptoCurrency: Codable {
    let uuid: String
    let symbol: String?
    let name: String?
    let color: String?
    let iconUrl: URL?
    let marketCap: String?
    let price: String?
    let listedAt: TimeInterval?
    let tier: Int?
    let change: String?
    let rank: Int?
    let sparkline: [String]?
    let lowVolume: Bool?
    let btcPrice: String?
    
    var highVal: String {
          if let sparkline = sparkline,
             let high = sparkline.max(),
             let highValue = Double(high) {
              return String(highValue)
          } else {
              return "N/A"
          }
      }
    
    
    var lowVal: String {
          if let sparkline = sparkline,
             let low = sparkline.min(),
             let lowValue = Double(low) {
              return String(lowValue)
          } else {
              return "N/A"
          }
      }
}
