import UIKit
import CoreLocation

class CityListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, CityListDelegeate {

    @IBOutlet weak var tableCollectionSwitch: UISwitch!
    @IBOutlet weak var cityTable: UITableView!
    @IBOutlet weak var cityCollection: UICollectionView!

    var citiesWeathers = [WeatherResponse]()
    var isDataWeatherDeleted = false
    var cityListViewModel = CityListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTable.delegate = self
        cityCollection.delegate = self
        cityTable.dataSource = self
        cityCollection.dataSource = self
        cityListViewModel.delegate = self
        cityListViewModel.checkCoreDataWeathersRequest()
    }
    
    func receivedCitiesWeathers(citiesWeathers: [WeatherResponse]) {
        self.citiesWeathers = citiesWeathers
        selectCityView(isTableOn: getTableSwich())
    }
    
    @IBAction func switchTapped(_ sender: Any) {
        setTableSwich()
        selectCityView(isTableOn: self.getTableSwich())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cityScreen = segue.destination as! CityScreenViewController
        cityScreen.weatherSelected = selectedTableCollection(tableSwitch: tableCollectionSwitch)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesWeathers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableCell") as! CityTableCell
        cell.cityName.text = citiesWeathers[indexPath.row].name
        if let temperature = citiesWeathers[indexPath.row].main?.temp { cell.temperature.text = temperature.description
        }
        if let feelsLike = citiesWeathers[indexPath.row].main?.feelsLike {
            cell.feelsLike.text = StringConstant.FEELS_LIKE + feelsLike.description
        }
        if let weatherDesc =
            citiesWeathers[indexPath.row].weather?[0].weatherDescription {
            cell.descriptionWeather.text = weatherDesc
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citiesWeathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCollectionCell", for: indexPath) as! CityCollectionCell
        cell.cityName.text = citiesWeathers[indexPath.item].name
        guard let mainWeather = citiesWeathers[indexPath.row].main else {
            return cell
        }
        if let temperature = mainWeather.temp {
            cell.temperature.text = temperature.description
        }
        if let feelsLike = mainWeather.feelsLike {
            cell.feelsLike.text = StringConstant.FEELS_LIKE + feelsLike.description
        }
        if let weatherDesc =
            citiesWeathers[indexPath.row].weather?[0].weatherDescription {
            cell.descriptionWeather.text = weatherDesc
        }
        return cell
    }
    
    func selectedTableCollection(tableSwitch: UISwitch) -> WeatherResponse {
        if tableSwitch.isOn {
            return citiesWeathers[cityTable.indexPathForSelectedRow!.row]
        } else {
            return citiesWeathers[(cityCollection.indexPathsForSelectedItems?.last!.item)!]
        }
    }

    func getTableSwich() -> Bool {
        return UserDefaults.standard.bool(forKey: StringConstant.TABLE_SWITCH)
    }
    
    func setTableSwich() {
        UserDefaults.standard.set(tableCollectionSwitch.isOn, forKey: StringConstant.TABLE_SWITCH)
    }
    
    
    func selectCityView(isTableOn: Bool) {
        tableCollectionSwitch.isOn = isTableOn
        if isTableOn {
            cityCollection.isHidden = true
            cityTable.isHidden = false
            cityTable.reloadData()
        } else {
            cityCollection.isHidden = false
            cityTable.isHidden = true
            cityCollection.reloadData()
        }
    }
}
