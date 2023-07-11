import UIKit
import Alamofire

protocol WeatherAPIProtocol {
    func getCurrentWeatherData(setCity: String, completion: @escaping (CurrentData) -> Void, image: @escaping (UIImage) -> Void)
    func getFiveDaysWeatherData(setLat: String, setLon: String, completion: @escaping (FiveDaysData) -> Void)
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
    
    func getFiveDaysWeatherData(setLat: String, setLon: String, completion: @escaping (FiveDaysData) -> Void) {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")
        let lat = URLQueryItem(name: "lat", value: setLat)
        let lon = URLQueryItem(name: "lon", value: setLon)
        let appid = URLQueryItem(name: "appid", value: "be7239b92f1e7c5bde30444b35b3946d")
        components?.queryItems = [lat, lon, appid]
        
        guard let url = components?.url else { return }
        
        AF.request(url, method: .get).responseDecodable(of: FiveDaysData.self) { response in
            guard response.error == nil else {
                
                print(response.error?.localizedDescription)
                return }
            guard let data = response.value else { return }
            
            print(data)
            
            completion(data)
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
