import UIKit
import Alamofire

protocol WeatherAPIProtocol {
    func getCurrentWeatherData(setCity: String, completion: @escaping (CurrentData) -> Void, image: @escaping (UIImage) -> Void)
    func getFiveDaysWeatherData(setLon: String, setLat: String, completion: @escaping ([List]) -> Void)
    func getWeatherImage(iconNumber: String, iconImage: @escaping (UIImage) -> Void)
}

class WeatherAPI: WeatherAPIProtocol {
    func getCurrentWeatherData(setCity: String, completion: @escaping (CurrentData) -> Void, image: @escaping (UIImage) -> Void) {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        let city = URLQueryItem(name: "q", value: setCity)
        let appid = URLQueryItem(name: "appid", value: "be7239b92f1e7c5bde30444b35b3946d")
        components?.queryItems = [city, appid]
        
        guard let url = components?.url else { return }
        
        AF.request(url, method: .post).responseDecodable(of: CurrentData.self) { response in
            guard response.error == nil else { return }
            guard let data = response.value else { return }
            
            completion(data)
            
            self.getWeatherImage(iconNumber: data.weather[0].icon) { iconImage in
                image(iconImage)
            }
        }
    }
    
    func getFiveDaysWeatherData(setLon: String, setLat: String, completion: @escaping ([List]) -> Void) {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")
        let lon = URLQueryItem(name: "lon", value: setLon)
        let lat = URLQueryItem(name: "lat", value: setLat)
        let appid = URLQueryItem(name: "appid", value: "be7239b92f1e7c5bde30444b35b3946d")
        components?.queryItems = [lon, lat, appid]
        
        guard let url = components?.url else { return }
        
        AF.request(url, method: .get).responseDecodable(of: FiveDaysData.self) { response in
            guard response.error == nil else { return }
            guard let data = response.value else { return }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let currentDate = formatter.string(from: Date())
            
            let newData = data.list.filter { !$0.dtTxt.contains(currentDate) }.filter { $0.dtTxt.contains("12:00:00") }

            completion(newData)
        }
    }
    
    func getWeatherImage(iconNumber: String, iconImage: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            let url = "https://openweathermap.org/img/wn/" + iconNumber + "@2x.png"
            
            guard let imageURL = URL(string: url) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            guard let image = UIImage(data: imageData) else { return }
            
            iconImage(image)
        }
    }
}
