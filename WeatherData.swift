import Foundation

struct WeatherData: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String // 도시 이름
}

struct Weather: Decodable {
    let main: String // 날씨 설명
}

struct Main: Decodable {
    let temp: Double // 온도
    let feelsLike: Double // 체감 온도
    let tempMin: Double // 최저 온도
    let tempMax: Double // 최고 온도
    let pressure: Double // 기압?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
    }
}
