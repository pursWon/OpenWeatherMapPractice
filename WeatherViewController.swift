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
    var cityGeoData: (lon: String, lat: String) = ("126.9784", "37.566")
    var city: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewsColor()
        setCurrentWeather(cityName: "Seoul")
        setWeatherTableView()
        // weatherTableView.reloadData()
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
        iconImageView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func setCurrentWeather(cityName: String) {
        weatherAPI.getCurrentWeatherData(setCity: cityName) { weatherData in
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
            switch indexPath.row {
            case 0:
                cell.descriptionLabel.text = weatherData[0].weather[0].description
                cell.dayLabel.text = weatherData[0].dtTxt
                cell.tempertureLabel.text = "\(weatherData[0].main.tempMax) / \(weatherData[0].main.tempMin)"
            case 1:
                cell.descriptionLabel.text = weatherData[1].weather[0].description
                cell.dayLabel.text = weatherData[1].dtTxt
                cell.tempertureLabel.text = "\(weatherData[1].main.tempMax) / \(weatherData[1].main.tempMin)"
            case 2:
                cell.descriptionLabel.text = weatherData[2].weather[0].description
                cell.dayLabel.text = weatherData[2].dtTxt
                cell.tempertureLabel.text = "\(weatherData[2].main.tempMax) / \(weatherData[1].main.tempMin)"
            case 3:
                cell.descriptionLabel.text = weatherData[3].weather[0].description
                cell.dayLabel.text = weatherData[3].dtTxt
                cell.tempertureLabel.text = "\(weatherData[3].main.tempMax) / \(weatherData[3].main.tempMin)"
            default:
                fatalError()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
