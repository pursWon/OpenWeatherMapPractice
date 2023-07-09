import Foundation

struct WeatherData: Decodable {
    let weather: [Weather]
    let main: Main
    /// 도시 이름
    let name: String
}

struct Weather: Decodable {
    /// 날씨 설명
    let main: String
    /// 날씨 아이콘
    let icon: String
}

struct Main: Decodable {
    /// 온도
    let temp: Double
    /// 체감 온도
    let feelsLike: Double
    /// 최저 온도
    let tempMin: Double
    /// 최고 온도
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
