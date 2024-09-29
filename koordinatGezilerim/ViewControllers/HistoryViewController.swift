import UIKit
import FirebaseFirestore
import FirebaseAuth
import MapKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate{

    @IBOutlet weak var tableView: UITableView!

    var sections: [Section] = []
    var itemDictionary: [String: [(city: String, uuid: String)]] = [:] // Country -> CityTitles sözlüğü
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    var addedCountries: Set<String> = [] // Eklenen Country değerlerini takip etmek için Set
    var coordinates: [(city: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, isGone: Bool, uuid: String)] = []

    var isSelectionMode = false
    var selectedItems: [IndexPath] = []
        
    var selectedUUID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView delegate ve datasource ataması
        tableView.delegate = self
        tableView.dataSource = self

        // Firestore'dan verileri çek ve dizileri doldur
        fetchSectionsFromFirestore()
        
        // Sağ üst köşeye "Select" butonu ekleyin
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
        
        // Add the floating map button
        addFloatingMapButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    
    @objc func selectButtonTapped() {
        isSelectionMode.toggle()

        if isSelectionMode {
            // Seçim moduna girildiğinde butonun adını "Cancel" olarak değiştirin
            navigationItem.rightBarButtonItem?.title = "Cancel"
            
            // "Delete" butonu ekle
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSelectedItems))
        } else {
            // Seçim modu iptal edildiğinde butonun adını tekrar "Select" olarak değiştirin
            navigationItem.rightBarButtonItem?.title = "Select"
            
            // Seçim modundan çıkıldığında "Delete" butonunu kaldırın ve seçimleri temizleyin
            navigationItem.leftBarButtonItem = nil
            selectedItems.removeAll()
        }

        // Tablodaki tüm bölümleri ve satırları yeniden yükleyin
        tableView.reloadData()
    }
    
    // Toplu silme işlemi için buton ekleyin
    @objc func deleteSelectedItems() {
        // Seçimlerin tersinden (en son seçilenden başlayarak) silinmesi için, seçili öğeleri ters sırayla işleyelim.
        let reversedSelectedItems = selectedItems.sorted(by: { $0.section > $1.section })

        for indexPath in reversedSelectedItems {
            if indexPath.row == -1 {
                // Bölüm silme işlemi (bölüm altındaki tüm şehirleri sil)
                let section = indexPath.section
                let country = sections[section].title

                // Firestore'dan bölüm altındaki tüm şehirleri sil
                if let cities = itemDictionary[country] {
                    for city in cities {
                        db.collection((currentUser?.email)!+"-CoordinateInformations").whereField("Country", isEqualTo: country).whereField("CityTitle", isEqualTo: city.city).getDocuments { (snapshot, error) in
                            if let error = error {
                                AlertManager.showAlert(title: "Error!", message: "Error deleting document: \(error)", viewController: self)
                            } else {
                                for document in snapshot!.documents {
                                    document.reference.delete { error in
                                        if let error = error {
                                            AlertManager.showAlert(title: "Delete Error", message: "Error deleting document: \(error)", viewController: self)
                                        } else {
                                            AlertManager.showAlert(title: "Deleted", message: "Document successfully deleted!", viewController: self)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // itemDictionary ve sections'dan bölümü sil
                itemDictionary.removeValue(forKey: country)
                sections.remove(at: section)
                tableView.deleteSections(IndexSet(integer: section), with: .automatic)
            } else {
                // Satır silme işlemi
                let section = indexPath.section
                let country = sections[section].title
                var cities = itemDictionary[country]!
                
                let cityToDelete = cities[indexPath.row]

                // Firestore'dan veriyi sil
                db.collection((currentUser?.email)!+"-CoordinateInformations").whereField("Country", isEqualTo: country).whereField("CityTitle", isEqualTo: cityToDelete.city).getDocuments { (snapshot, error) in
                    if let error = error {
                        AlertManager.showAlert(title: "Error!", message: "Error deleting document: \(error)", viewController: self)
                    } else {
                        for document in snapshot!.documents {
                            document.reference.delete { error in
                                if let error = error {
                                    AlertManager.showAlert(title: "Delete Error", message: "Error deleting document: \(error)", viewController: self)
                                } else {
                                    AlertManager.showAlert(title: "Deleted", message: "Document successfully deleted!", viewController: self)
                                }
                            }
                        }
                    }
                }

                // Diziden şehri sil
                cities.remove(at: indexPath.row)
                itemDictionary[country] = cities
                
                if cities.isEmpty {
                    // Eğer bölümde başka şehir kalmadıysa, bölümü de kaldır
                    itemDictionary.removeValue(forKey: country)
                    sections.remove(at: section)
                    tableView.deleteSections(IndexSet(integer: section), with: .automatic)
                } else {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }

        // Seçim modunu kapat ve butonları geri yükle
        selectedItems.removeAll()
        isSelectionMode = false
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem?.title = "Select"
        
        // Tabloyu yeniden yükleyin (ok işaretlerini geri getirmek için)
        tableView.reloadData()
    }
    
    // Add the floating button in the bottom right corner
    func addFloatingMapButton() {
        let button = UIButton(type: .system)
        
        // Set the map icon using SF Symbols
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 34, weight: .bold, scale: .large)
        let mapImage = UIImage(systemName: "map", withConfiguration: largeConfig)
        button.setImage(mapImage, for: .normal)
        
        // Button appearance settings
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 30 // Half of the button height and width to make it circular
        button.layer.masksToBounds = true
        
        // Add the button action
        button.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(button)
        
        // Set Auto Layout constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 80),
            button.widthAnchor.constraint(equalToConstant: 80),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // Action for the map button
    @objc func mapButtonTapped() {
        performSegue(withIdentifier: "toMapVC", sender: self)
    }

    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    // Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Eğer bölüm genişletildiyse, ilgili ülkenin şehir sayısını döndür
        if sections[section].isExpanded {
            return itemDictionary[sections[section].title]?.count ?? 0
        } else {
            return 0
        }
    }

    // Cell for row at index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = UIColor(hex: "#0f1418")
        
        // İlgili section için CityTitle bilgisini itemDictionary'den al ve alfabetik sırada göster
        let country = sections[indexPath.section].title
        if let cities = itemDictionary[country] {
            cell.textLabel?.text = cities[indexPath.row].city
        }

        if isSelectionMode {
            // Sağ tarafta çember ikonu ekleyin
            let isSelected = selectedItems.contains(indexPath)
            cell.accessoryView = UIImageView(image: UIImage(systemName: isSelected ? "checkmark.circle.fill" : "circle"))
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }

    // Height for header in section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    // Custom view for header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()

        let label = UILabel()
        label.text = sections[section].title
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.frame = CGRect(x: 16, y: 8, width: tableView.frame.width - 64, height: 28)
        headerView.addSubview(label)

        if isSelectionMode {
            // Seçim modundayken sadece çember ikonu göster
            let isSelected = selectedItems.contains { $0.section == section && $0.row == -1 }
            let circleImageView = UIImageView(image: UIImage(systemName: isSelected ? "checkmark.circle.fill" : "circle"))
            circleImageView.frame = CGRect(x: tableView.frame.width - 36, y: 14, width: 16, height: 16)
            headerView.addSubview(circleImageView)
        } else {
            // Seçim modu değilse ok işaretini göster
            let arrowImageView = UIImageView()
            arrowImageView.frame = CGRect(x: tableView.frame.width - 36, y: 14, width: 16, height: 16)
            arrowImageView.contentMode = .scaleAspectFit
            arrowImageView.image = UIImage(systemName: sections[section].isExpanded ? "chevron.up" : "chevron.down")
            headerView.addSubview(arrowImageView)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapHeader(_:)))
        headerView.addGestureRecognizer(tapGesture)
        headerView.tag = section

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = sections[indexPath.section].title
        print(country)
        if let cities = itemDictionary[country] {
            let selectedCity = cities[indexPath.row]
            // UUID bilgisini ShowViewController'a aktar
            selectedUUID = selectedCity.uuid
        }
        
        if isSelectionMode {
            if let index = selectedItems.firstIndex(of: indexPath) {
                selectedItems.remove(at: index)
            } else {
                selectedItems.append(indexPath)
            }
            
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        if isSelectionMode == false{
            performSegue(withIdentifier: "toShowVC", sender: self)
        }
    }

    @objc func didTapHeader(_ sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else { return }

        if isSelectionMode {
            let indexPath = IndexPath(row: -1, section: section)
            if let index = selectedItems.firstIndex(of: indexPath) {
                selectedItems.remove(at: index)
            } else {
                selectedItems.append(indexPath)
            }
            
            tableView.reloadSections([section], with: .none)
        } else {
            sections[section].isExpanded.toggle()
            tableView.reloadSections([section], with: .automatic)
        }
    }

    // Firestore'dan verileri çek ve sections dizisini doldur
    func fetchSectionsFromFirestore() {
        db.collection((currentUser?.email)!+"-CoordinateInformations").getDocuments { (snapshot, error) in
            if let error = error {
                AlertManager.showAlert(title: "Error!", message: "Error getting documents: \(error)", viewController: self)
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    let country = data["Country"] as? String ?? "Unknown Country"
                    let city = data["CityTitle"] as? String ?? "Unknown City"
                    let latitude = data["Latitude"] as? CLLocationDegrees ?? 0.0
                    let longitude = data["Longitude"] as? CLLocationDegrees ?? 0.0
                    let isGone = data["IsGone"] as? Bool ?? false
                    let uuid = data["UUID"] as? String ?? "Unknown UUID"
                    
                    print(uuid)
                    
                    // Append the city and coordinates
                    if latitude != 0.0 && longitude != 0.0 && uuid != "Unknown UUID"{
                        self.coordinates.append((city: city, latitude: latitude, longitude: longitude, isGone: isGone, uuid: uuid))
                    }

                    // Eğer country daha önce eklenmediyse, sections dizisine ekle
                    if !self.addedCountries.contains(country) {
                        self.addedCountries.insert(country)
                        let section = Section(title: country, isExpanded: false)
                        self.sections.append(section)
                    }

                    // itemDictionary'e city ekle ve alfabetik sırayla sakla
                    if self.itemDictionary[country] != nil {
                        self.itemDictionary[country]?.append((city,uuid))
                        //self.itemDictionary[country]?.sort() // Alfabetik sırala
                    } else {
                        self.itemDictionary[country] = [(city,uuid)]
                    }
                }

                // sections dizisini alfabetik sırayla sıralama
                self.sections.sort { $0.title < $1.title }
                
                // Veriler alındıktan sonra tabloyu güncelle
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowVC"{
            if let destinationVC = segue.destination as? ShowCoordinateViewController{
                destinationVC.uuid = selectedUUID
            }
        }
        
        if segue.identifier == "toMapVC" {
            if let destinationVC = segue.destination as? HistoryMapViewController {
                destinationVC.coordinates = self.coordinates // Koordinatları yeni VC'ye gönder
            }
        }
    }


    // Sağa kaydırarak silme özelliğini ekleyin
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let country = sections[indexPath.section].title
            guard var cities = itemDictionary[country] else { return }
            let cityToDelete = cities[indexPath.row]
            
            // Firestore'dan veriyi sil
            db.collection((currentUser?.email)!+"-CoordinateInformations").whereField("Country", isEqualTo: country).whereField("CityTitle", isEqualTo: cityToDelete.city).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error deleting document: \(error)")
                    AlertManager.showAlert(title: "Error", message: "Error deleting document: \(error)", viewController: self)
                } else {
                    for document in snapshot!.documents {
                        document.reference.delete { error in
                            if let error = error {
                                AlertManager.showAlert(title: "Delete Error", message: "Error deleting document: \(error)", viewController: self)

                            } else {
                                AlertManager.showAlert(title: "Deleted", message: "Document successfully deleted!", viewController: self)

                            }
                        }
                    }
                }
            }

            // Dizilerden şehri sil
            cities.remove(at: indexPath.row)
            itemDictionary[country] = cities
            
            // coordinates dizisinden şehri kaldır
            if let index = coordinates.firstIndex(where: { $0.city == cityToDelete.city }) {
                coordinates.remove(at: index)
            }
            
            if cities.isEmpty {
                // Eğer tüm şehirler silindiyse, ülkeyi de silin
                itemDictionary.removeValue(forKey: country)
                sections.remove(at: indexPath.section)

                // Tabloda ilgili bölümü sil ve tabloyu tamamen yeniden yükle
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else {
                // Tabloda ilgili satırı güncelleyin
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }

}

// Section model
struct Section {
    let title: String
    var isExpanded: Bool
}
