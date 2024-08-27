import UIKit

class RightToLeftSegue: UIStoryboardSegue {
    override func perform() {
        let sourceVC = self.source
        let destinationVC = self.destination
        
        // Hedef view controller'ı kaydırarak başlangıç konumuna getir
        sourceVC.view.superview?.insertSubview(destinationVC.view, aboveSubview: sourceVC.view)
        destinationVC.view.transform = CGAffineTransform(translationX: sourceVC.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            destinationVC.view.transform = CGAffineTransform(translationX: 0, y: 0)
            sourceVC.view.transform = CGAffineTransform(translationX: -sourceVC.view.frame.size.width, y: 0)
        }) { _ in
            sourceVC.view.isHidden = true
            sourceVC.present(destinationVC, animated: false, completion: {
                sourceVC.view.isHidden = false
            })
        }
    }
}
