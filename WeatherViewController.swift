import UIKit
import Alamofire

class WeatherViewController: UIViewController {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    
    let weatherAPI = WeatherAPI()
    
    var cityGeoData: (lon: String, lat: String) = ("", "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconImageView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setIntialWeather()
    }
    
    func setIntialWeather() {
        weatherAPI.getCurrentWeatherData(setCity: "Seoul") { weatherData in
            self.weatherLabel.text = weatherData.weather[0].main
            self.cityNameLabel.text = weatherData.name
            self.tempLabel.text = String(weatherData.main.temp)
            self.minLabel.text = "최저 온도 : \(String(weatherData.main.tempMin))"
            self.maxLabel.text = "최고 온도 : \(String(weatherData.main.tempMax))"
        } image: { iconImage in
            DispatchQueue.main.async {
                self.iconImageView.image = iconImage
            }
        }
    }
    
    @IBAction func cityChangeButton(_ sender: UIButton) {
        guard let selectVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectCityViewController") as? SelectCityViewController else { return }
        
        selectVC.delegate = self
        self.navigationController?.pushViewController(selectVC, animated: true)
    }
}

extension WeatherViewController: SendGeoData {
    func setGeoData(geoData: (lon: String, lat: String)) {
        cityGeoData = (geoData.lon, geoData.lat)
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.weatherTableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
