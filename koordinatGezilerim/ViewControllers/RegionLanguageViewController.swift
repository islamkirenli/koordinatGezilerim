import UIKit
import FirebaseFirestore
import FirebaseAuth

class RegionLanguageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    
    let pickerView = UIPickerView()
    var selectedCountry: String?
    var selectedLanguage: String?
    var coordinateSettings: [String: Any] = [:]
    var languageSettings: [String: Any] = [:]
    
    let db = Firestore.firestore()
    
    let coordinateDocumentID = "coordinateSettings"
    let languageDocumentID = "languageSettigns"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self

        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))

        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true

        regionTextField.inputView = pickerView
        regionTextField.inputAccessoryView = toolbar
        
        // Default olarak ilk seçeneği seçili yap
        pickerView.selectRow(0, inComponent: 0, animated: false)
        selectedCountry = CountriesManager.countries[0]
        regionTextField.text = selectedCountry
        
        languageTextField.inputView = pickerView
        languageTextField.inputAccessoryView = toolbar
        selectedLanguage = LanguageManager.languages[0]
        languageTextField.text = selectedLanguage
        
        // Save butonunu navigation bar'a ekleyin
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveButton
        
        fetchSettingsDataFromFirebase()
    }
    
    // UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if regionTextField.isFirstResponder {
            return CountriesManager.countries.count
        } else if languageTextField.isFirstResponder {
            return LanguageManager.languages.count
        }
        return 0
    }

    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if regionTextField.isFirstResponder {
            return CountriesManager.countries[row]
        } else if languageTextField.isFirstResponder {
            return LanguageManager.languages[row]
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if regionTextField.isFirstResponder {
            selectedCountry = CountriesManager.countries[row]
            regionTextField.text = selectedCountry
        } else if languageTextField.isFirstResponder {
            selectedLanguage = LanguageManager.languages[row]
            languageTextField.text = selectedLanguage
        }
    }

    @objc func doneAction() {
        if regionTextField.isFirstResponder {
            regionTextField.text = selectedCountry ?? CountriesManager.countries[0]
        } else if languageTextField.isFirstResponder {
            languageTextField.text = selectedLanguage ?? LanguageManager.languages[0]
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelAction() {
        self.view.endEditing(true)
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
        }

        if let selectedLanguage = selectedLanguage {
            languageSettings["language"] = selectedLanguage
        }

        // Koordinat verilerini Firebase'e kaydet
        db.collection("user").document(coordinateDocumentID).setData(coordinateSettings) { error in
            if let error = error {
                print("Error writing coordinate document: \(error)")
            } else {
                print("Coordinate document successfully written!")
            }
        }
        
        // Dil verilerini Firebase'e kaydet
        db.collection("user").document(languageDocumentID).setData(languageSettings) { error in
            if let error = error {
                print("Error writing coordinate document: \(error)")
            } else {
                print("Language document successfully written!")
            }
        }
    }

    func fetchSettingsDataFromFirebase() {
        // Koordinat verilerini Firebase'den al
        let coordinateDocRef = db.collection("user").document(coordinateDocumentID)
        coordinateDocRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let country = data?["country"] as? String {
                    self?.regionTextField.text = country
                }
            } else {
                print("Coordinate document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        // Dil verilerini Firebase'den al
        let languageDocRef = db.collection("user").document(languageDocumentID)
        languageDocRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let language = data?["language"] as? String {
                    self?.languageTextField.text = language
                }
            } else {
                print("Language document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
