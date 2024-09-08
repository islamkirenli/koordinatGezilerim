import UIKit
import FirebaseFirestore

class SaveCoordinateViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    var latitude: Double!
    var longitude: Double!
    var annotationTitle: String!
    var annotationCountry: String!
    
    var coordinateInfo: [String: Any] = [:]
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let latitude = latitude,
           let longitude = longitude{
            latitudeLabel.text = "Latitude: \(String(describing: latitude))"
            longitudeLabel.text = "Longitude: \(String(describing: longitude))"
        }
        
        if let annotationTitle = annotationTitle{
            titleTextField.text = annotationTitle
        }

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeKapat))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func klavyeKapat(){
        view.endEditing(true)
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
        }else{
            print("alanları kontrol edin.")
        }
        
        db.collection("user-CoordinateInformations").document(coordinateInfoID).setData(coordinateInfo) { error in
            if let error = error {
                print("Error writing coordinate document: \(error)")
            } else {
                print("Coordinate document successfully written!")
            }
        }
    }
}

