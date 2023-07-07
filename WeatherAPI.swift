import UIKit
import Alamofire

protocol WeatherAPIProtocol {
    func setComponents() -> URL
    func getWeatherData(completion: @escaping (WeatherData) -> Void, image: @escaping (UIImage) -> Void)
    func getWeatherImage(iconNumber: String, iconImage: @escaping (UIImage) -> Void)
}

class WeatherAPI: WeatherAPIProtocol {
    func setComponents() -> URL {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        let appid = URLQueryItem(name: "appid", value: "be7239b92f1e7c5bde30444b35b3946d")
        let city = URLQueryItem(name: "q", value: "Seoul")
        components?.queryItems = [appid, city]
        
        guard let url = components?.url else { return URL(string: "")! }
        
        return url
    }
    
    func getWeatherData(completion: @escaping (WeatherData) -> Void, image: @escaping (UIImage) -> Void) {
        AF.request(setComponents(), method: .post).responseDecodable(of: WeatherData.self) { response in
            guard response.error == nil else { return }
            guard let data = response.value else { return }
            
            completion(data)
            self.getWeatherImage(iconNumber: data.weather[0].icon) { iconImage in
                image(iconImage)
            }
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
