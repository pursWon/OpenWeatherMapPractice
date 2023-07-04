import Foundation
import Alamofire

protocol WeatherAPIProtocol {
    func getWeatherData(url: String, appid: String, city: String)
}

protocol WeatherImageProtocol {
    func getWeatherImage(weatherStatus: String)
}

class WeatherAPI: WeatherAPIProtocol {
    var weatherData: WeatherData?
    
    func getWeatherData(url: String, appid: String, city: String) {
        AF.request(url + appid + city, method: .post).responseDecodable(of: WeatherData.self) {
            response in
            
            guard response.error == nil else {
                guard let error = response.error?.localizedDescription else { return }
                
                print(error)
            
                return
            }
            
            guard let data = response.value else { return }
            
            self.weatherData = data
        }
    }
}
