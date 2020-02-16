import Foundation

struct WeatherResponse: Codable {
    var coord: Coord?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone, id: Int?
    var name: String?
    var formalName: String?
    var cod: Int?
    
    init(name: String?, formalName: String?, temp: Double?, feelsLike: Double?, weatherDesc: String?) {
        self.name = name
        self.formalName = formalName
        self.main = Main(temp: temp, feelsLike: feelsLike)
        self.weather = [Weather]()
        self.weather?.append(Weather(weatherDesc: weatherDesc))
    }
    
    func getTemp() -> Double? {
        return main?.temp
    }
    func getFeelsLike() -> Double? {
        return main?.feelsLike
    }
    func getName() -> String? {
        return name
    }
    func getWeatherDesc() -> String? {
        return weather?[0].weatherDescription
    }
    func getFormalName() -> String? {
        return formalName
    }
}

struct Clouds: Codable {
    var all: Int?
}

struct Coord: Codable {
    var lon, lat: Double?
}

struct Main: Codable {
    var temp, feelsLike, tempMin, tempMax: Double?
    var pressure, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
    init(temp: Double?, feelsLike: Double?) {
        self.temp = temp
        self.feelsLike = feelsLike
    }
}

struct Sys: Codable {
    var type, id: Int?
    var country: String?
    var sunrise, sunset: Int?
}

struct Weather: Codable {
    var id: Int?
    var main, weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    init(weatherDesc: String?) {
        weatherDescription = weatherDesc
    }
}

struct Wind: Codable {
    var speed: Double?
    var deg: Int?
}

struct CityWeatherStore {
    var name: String?
    var temp: Double?
    var feelsLike: Double?
    var weatherDesc: String?
    var formalName: String?
}

struct ForecastStore {
    var name: String?
    var temp: Double?
    var feelsLike: Double?
    var weatherDesc: String?
    var time: String?
    var formalName: String?
    
    init(name: String?, temp: Double?, feelsLike: Double?, weatherDesc: String?, time: String?, formalName: String?) {
        self.name = name
        self.temp = temp
        self.feelsLike = feelsLike
        self.weatherDesc = weatherDesc
        self.time = time
        self.formalName = formalName

    }
}
