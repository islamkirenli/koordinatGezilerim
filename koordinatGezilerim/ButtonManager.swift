import UIKit

class ButtonManager {
    
    let button: UIButton
    var spinWorldManager: SpinWorldManager?
    
    init(frame: CGRect) {
        // Butonu oluştur ve özelliklerini ayarla
        button = UIButton(frame: frame)
        button.setImage(UIImage(named: "startButton"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        print("Tıklandı")
        spinWorldManager?.startIncreasingRadius()
    }
}

