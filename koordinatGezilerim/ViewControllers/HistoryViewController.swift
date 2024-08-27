import UIKit
import FirebaseFirestore

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var sections: [Section] = []
    var itemDictionary: [String: [String]] = [:] // Country -> CityTitles sözlüğü
    let db = Firestore.firestore()
    var addedCountries: Set<String> = [] // Eklenen Country değerlerini takip etmek için Set
    
    var isSelectionMode = false
    var selectedItems: [IndexPath] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView delegate ve datasource ataması
        tableView.delegate = self
        tableView.dataSource = self

        // Firestore'dan verileri çek ve dizileri doldur
        fetchSectionsFromFirestore()
        
        // Sağ üst köşeye "Select" butonu ekleyin
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
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
                        db.collection("user-CoordinateInformations").whereField("Country", isEqualTo: country).whereField("CityTitle", isEqualTo: city).getDocuments { (snapshot, error) in
                            if let error = error {
                                print("Error deleting document: \(error)")
                            } else {
                                for document in snapshot!.documents {
                                    document.reference.delete { error in
                                        if let error = error {
                                            print("Error deleting document: \(error)")
                                        } else {
                                            print("Document successfully deleted!")
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
                db.collection("user-CoordinateInformations").whereField("Country", isEqualTo: country).whereField("CityTitle", isEqualTo: cityToDelete).getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    } else {
                        for document in snapshot!.documents {
                            document.reference.delete { error in
                                if let error = error {
                                    print("Error deleting document: \(error)")
                                } else {
                                    print("Document successfully deleted!")
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
        
        // İlgili section için CityTitle bilgisini itemDictionary'den al ve alfabetik sırada göster
        let country = sections[indexPath.section].title
        if let cities = itemDictionary[country] {
            cell.textLabel?.text = cities[indexPath.row]
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
        label.textColor = .black
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
        if isSelectionMode {
            if let index = selectedItems.firstIndex(of: indexPath) {
                selectedItems.remove(at: index)
            } else {
                selectedItems.append(indexPath)
            }
            
            tableView.reloadRows(at: [indexPath], with: .none)
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
        db.collection("user-CoordinateInformations").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    let country = data["Country"] as? String ?? "Unknown Country"
                    let city = data["CityTitle"] as? String ?? "Unknown City"

                    // Eğer country daha önce eklenmediyse, sections dizisine ekle
                    if !self.addedCountries.contains(country) {
                        self.addedCountries.insert(country)
                        let section = Section(title: country, isExpanded: false)
                        self.sections.append(section)
                    }

                    // itemDictionary'e city ekle ve alfabetik sırayla sakla
                    if self.itemDictionary[country] != nil {
                        self.itemDictionary[country]?.append(city)
                        self.itemDictionary[country]?.sort() // Alfabetik sırala
                    } else {
                        self.itemDictionary[country] = [city]
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

    // Sağa kaydırarak silme özelliğini ekleyin
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let country = sections[indexPath.section].title
            guard var cities = itemDictionary[country] else { return }
            let cityToDelete = cities[indexPath.row]
            
            // Firestore'dan veriyi sil
            db.collection("user-CoordinateInformations").whereField("Country", isEqualTo: country).whereField("CityTitle", isEqualTo: cityToDelete).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error deleting document: \(error)")
                } else {
                    for document in snapshot!.documents {
                        document.reference.delete { error in
                            if let error = error {
                                print("Error deleting document: \(error)")
                            } else {
                                print("Document successfully deleted!")
                            }
                        }
                    }
                }
            }

            // Dizilerden şehri sil
            cities.remove(at: indexPath.row)
            itemDictionary[country] = cities
            
            if cities.isEmpty {
                // Eğer tüm şehirler silindiyse, ülkeyi de silin
                itemDictionary.removeValue(forKey: country)
                sections.remove(at: indexPath.section)

                // Tabloda ilgili bölümü sil ve tabloyu tamamen yeniden yükle
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
