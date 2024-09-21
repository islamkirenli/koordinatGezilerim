import UIKit

class AvatarSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let avatarNames = ["avatar-1", "avatar-2", "avatar-3", "avatar-4", "avatar-5", "avatar-6", "avatar-7", "avatar-8", "avatar-9", "avatar-10", "avatar-11", "avatar-12", "avatar-13", "avatar-14", "avatar-15", "avatar-16", "avatar-17", "avatar-18", "avatar-19"]
    var selectedAvatar: ((String) -> Void)?
    
    // Collection view layout ve collection view oluşturuluyor
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Dikey kaydırma
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View'e collection view ekle
        view.addSubview(collectionView)
        
        view.backgroundColor = .black
        
        collectionView.backgroundColor = .black
        
        // Collection view delegate ve data source ayarları
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Hücrelerin boyutunu ayarla (örneğin 80x80)
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: 131, height: 131)
        
        // Collection view için hücre kaydetme
        collectionView.register(AvatarCell.self, forCellWithReuseIdentifier: "AvatarCell")
        
        // Collection view'in konum ve boyut kısıtlamalarını ayarla
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // Hücre sayısı
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarNames.count
    }
    
    // Her bir hücreyi yapılandır
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCell
        let avatarName = avatarNames[indexPath.row]
        cell.imageView.image = UIImage(named: avatarName)
        return cell
    }
    
    // Hücre seçildiğinde avatar adını geri gönder
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAvatarName = avatarNames[indexPath.row]
        selectedAvatar?(selectedAvatarName)
        dismiss(animated: true, completion: nil)
    }
}

// UICollectionView hücresi için özel sınıf
class AvatarCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(hex: "#0f1418")
        
        // Hücreye imageView ekle
        contentView.addSubview(imageView)
        
        // imageView kısıtlamaları
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
