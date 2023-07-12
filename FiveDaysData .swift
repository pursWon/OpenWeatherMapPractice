
import Foundation

// MARK: - FiveDaysData
struct FiveDaysData: Codable {
    let list: [List]
}

// MARK: - List
struct List: Codable {
    let main: TempInform
    let weather: [WeatherInform]
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case dtTxt = "dt_txt"
    }
}

// MARK: - TempInform
struct TempInform: Codable {
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Weather
struct WeatherInform: Codable {
    let main: String
    let description: String
    let icon: String
}
