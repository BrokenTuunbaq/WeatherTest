import UIKit

class CityScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var forecastTable: UITableView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    let networkManager = NetworkManager()
    var weatherSelected: WeatherResponse?
    var forecast: ForecastResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastTable.delegate = self
        forecastTable.dataSource = self
        
        guard let cityNameSelected = weatherSelected?.name else { return }
        guard let weatherSelected = weatherSelected else { return }
        
        initCityWeather(weather: weatherSelected)
        forecast = CoreDataHelper().retrieveDataForecast(cityName: weatherSelected.getName()!)
        forecastTable.reloadData()
        
        requestForecast(cityName: cityNameSelected)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell") as! ForecastCell
        cell.temperature.text = forecast?.list?[indexPath.row].main?.temp?.description
        cell.feelsLike.text = forecast?.list?[indexPath.row].main?.feelsLike?.description
        cell.forecastDescription.text = forecast?.list?[indexPath.row].weather?[0].weatherDescription
        cell.weatherTime.text = forecast?.list?[indexPath.row].dtTxt
        return cell
    }
    
    func requestForecast(cityName: String) {
        networkManager.forecastByCity(cityName: cityName, days: StringConstant.DAYS_CONST, completion: {
            (forecast, error) in
            if let error = error {
                print(error)
                return
            }
            guard let forecast = forecast else {
                return
            }
            self.forecast = forecast
            CoreDataHelper().deleteDataForecast(cityName: cityName)
            CoreDataHelper().storeData(forecast: forecast)
            DispatchQueue.main.async {
                self.forecastTable.reloadData()
            }
        })
    }
    
    func initCityWeather(weather: WeatherResponse) {
        cityName.text = weather.name
        if let temp = weather.main?.temp {
            temperature.text = temp.description
        }
        if let feels = weather.main?.feelsLike {
            feelsLike.text = StringConstant.FEELS_LIKE + feels.description
        }
        weatherDescription.text = weather.weather![0].weatherDescription
    }
}
