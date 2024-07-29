import UIKit

protocol ButtonManagerDelegate: AnyObject {
    func startButtonTapped()
    func settingsButtonTapped()
}

class ButtonManager {
    
    lazy var startButton: UIButton = {
        let button = UIButton(frame: startButtonFrame)
        button.setImage(UIImage(named: "startButton"), for: .normal)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton(frame: settingsButtonFrame)
        button.setImage(UIImage(named: "settingsButton"), for: .normal)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let startButtonFrame: CGRect
    private let settingsButtonFrame: CGRect
    weak var delegate: ButtonManagerDelegate?
    
    init(startButtonFrame: CGRect, settingsButtonFrame: CGRect) {
        self.startButtonFrame = startButtonFrame
        self.settingsButtonFrame = settingsButtonFrame
    }
    
    @objc func startButtonTapped() {
        print("Start Button Tıklandı")
        delegate?.startButtonTapped()
    }
    
    @objc func settingsButtonTapped() {
        print("Settings Button Tıklandı")
        delegate?.settingsButtonTapped()
    }
}

