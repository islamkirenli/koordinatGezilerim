import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")

        // Ensure the hex code is valid (6 characters)
        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!    
    
    @IBOutlet weak var darkModeSwitchOutlet: UISwitch!
    @IBOutlet weak var chevronRightOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Köşe yuvarlatma ve maskeleme
        //contentView.layer.cornerRadius = 3 // Köşelerin yuvarlatılma oranı
        contentView.layer.masksToBounds = true // İçeriklerin taşmasını önler
        contentView.layer.borderWidth = 0.1 // İsterseniz kenarlık ekleyebilirsiniz
        contentView.layer.borderColor = UIColor.darkGray.cgColor // Kenarlık rengini ayarlayabilirsiniz
        contentView.backgroundColor = UIColor(hex: "#0f1418")
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


