import UIKit

class ForecastCell: UITableViewCell {
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    
    @IBOutlet weak var forecastDescription: UILabel!
    @IBOutlet weak var weatherTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
