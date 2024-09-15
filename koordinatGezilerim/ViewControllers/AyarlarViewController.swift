import UIKit
import FirebaseAuth

class AyarlarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let sections = ["Account", "Personalization", "Accessibility & Advanced", ""]
    let accountItems = ["Profile & Accounts", "Privacy & Security"]
    let personalizationItems = ["Dark Mode", "Region & Language", "Themes Organize"]
    let accessibilityItems = ["Help & Feedback", "Permissions", "About", "Support Us"]
    let signOutItems = ["Sign Out"]
    
    // İkonlar
    let accountIcons = ["person.crop.circle", "lock"]
    let personalizationIcons = ["moon", "globe", "books.vertical"]
    let accessibilityIcons = ["smiley.fill", "lock.shield", "questionmark.circle", "heart"]
    let signOutIcons = ["rectangle.portrait.and.arrow.right"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Scroll çubuğunu gizlemek
        tableView.showsVerticalScrollIndicator = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return accountItems.count
        } else if section == 1 {
            return personalizationItems.count
        } else if section == 2 {
            return accessibilityItems.count
        } else {
            return signOutItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        
        // Hücre içeriğini ayarlama
        if indexPath.section == 0 {
            cell.titleLabel.text = accountItems[indexPath.row]
            cell.iconImageView.image = UIImage(systemName: accountIcons[indexPath.row])
        } else if indexPath.section == 1 {
            cell.titleLabel.text = personalizationItems[indexPath.row]
            cell.iconImageView.image = UIImage(systemName: personalizationIcons[indexPath.row])
        } else if indexPath.section == 2 {
            cell.titleLabel.text = accessibilityItems[indexPath.row]
            cell.iconImageView.image = UIImage(systemName: accessibilityIcons[indexPath.row])
        } else {
            cell.titleLabel.text = signOutItems[indexPath.row]
            cell.iconImageView.image = UIImage(systemName: signOutIcons[indexPath.row])
        }
        
        // Köşe yuvarlama işlemi
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        let cornerRadius: CGFloat = 10
        
        if indexPath.row == 0 && indexPath.row == totalRows - 1 {
            // Tek hücrelik bir grup (ilk ve son aynı hücre)
            cell.layer.cornerRadius = cornerRadius
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if indexPath.row == 0 {
            // İlk hücre (üst köşeler yuvarlak)
            cell.layer.cornerRadius = cornerRadius
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == totalRows - 1 {
            // Son hücre (alt köşeler yuvarlak)
            cell.layer.cornerRadius = cornerRadius
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            // Ara hücreler (köşe yuvarlaması yok)
            cell.layer.cornerRadius = 0
        }

        return cell
    }

    // Hücreye tıklama işlemi
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                print("Profile & Accounts")
            case 1:
                print("Privacy & Security")
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                print("Dark Mode")
            case 1:
                print("Region & Language")
            case 2:
                print("Themes Organize")
            default:
                break
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                print("Help & Feedback")
            case 1:
                print("Permissions")
            case 2:
                print("About")
            case 3:
                print("Support Us")
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                print("Sign Out")
                logOutUser()
            default:
                break
            }
            
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear // İsterseniz renk ekleyebilirsiniz

        let label = UILabel()
        label.frame = CGRect(x: 16, y: 0, width: tableView.frame.width, height: 40) // Yüksekliği ayarlayın
        label.font = UIFont.boldSystemFont(ofSize: 24) // Font büyüklüğünü ayarlayın
        label.textColor = UIColor.white // Yazı rengini ayarlayın
        label.text = sections[section] // Section başlığı

        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 // Yüksekliği istediğiniz değere göre ayarlayın
    }
    
    func logOutUser() {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLoginVC", sender: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
