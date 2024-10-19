import UIKit

protocol ButtonManagerDelegate: AnyObject {
    func startButtonTapped()
    func settingsButtonTapped()
    func historyButtonTapped()
}

class ButtonManager {
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        
        // UIButtonConfiguration ile ikon ve metin ekleme
        var config = UIButton.Configuration.filled()
        config.title = "New Coordinate" // Metin
        config.image = UIImage(systemName: "mappin.and.ellipse") // İkon
        config.baseForegroundColor = .black // Metin ve ikon rengi
        config.baseBackgroundColor = UIColor(hex: "#CACACA") // Butonun arka plan rengi
        config.imagePadding = 10 // İkon ile metin arasındaki boşluk
        config.imagePlacement = .leading // İkonu metnin soluna yerleştir
        button.configuration = config
        
        button.layer.cornerRadius = 10 // Yuvarlak köşeler
        button.translatesAutoresizingMaskIntoConstraints = false // Auto Layout için gerekli
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "setting"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false // Auto Layout için gerekli
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var historyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "earth-2"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false // Auto Layout için gerekli
        button.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: ButtonManagerDelegate?

    // Kısıtlamalar için gerekli metodlar burada ayarlanabilir
    func setupConstraints(view: UIView) {
        // Start button - Alt ortada
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Settings button - Sağ üst köşede
        NSLayoutConstraint.activate([
            settingsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            settingsButton.widthAnchor.constraint(equalToConstant: 70),
            settingsButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // History button - Sol üst köşede
        NSLayoutConstraint.activate([
            historyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            historyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            historyButton.widthAnchor.constraint(equalToConstant: 70),
            historyButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    @objc func startButtonTapped() {
        print("Start Button Tıklandı")
        delegate?.startButtonTapped()
    }
    
    @objc func settingsButtonTapped() {
        print("Settings Button Tıklandı")
        delegate?.settingsButtonTapped()
    }
    
    @objc func historyButtonTapped() {
        print("History Button Tıklandı")
        delegate?.historyButtonTapped()
    }
}
