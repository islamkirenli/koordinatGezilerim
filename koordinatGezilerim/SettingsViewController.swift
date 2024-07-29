import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func didSaveSettings(data: [String: Any])
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: SettingsViewControllerDelegate?

    let pickerView = UIPickerView()
    var selectedCountry: String?

    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var customCoordinatesView: UIView!
    @IBOutlet weak var northTextField: UITextField!
    @IBOutlet weak var southTextField: UITextField!
    @IBOutlet weak var eastTextField: UITextField!
    @IBOutlet weak var westTextField: UITextField!
    
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
        
        customCoordinatesView.isHidden = true
        
        // Default olarak ilk seçeneği seçili yap
        pickerView.selectRow(0, inComponent: 0, animated: false)
        selectedCountry = CountriesManager.countries[0]
        countryTextField.text = selectedCountry
        updateCoordinatesLabel(for: selectedCountry!)
        
        // Save butonunu navigation bar'a ekleyin
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveButton
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
        if selectedCountry == "Custom" {
            customCoordinatesView.isHidden = false
        } else {
            customCoordinatesView.isHidden = true
        }
    }

    @objc func doneAction() {
        if let selectedCountry = selectedCountry {
            countryTextField.text = selectedCountry
            if selectedCountry == "Custom" {
                // Kullanıcıdan alınan koordinat aralıklarını oku ve göster
                if let north = Double(northTextField.text ?? ""),
                   let south = Double(southTextField.text ?? ""),
                   let east = Double(eastTextField.text ?? ""),
                   let west = Double(westTextField.text ?? "") {
                    updateCustomCoordinatesLabel(north: north, south: south, east: east, west: west)
                }
            } else {
                updateCoordinatesLabel(for: selectedCountry)
            }
        } else {
            countryTextField.text = CountriesManager.countries[0]
            updateCoordinatesLabel(for: CountriesManager.countries[0])
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelAction() {
        self.view.endEditing(true)
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
    
    private func updateCustomCoordinatesLabel(north: Double, south: Double, east: Double, west: Double) {
        coordinatesLabel.text = """
        North: \(north)
        South: \(south)
        East: \(east)
        West: \(west)
        """
    }
    
    @objc func saveAction() {
        var settingsData: [String: Any] = [:]
        print("Save button tapped")
        
        if let selectedCountry = selectedCountry {
            if selectedCountry == "Custom" {
                // Kullanıcıdan alınan koordinat aralıklarını oku ve göster
                if let north = Double(northTextField.text ?? ""),
                   let south = Double(southTextField.text ?? ""),
                   let east = Double(eastTextField.text ?? ""),
                   let west = Double(westTextField.text ?? "") {
                    updateCustomCoordinatesLabel(north: north, south: south, east: east, west: west)
                }
            } else {
                if let coordinatesRange = CountriesManager.countryCoordinatesRanges[selectedCountry] {
                    settingsData["north"] = coordinatesRange.north
                    settingsData["south"] = coordinatesRange.south
                    settingsData["east"] = coordinatesRange.east
                    settingsData["west"] = coordinatesRange.west
                    if selectedCountry != "Custom" && selectedCountry != "Global"{
                        settingsData["country"] = selectedCountry
                    }
                }
            }
        } else {
            if let coordinatesRange = CountriesManager.countryCoordinatesRanges[CountriesManager.countries[0]] {
                settingsData["north"] = coordinatesRange.north
                settingsData["south"] = coordinatesRange.south
                settingsData["east"] = coordinatesRange.east
                settingsData["west"] = coordinatesRange.west
                if selectedCountry != "Custom" && selectedCountry != "Global"{
                    settingsData["country"] = selectedCountry
                }
            }
        }
        
        delegate?.didSaveSettings(data: settingsData)
        self.dismiss(animated: true, completion: nil)
    }
}
