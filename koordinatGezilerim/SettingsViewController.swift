/*import UIKit
import FirebaseFirestore

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerView = UIPickerView()
    var selectedCountry: String?

    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeKapat))
        view.addGestureRecognizer(gestureRecognizer)
        
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

        countryTextField.inputView = pickerView
        countryTextField.inputAccessoryView = toolbar

        // TextField değişimlerini dinle
        countryTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
                
        // Default olarak ilk seçeneği seçili yap
        pickerView.selectRow(0, inComponent: 0, animated: false)
        selectedCountry = CountriesManager.countries[0]
        countryTextField.text = selectedCountry
        updateCoordinatesLabel(for: selectedCountry!)
        
        // Save butonunu navigation bar'a ekleyin
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveButton
        
        fetchSettingsDataFromFirebase()
    }
    
    @objc func klavyeKapat(){
        self.view.endEditing(true)
    }

    // UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CountriesManager.countries.count
    }

    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CountriesManager.countries[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = CountriesManager.countries[row]
        countryTextField.text = selectedCountry
    }

    @objc func doneAction() {
        if let selectedCountry = selectedCountry {
            countryTextField.text = selectedCountry
            updateCoordinatesLabel(for: selectedCountry)
        } else {
            countryTextField.text = CountriesManager.countries[0]
            updateCoordinatesLabel(for: CountriesManager.countries[0])
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelAction() {
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange() {
        guard let text = countryTextField.text else { return }
        
        if let index = CountriesManager.countries.firstIndex(of: text) {
            pickerView.selectRow(index, inComponent: 0, animated: true)
            selectedCountry = text
            updateCoordinatesLabel(for: text)
        }
    }
    
    private func updateCoordinatesLabel(for country: String) {
        if let coordinatesRange = CountriesManager.countryCoordinatesRanges[country] {
            coordinatesLabel.text = """
            North: \(coordinatesRange.north)
            South: \(coordinatesRange.south)
            East: \(coordinatesRange.east)
            West: \(coordinatesRange.west)
            """
        }
    }
    
    @objc func saveAction() {
        var settingsData: [String: Any] = [:]
        print("Save button tapped")
        
        if let selectedCountry = selectedCountry {
            if let coordinatesRange = CountriesManager.countryCoordinatesRanges[selectedCountry] {
                settingsData["north"] = coordinatesRange.north
                settingsData["south"] = coordinatesRange.south
                settingsData["east"] = coordinatesRange.east
                settingsData["west"] = coordinatesRange.west
                if selectedCountry != "Global" {
                    settingsData["country"] = selectedCountry
                }
            }
        } else {
            if let coordinatesRange = CountriesManager.countryCoordinatesRanges[CountriesManager.countries[0]] {
                settingsData["north"] = coordinatesRange.north
                settingsData["south"] = coordinatesRange.south
                settingsData["east"] = coordinatesRange.east
                settingsData["west"] = coordinatesRange.west
                if selectedCountry != "Global" {
                    settingsData["country"] = selectedCountry
                }
            }
        }
                
        // Kullanıcı id veya benzeri bir doküman id'si ile veriyi saklayabilirsiniz
        // Örneğin:
        let documentID = "settings" // Bu doküman ID'yi ihtiyacınıza göre belirleyin

        db.collection("user").document(documentID).setData(settingsData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }

        // Firebase'e veri kaydedildikten sonra sayfayı kapatın
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchSettingsDataFromFirebase() {
        let documentID = "settings" // Bu doküman ID'yi ihtiyacınıza göre belirleyin
        let docRef = db.collection("user").document(documentID)
        
        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self?.countryTextField.text = data?["country"] as? String
            } else {
                print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                // Burada bir hata mesajı gösterebilir veya bir varsayılan işlem yapabilirsiniz
            }
        }
    }
}
*/

import UIKit
import FirebaseFirestore

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerView = UIPickerView()
    var selectedCountry: String?

    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeKapat))
        view.addGestureRecognizer(gestureRecognizer)
        
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

        countryTextField.inputView = pickerView
        countryTextField.inputAccessoryView = toolbar

        // TextField değişimlerini dinle
        countryTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
                
        // Default olarak ilk seçeneği seçili yap
        pickerView.selectRow(0, inComponent: 0, animated: false)
        selectedCountry = CountriesManager.countries[0]
        countryTextField.text = selectedCountry
        updateCoordinatesLabel(for: selectedCountry!)
        
        // Save butonunu navigation bar'a ekleyin
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveButton
        
        fetchSettingsDataFromFirebase()
    }
    
    @objc func klavyeKapat(){
        self.view.endEditing(true)
    }

    // UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CountriesManager.countries.count
    }

    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CountriesManager.countries[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = CountriesManager.countries[row]
        countryTextField.text = selectedCountry
    }

    @objc func doneAction() {
        if let selectedCountry = selectedCountry {
            countryTextField.text = selectedCountry
            updateCoordinatesLabel(for: selectedCountry)
        } else {
            countryTextField.text = CountriesManager.countries[0]
            updateCoordinatesLabel(for: CountriesManager.countries[0])
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelAction() {
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange() {
        guard let text = countryTextField.text?.lowercased() else { return }
        
        if let index = CountriesManager.countries.firstIndex(where: { $0.lowercased() == text }) {
            pickerView.selectRow(index, inComponent: 0, animated: true)
            selectedCountry = CountriesManager.countries[index]
            updateCoordinatesLabel(for: selectedCountry!)
        }
    }
    
    private func updateCoordinatesLabel(for country: String) {
        if let coordinatesRange = CountriesManager.countryCoordinatesRanges[country] {
            coordinatesLabel.text = """
            North: \(coordinatesRange.north)
            South: \(coordinatesRange.south)
            East: \(coordinatesRange.east)
            West: \(coordinatesRange.west)
            """
        }
    }
    
    @objc func saveAction() {
        var settingsData: [String: Any] = [:]
        print("Save button tapped")
        
        if let selectedCountry = selectedCountry {
            if let coordinatesRange = CountriesManager.countryCoordinatesRanges[selectedCountry] {
                settingsData["north"] = coordinatesRange.north
                settingsData["south"] = coordinatesRange.south
                settingsData["east"] = coordinatesRange.east
                settingsData["west"] = coordinatesRange.west
                if selectedCountry != "Global" {
                    settingsData["country"] = selectedCountry
                }
            }
        } else {
            if let coordinatesRange = CountriesManager.countryCoordinatesRanges[CountriesManager.countries[0]] {
                settingsData["north"] = coordinatesRange.north
                settingsData["south"] = coordinatesRange.south
                settingsData["east"] = coordinatesRange.east
                settingsData["west"] = coordinatesRange.west
                if selectedCountry != "Global" {
                    settingsData["country"] = selectedCountry
                }
            }
        }
                
        let documentID = "settings"

        db.collection("user").document(documentID).setData(settingsData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchSettingsDataFromFirebase() {
        let documentID = "settings"
        let docRef = db.collection("user").document(documentID)
        
        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let country = data?["country"] as? String {
                    self?.countryTextField.text = country
                    self?.textFieldDidChange()
                }
            } else {
                print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

