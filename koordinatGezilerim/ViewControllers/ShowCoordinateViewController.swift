import UIKit
import FirebaseFirestore
import FirebaseAuth

class ShowCoordinateViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var isGoneSwitch: UISwitch!
    @IBOutlet weak var coordinateVisibiltySwitch: UISwitch!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    let placeholderLabel = UILabel()
    
    var latitude: Double?
    var longitude: Double?
    var country: String?
    
    var uuid: String?
    
    var coordinateInfo: [String: Any] = [:]
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // deleteAccountTextView için delegasyon atanıyor
        commentTextView.delegate = self
        
        // UUID kontrolü yapalım
        if let coordinateInfoID = uuid {
            fetchCoordinateInfo(coordinateInfoID: coordinateInfoID)
        }
        
        titleTextField.textColor = .black
        
        latitudeLabel.alpha = 0
        longitudeLabel.alpha = 0
        
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
        
        if !commentTextView.text.isEmpty{
            commentTextView.addSubview(placeholderLabel)
        }
        
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

    // Firestore'dan verileri fetch etme fonksiyonu
    func fetchCoordinateInfo(coordinateInfoID: String) {
        guard let userEmail = currentUser?.email else { return }
        
        let documentRef = db.collection(userEmail + "-CoordinateInformations").document(coordinateInfoID)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                
                // Gelen verileri ekranda göstermek için kullan
                self.coordinateInfo = data
                
                self.titleTextField.text = data["CityTitle"] as? String
                self.commentTextView.text = data["Comment"] as? String
                self.isGoneSwitch.isOn = data["IsGone"] as? Bool ?? false
                self.country = data["Country"] as? String
                // Eğer latitude ve longitude bilgileri varsa, onları göster
                if let latitude = data["Latitude"] as? Double, let longitude = data["Longitude"] as? Double {
                    self.latitude = latitude
                    self.longitude = longitude
                    self.latitudeLabel.text = "Latitude: \(latitude)"
                    self.longitudeLabel.text = "Longitude: \(longitude)"
                }
            } else {
                AlertManager.showAlert(title: "Error", message: "Document does not exist", viewController: self)
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        if let coordinateInfoID = uuid{
            if titleTextField.text?.isEmpty == false,
               commentTextView.text.isEmpty == false,
               latitudeLabel.text?.isEmpty == false,
               longitudeLabel.text?.isEmpty == false {
                
                coordinateInfo["CityTitle"] = titleTextField.text
                coordinateInfo["Country"] = country
                coordinateInfo["Comment"] = commentTextView.text
                coordinateInfo["Latitude"] = latitude
                coordinateInfo["Longitude"] = longitude
                coordinateInfo["SaveDate"] = FieldValue.serverTimestamp()
                coordinateInfo["IsGone"] = isGoneSwitch.isOn // isGoneSwitch değerini ekledik
                coordinateInfo["UUID"] = coordinateInfoID

                
            } else {
                AlertManager.showAlert(title: "Alert", message: "Please check the fields.", viewController: self)
            }
            
            db.collection((currentUser?.email)!+"-CoordinateInformations").document(coordinateInfoID).setData(coordinateInfo) { error in
                if let error = error {
                    AlertManager.showAlert(title: "Error", message: "Error writing coordinate document: \(error)", viewController: self)
                } else {
                    AlertManager.showAlert(title: "Saved", message: "Coordinate document successfully written!", viewController: self)
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Placeholder'ın görünürlüğünü kontrol et
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
