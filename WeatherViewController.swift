import UIKit
import Alamofire

class WeatherViewController: UIViewController {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    let url: String = "https://api.openweathermap.org/data/2.5/weather?"
    let parameters: [String] = [
        "appid=be7239b92f1e7c5bde30444b35b3946d",
        "&q=Seoul"
    ]
    let weatherAPI = WeatherAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setWeatherData() {
        guard let weatherData = weatherAPI.weatherData else { return }
        
        cityNameLabel.text = weatherData.name
        weatherLabel.text = weatherData.weather[0].main
        tempLabel.text = String(weatherData.main.temp)
        minLabel.text = String(weatherData.main.tempMin)
        maxLabel.text = String(weatherData.main.tempMax)
        pressureLabel.text = String(weatherData.main.pressure)
    }
    
    @IBAction func generateButton(_ sender: UIButton) {
        weatherAPI.getWeatherData(url: url, appid: parameters[0], city: parameters[1])
        
        setWeatherData()
    }
}
