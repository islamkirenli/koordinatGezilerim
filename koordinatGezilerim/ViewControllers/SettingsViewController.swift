/*import UIKit
import FirebaseFirestore
import FirebaseAuth

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerView = UIPickerView()
    var selectedCountry: String?
    var coordinateSettings: [String: Any] = [:]
    var backgroundSettings: [String: Any] = [:]

    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        pickerView.delegate = self
        pickerView.dataSource = self

        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        //let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))

        //toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        //toolbar.isUserInteractionEnabled = true

        countryTextField.inputView = pickerView
        countryTextField.inputAccessoryView = toolbar

        // TextField değişimlerini dinle
        //countryTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
                
        // Default olarak ilk seçeneği seçili yap
        pickerView.selectRow(0, inComponent: 0, animated: false)
        selectedCountry = CountriesManager.countries[0]
        countryTextField.text = selectedCountry
        
        // Save butonunu navigation bar'a ekleyin
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveButton
        
        fetchSettingsDataFromFirebase()
    }

    
    @IBAction func selectBackground(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Background", message: nil, preferredStyle: .actionSheet)
        
        let backgrounds = ["background6", "space_background", "space_background2", "space_background3", "space_background4", "space_background5"]
        
        for background in backgrounds {
            actionSheet.addAction(UIAlertAction(title: background, style: .default, handler: { [weak self] action in
                self?.backgroundSelected(background, sender: sender)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func backgroundSelected(_ background: String, sender: Any) {
        // Seçilen arka planı backgroundSettings'e kaydet
        backgroundSettings["background"] = background
        
        backgroundImageView.image = UIImage(named: background)
        
        // Butonun başlığını güncelle
        if let button = sender as? UIButton {
            button.setTitle(background, for: .normal)
        }
                
        // UI'yi güncelleyebilirsin, örneğin bir label ya da preview'i güncellemek gibi
        print("Arka Plan Seçildi: \(background)")
    }
    
    @objc func saveAction() {
        print("Save button tapped")
        
        if let selectedCountry = selectedCountry {
            if let coordinatesRange = CountriesManager.countryCoordinatesRanges[selectedCountry] {
                coordinateSettings["north"] = coordinatesRange.north
                coordinateSettings["south"] = coordinatesRange.south
                coordinateSettings["east"] = coordinatesRange.east
                coordinateSettings["west"] = coordinatesRange.west
                if selectedCountry != "Global" {
                    coordinateSettings["country"] = selectedCountry
                }
            }
        } else {
            if let coordinatesRange = CountriesManager.countryCoordinatesRanges[CountriesManager.countries[0]] {
                coordinateSettings["north"] = coordinatesRange.north
                coordinateSettings["south"] = coordinatesRange.south
                coordinateSettings["east"] = coordinatesRange.east
                coordinateSettings["west"] = coordinatesRange.west
                if selectedCountry != "Global" {
                    coordinateSettings["country"] = selectedCountry
                }
            }
        }
                
        let coordinateDocumentID = "coordinateSettings"
        let backgroundDocumentID = "backgroundSettings"

        // Koordinat verilerini Firebase'e kaydet
        db.collection("user").document(coordinateDocumentID).setData(coordinateSettings) { error in
            if let error = error {
                print("Error writing coordinate document: \(error)")
            } else {
                print("Coordinate document successfully written!")
            }
        }
        
        // Arka plan verisini Firebase'e kaydet
        db.collection("user").document(backgroundDocumentID).setData(backgroundSettings) { error in
            if let error = error {
                print("Error writing background document: \(error)")
            } else {
                print("Background document successfully written!")
                NotificationCenter.default.post(name: NSNotification.Name("BackgroundDidChange"), object: nil)
            }
        }

        //self.dismiss(animated: true, completion: nil)
    }
    
    func fetchSettingsDataFromFirebase() {
        let backgroundDocumentID = "backgroundSettings"
        
        // Arka plan verisini Firebase'den al
        let backgroundDocRef = db.collection("user").document(backgroundDocumentID)
        backgroundDocRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let background = data?["background"] as? String {
                    self?.backgroundButton.setTitle(background, for: .normal)
                    self?.backgroundSelected(background, sender: self?.backgroundButton as Any)
                }
            } else {
                print("Background document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
*/

