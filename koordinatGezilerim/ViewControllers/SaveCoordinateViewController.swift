import UIKit
import FirebaseFirestore
import FirebaseAuth

class SaveCoordinateViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var isGoneSwitch: UISwitch!
    @IBOutlet weak var coordinateVisibiltySwitch: UISwitch!
    
    var latitude: Double!
    var longitude: Double!
    var annotationTitle: String!
    var annotationCountry: String!
    
    let placeholderLabel = UILabel()
    
    var coordinateInfo: [String: Any] = [:]
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // deleteAccountTextView için delegasyon atanıyor
        commentTextView.delegate = self
        
        latitudeLabel.alpha = 0
        longitudeLabel.alpha = 0
        
        if let latitude = latitude,
           let longitude = longitude{
            latitudeLabel.text = "Latitude: \(String(describing: latitude))"
            longitudeLabel.text = "Longitude: \(String(describing: longitude))"
        }
        
        if let annotationTitle = annotationTitle{
            titleTextField.text = annotationTitle
        }
        
        titleTextField.textColor = .black

        commentTextView.layer.cornerRadius = 10
        
        // Placeholder Label ayarları
        placeholderLabel.text = "You can write your notes here for these coordinates."
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.numberOfLines = 2 // Çok satırlı olmasını sağlar
        placeholderLabel.lineBreakMode = .byWordWrapping // Kelime kesme modunu ayarla
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !commentTextView.text.isEmpty
        
        // Placeholder Label boyutlandırma ve yerleşim ayarları
        placeholderLabel.frame = CGRect(x: 5, y: 5, width: commentTextView.frame.width, height: 0)
        placeholderLabel.sizeToFit() // İçeriğe göre boyutlandırma
        
        commentTextView.addSubview(placeholderLabel)
        
        isGoneSwitch.isOn = false
        coordinateVisibiltySwitch.isOn = false
        
        coordinateVisibiltySwitch.addTarget(self, action: #selector(coordinateVisibilityChanged(_:)), for: .valueChanged)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeKapat))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func klavyeKapat(){
        view.endEditing(true)
    }
    
    // coordinateVisibiltySwitch değiştiğinde çağrılacak fonksiyon
    @objc func coordinateVisibilityChanged(_ sender: UISwitch) {
        if sender.isOn {
            // Switch açıkken etiketler görünecek
            UIView.animate(withDuration: 0.3) {
                self.latitudeLabel.alpha = 1
                self.longitudeLabel.alpha = 1
            }
        } else {
            // Switch kapalıyken etiketler gizlenecek
            UIView.animate(withDuration: 0.3) {
                self.latitudeLabel.alpha = 0
                self.longitudeLabel.alpha = 0
            }
        }
    }

    @IBAction func saveButton(_ sender: Any) {
        let coordinateInfoID = UUID().uuidString
        
        if titleTextField.text?.isEmpty == false,
           commentTextView.text.isEmpty == false,
           latitudeLabel.text?.isEmpty == false,
           longitudeLabel.text?.isEmpty == false,
           annotationCountry.isEmpty == false {
            
            coordinateInfo["CityTitle"] = titleTextField.text
            coordinateInfo["Country"] = annotationCountry
            coordinateInfo["Comment"] = commentTextView.text
            coordinateInfo["Latitude"] = latitude
            coordinateInfo["Longitude"] = longitude
            coordinateInfo["SaveDate"] = FieldValue.serverTimestamp()
            coordinateInfo["IsGone"] = isGoneSwitch.isOn // isGoneSwitch değerini ekledik
            coordinateInfo["UUID"] = coordinateInfoID 

            db.collection((currentUser?.email)!+"-CoordinateInformations").document(coordinateInfoID).setData(coordinateInfo) { error in
                if let error = error {
                    AlertManager.showAlert(title: "Save Error", message: "Error writing coordinate document: \(error)", viewController: self)
                } else {
                    AlertManager.showAlert(title: "Saved", message: "Coordinate document successfully written!", viewController: self)
                }
            }
        } else {
            AlertManager.showAlert(title: "Alert", message: "Alanları kontrol edin.", viewController: self)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        // Placeholder'ın görünürlüğünü kontrol et
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

