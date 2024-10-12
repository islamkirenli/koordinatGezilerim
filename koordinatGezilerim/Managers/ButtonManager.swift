import UIKit

protocol ButtonManagerDelegate: AnyObject {
    func startButtonTapped()
    func settingsButtonTapped()
    func historyButtonTapped()
}

class ButtonManager {
    
    lazy var startButton: UIButton = {
        let button = UIButton(frame: startButtonFrame)
        
        // UIButtonConfiguration ile ikon ve metin ekleme
        var config = UIButton.Configuration.filled()
        config.title = "New Coordinate" // Metin
        config.image = UIImage(systemName: "mappin.and.ellipse") // İkon
        config.baseForegroundColor = .black// Metin ve ikon rengi
        config.baseBackgroundColor = UIColor(hex: "#CACACA") // Butonun arka plan rengi
        config.imagePadding = 10 // İkon ile metin arasındaki boşluk
        config.imagePlacement = .leading // İkonu metnin soluna yerleştir
        button.configuration = config
        
        button.layer.cornerRadius = 10 // Yuvarlak köşeler
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton(frame: settingsButtonFrame)
        button.setImage(UIImage(named: "setting"), for: .normal)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var historyButton: UIButton = {
        let button = UIButton(frame: historyButtonFrame)
        button.setImage(UIImage(named: "earth-2"), for: .normal)
        button.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let startButtonFrame: CGRect
    private let settingsButtonFrame: CGRect
    private let historyButtonFrame: CGRect
    weak var delegate: ButtonManagerDelegate?
    
    init(startButtonFrame: CGRect, settingsButtonFrame: CGRect, historyButtonFrame: CGRect) {
        self.startButtonFrame = startButtonFrame
        self.settingsButtonFrame = settingsButtonFrame
        self.historyButtonFrame = historyButtonFrame
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

