import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let onboardingImages = ["Welcome", "New Coordinate", "Save Coordinate", "Coordinate History", "Region Settings"]
    
    // Bu değişken ayarlardan mı açıldığını kontrol eder
    var isFromSettings = false

    lazy var orderedViewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        for (index, imageName) in onboardingImages.enumerated() {
            let vc = UIViewController()
            let imageView = UIImageView(image: UIImage(named: imageName))
            
            // Görselin tüm ekranı doldurmasını sağla (aspectFit)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            vc.view.addSubview(imageView)
            
            // UIImageView'in cihaz ekranına tam sığacak şekilde yerleşmesini sağla
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: vc.view.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
            ])
            
            // Eğer son görselse ve ayarlardan açılmamışsa bir buton ekle
            if index == onboardingImages.count - 1 && !isFromSettings {
                let button = UIButton(type: .system)
                button.setTitle("Let's Start", for: .normal)
                
                // Filled buton stili
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
                button.layer.cornerRadius = 25
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
                
                vc.view.addSubview(button)
                
                // Butonun ekranın orta alt kısmına yerleşmesini sağla
                NSLayoutConstraint.activate([
                    button.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                    button.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                    button.heightAnchor.constraint(equalToConstant: 50),
                    button.widthAnchor.constraint(equalToConstant: 200)
                ])
            }
            
            viewControllers.append(vc)
        }
        return viewControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return orderedViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: viewController), index < (orderedViewControllers.count - 1) else {
            return nil
        }
        return orderedViewControllers[index + 1]
    }
    
    @objc func startButtonTapped() {
        performSegue(withIdentifier: "toLoginVC", sender: nil)
    }
}
