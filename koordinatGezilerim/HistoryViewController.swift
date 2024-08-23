import UIKit
import FirebaseFirestore

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var sections: [Section] = []
    var itemDictionary: [String: [String]] = [:] // Country -> CityTitles sözlüğü
    let db = Firestore.firestore()
    var addedCountries: Set<String> = [] // Eklenen Country değerlerini takip etmek için Set

    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView delegate ve datasource ataması
        tableView.delegate = self
        tableView.dataSource = self

        // Firestore'dan verileri çek ve dizileri doldur
        fetchSectionsFromFirestore()
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
        label.font = UIFont.boldSystemFont(ofSize: 20) // Font büyütüldü ve kalınlaştırıldı
        label.frame = CGRect(x: 16, y: 8, width: tableView.frame.width - 64, height: 28) // Updated width
        headerView.addSubview(label)

        let arrowImageView = UIImageView()
        arrowImageView.frame = CGRect(x: tableView.frame.width - 36, y: 14, width: 16, height: 16) // Right-aligned arrow
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.image = UIImage(systemName: sections[section].isExpanded ? "chevron.up" : "chevron.down")
        headerView.addSubview(arrowImageView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapHeader(_:)))
        headerView.addGestureRecognizer(tapGesture)
        headerView.tag = section

        return headerView
    }

    // Handle header tap
    @objc func didTapHeader(_ sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else { return }

        // Expand or collapse the section
        sections[section].isExpanded.toggle()

        // Reload section to show/hide items and change arrow direction
        tableView.reloadSections([section], with: .automatic)
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
}

// Section model
struct Section {
    let title: String
    var isExpanded: Bool
}
