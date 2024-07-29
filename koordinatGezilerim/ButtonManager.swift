import UIKit

protocol ButtonManagerDelegate: AnyObject {
    func buttonTapped()
}

class ButtonManager {
    
    let button: UIButton
    weak var delegate: ButtonManagerDelegate?
    
    init(frame: CGRect) {
        // Butonu oluştur ve özelliklerini ayarla
        button = UIButton(frame: frame)
        button.setImage(UIImage(named: "startButton"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        print("Tıklandı")
        delegate?.buttonTapped()
    }
}


