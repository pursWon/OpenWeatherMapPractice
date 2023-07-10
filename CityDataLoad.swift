import Foundation

func CityDataLoad(completion: @escaping (City) -> Void) {
    let fileName: String = "City"
    let extensionType: String = "json"
    
    guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return }
    guard let data = try? Data(contentsOf: fileLocation) else { return }
    guard let decodeData = try? JSONDecoder().decode(City.self, from: data) else { return }
    
    completion(decodeData)
}

struct City: Codable {
    let city: [CityData]
}

struct CityData: Codable {
    let name: String
    let lon: Double
    let lat: Double
}
