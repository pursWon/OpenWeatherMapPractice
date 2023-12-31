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
    let celsiusUnit = UnitTemperature.celsius
    var cityGeoData: (lon: String, lat: String) = ("126.9784", "37.566")
    var city: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameLabel.font = .boldSystemFont(ofSize: 33)
        setViewsColor()
        setCurrentWeather(cityName: "Seoul")
        setWeatherTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCurrentWeather(cityName: city)
        weatherTableView.reloadData()
    }
    
    func setWeatherTableView() {
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
    }
    
    func setViewsColor() {
        weatherTableView.backgroundColor = .white
    }
    
    func setCurrentWeather(cityName: String) {
        weatherAPI.getCurrentWeatherData(setCity: cityName) { weatherData in
            self.weatherLabel.text = weatherData.weather[0].main
            
            guard let currentWeather: String = self.weatherLabel.text else { return }
            
            switch currentWeather {
            case "Clear":
                self.view.backgroundColor = .tintColor
                self.iconImageView.backgroundColor = .tintColor
            case "Clouds":
                self.view.backgroundColor = .systemGray4
                self.iconImageView.backgroundColor = .systemGray4
            case "Snow":
                self.view.backgroundColor = .systemGray
                self.iconImageView.backgroundColor = .systemGray
            case "Rain":
                self.view.backgroundColor = .systemGray6
                self.iconImageView.backgroundColor = .systemGray6
            default:
                print("nothing")
            }
            
            self.cityNameLabel.text = weatherData.name
            self.tempLabel.text = "\(Int(self.celsiusUnit.converter.value(fromBaseUnitValue: weatherData.main.temp)))°C"
            self.minLabel.text = "최저 온도 : \(Int(self.celsiusUnit.converter.value(fromBaseUnitValue: weatherData.main.tempMin)))°C"
            self.maxLabel.text = "최고 온도 : \(Int(self.celsiusUnit.converter.value(fromBaseUnitValue: weatherData.main.tempMax)))°C"
        } image: { iconImage in
            DispatchQueue.main.async {
                self.iconImageView.image = iconImage
            }
        }
    }
    
    @IBAction func cityChangeButton(_ sender: UIButton) {
        guard let selectVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectCityViewController") as? SelectCityViewController else { return }
        
        selectVC.delegate = self
        selectVC.sendCity = self
        self.navigationController?.pushViewController(selectVC, animated: true)
    }
}

extension WeatherViewController: SendCityData {
    func setCityName(name: String) {
        city = name
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate, SendGeoData {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func setGeoData(geoData: (lon: String, lat: String)) {
        cityGeoData = geoData
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.weatherTableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        
        weatherAPI.getFiveDaysWeatherData(setLon: cityGeoData.lon, setLat: cityGeoData.lat) { weatherData in
            cell.descriptionLabel.text = weatherData[indexPath.row].weather[0].description
            cell.dayLabel.text = String(weatherData[indexPath.row].dtTxt.split(separator: " ")[0])
            cell.tempertureLabel.text = "\(Int(self.celsiusUnit.converter.value(fromBaseUnitValue: weatherData[indexPath.row].main.tempMin)))°C / \(Int(self.celsiusUnit.converter.value(fromBaseUnitValue: weatherData[indexPath.row].main.tempMax)))°C"
        } images: { iconImages in
            DispatchQueue.main.async {
                cell.iconImageView.image = iconImages[indexPath.row]
            }
        }
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
