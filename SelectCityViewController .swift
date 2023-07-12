import UIKit

protocol SendGeoData {
    func setGeoData(geoData: (lon: String, lat: String))
}

protocol SendCityData {
    func setCityName(name: String)
}

class SelectCityViewController: UIViewController {
    @IBOutlet weak var cityTableView: UITableView!
    
    let weatherAPI = WeatherAPI()
    var cityData: City?
    var delegate: SendGeoData?
    var sendCity: SendCityData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CityDataLoad { loadData in
            self.cityData = loadData
        }
    }
    
    func setTableView() {
        cityTableView.delegate = self
        cityTableView.dataSource = self
    }
}

extension SelectCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cityData = cityData else { return 0 }
        
        return cityData.city.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = cityTableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as? CityTableViewCell,
            let cityData = cityData
        else { return UITableViewCell() }
        
        cell.cityLabel.text = cityData.city[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cityData = cityData else { return }
        
        self.delegate?.setGeoData(geoData: (String(cityData.city[indexPath.row].lon), String(cityData.city[indexPath.row].lat)))
        self.sendCity?.setCityName(name: cityData.city[indexPath.row].name)
        self.navigationController?.popViewController(animated: true)
    }
}
