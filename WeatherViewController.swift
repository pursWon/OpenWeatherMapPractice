import UIKit
import Alamofire

class WeatherViewController: UIViewController {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    let weatherAPI = WeatherAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setWeatherData() {
        weatherAPI.getWeatherData { weatherData in
            self.weatherLabel.text = weatherData.weather[0].main
            self.cityNameLabel.text = weatherData.name
            self.tempLabel.text = String(weatherData.main.temp)
            self.minLabel.text = "최저 온도 : \(String(weatherData.main.tempMin))"
            self.maxLabel.text = "최고 온도 : \(String(weatherData.main.tempMax))"
            self.pressureLabel.text = "기압 : \(String(weatherData.main.pressure))"
        } image: { iconImage in
            DispatchQueue.main.async {
                self.iconImageView.image = iconImage
            }
        }
    }
    
    @IBAction func generateButton(_ sender: UIButton) {
        setWeatherData()
    }
}
