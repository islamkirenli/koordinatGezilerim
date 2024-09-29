import UIKit
import FirebaseAuth
import MessageUI

class AyarlarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chevronRightIconOutlet: UIImageView!
    @IBOutlet weak var darkModeSwitchOutlet: UISwitch!
    
    
    let sections = ["Account", "Personalization", "Accessibility & Advanced", ""]
    let accountItems = ["Profile & Accounts", "Privacy & Security"]
    let personalizationItems = ["Region"]
    let accessibilityItems = ["Help & Feedback", "Permissions", "About", "Support Us"]
    let signOutItems = ["Sign Out"]
    
    // İkonlar
    let accountIcons = ["person.crop.circle", "lock"]
    let personalizationIcons = ["globe"]
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
            if indexPath.row == 0 {
                // Dark Mode satırı
                cell.titleLabel.text = personalizationItems[indexPath.row]
                cell.iconImageView.image = UIImage(systemName: personalizationIcons[indexPath.row])
            } else {
                // Diğer personalization satırları
                cell.titleLabel.text = personalizationItems[indexPath.row]
                cell.iconImageView.image = UIImage(systemName: personalizationIcons[indexPath.row])
            }
        } else if indexPath.section == 2 {
            cell.titleLabel.text = accessibilityItems[indexPath.row]
            cell.iconImageView.image = UIImage(systemName: accessibilityIcons[indexPath.row])
        } else {
            cell.titleLabel.text = signOutItems[indexPath.row]
            cell.iconImageView.image = UIImage(systemName: signOutIcons[indexPath.row])
        }
        
        // Separator'ın alt satırlarda olmamasını sağlama
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
                performSegue(withIdentifier: "toProfilAccountVC", sender: nil)
            case 1:
                print("Privacy & Security")
                performSegue(withIdentifier: "toPrivacySecurityVC", sender: nil)
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                print("Region & Language")
                performSegue(withIdentifier: "toRegionLanguageVC", sender: nil)
            default:
                break
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                print("Help & Feedback")
                sendFeedbackEmail()
            case 1:
                print("Permissions")
                openAppPermissions()
            case 2:
                print("About")
                performSegue(withIdentifier: "toAboutVC", sender: nil)
            case 3:
                print("Support Us")
                showSupportOptions()
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
        headerView.backgroundColor = UIColor.clear

        let label = UILabel()
        label.frame = CGRect(x: 16, y: 0, width: tableView.frame.width, height: 40)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.white
        label.text = sections[section]

        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func logOutUser() {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLoginVC", sender: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            AlertManager.showAlert(title: "Error", message: "Error signing out: \(signOutError)", viewController: self)
        }
    }
    
    // Kullanıcıyı ayarlar sayfasına yönlendirme
    func openAppPermissions() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    // E-posta göndermek için mail composer
    func sendFeedbackEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["randomjourneyapp@gmail.com"])
            mailComposeVC.setSubject("Help & Feedback")
            mailComposeVC.setMessageBody("Please write your feedback here...", isHTML: false)
            
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            AlertManager.showAlert(title: "Mail Gönderilemiyor", message: "Mail uygulaması bulunamadı. Lütfen cihazınıza mail hesabı ekleyin.", viewController: self)
        }
    }

    // Kullanıcıya destek seçenekleri göstermek için
    func showSupportOptions() {
        let alertController = UIAlertController(title: "Support Us", message: "Please choose an option to support us", preferredStyle: .actionSheet)
        
        let twitterAction = UIAlertAction(title: "Follow us on X", style: .default) { _ in
            self.openURL("https://twitter.com/your_twitter_profile")
        }
        
        let instagramAction = UIAlertAction(title: "Follow us on Instagram", style: .default) { _ in
            self.openURL("https://instagram.com/your_instagram_profile")
        }
        
        let appStoreAction = UIAlertAction(title: "Rate us on the App Store", style: .default) { _ in
            self.openURL("https://apps.apple.com/app/id123456789") // App Store URL'si
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(twitterAction)
        alertController.addAction(instagramAction)
        alertController.addAction(appStoreAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(alertController, animated: true, completion: nil)
    }
    
    // URL açma fonksiyonu
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MFMailComposeViewControllerDelegate metodu
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func toggleDarkMode(isOn: Bool) {
        if isOn {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }

}


