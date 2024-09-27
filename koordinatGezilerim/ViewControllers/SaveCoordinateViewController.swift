import UIKit
import FirebaseFirestore
import FirebaseAuth

class SaveCoordinateViewController: UIViewController {
    
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
    
    var coordinateInfo: [String: Any] = [:]
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        titleTextField.textColor = .white

        commentTextView.layer.cornerRadius = 10
        
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

            
        } else {
            print("alanları kontrol edin.")
        }
        
        db.collection((currentUser?.email)!+"-CoordinateInformations").document(coordinateInfoID).setData(coordinateInfo) { error in
            if let error = error {
                print("Error writing coordinate document: \(error)")
            } else {
                print("Coordinate document successfully written!")
            }
        }
    }

}

