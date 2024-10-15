import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Attributed string oluşturuyoruz
        let attributedText = NSMutableAttributedString()

        // Başlık ve açıklamaları ekliyoruz
        attributedText.append(NSAttributedString(string: "Are you ready to explore?\n\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]))
        attributedText.append(NSAttributedString(string: """
There are hidden beauties waiting to be discovered in every corner of the world, and this app is here to offer you new adventures! Our app generates a random coordinate from the country you choose, encouraging you to explore that spot. Every adventure can be filled with new experiences, and we are thrilled to guide you on this journey.

""", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]))
        
        attributedText.append(NSAttributedString(string: "\nHow Does It Work?\n\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]))
        attributedText.append(NSAttributedString(string: """
Our app is simple and enjoyable to use! First, select the country you wish to explore. Then, the app will generate a random coordinate from that country just for you. While inviting you directly to an adventure, we’ll also provide suggestions about interesting spots nearby. It’s a perfect opportunity to discover new places and embark on a journey to hidden beauties you’ve never seen before!

""", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]))
        
        attributedText.append(NSAttributedString(string: "\nYour Privacy is Important to Us\n\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]))
        attributedText.append(NSAttributedString(string: """
The privacy and security of your personal data is our top priority. Any information you share within the app will not be shared with third parties and will be stored securely. If you would like to learn more about our privacy policy, you can check the 'Privacy and Security' section in the settings menu.

""", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]))
        
        attributedText.append(NSAttributedString(string: "\nContact\n\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]))
        
        attributedText.append(NSAttributedString(string: """
 If you would like to share your feedback, suggestions, or any issues you’ve encountered with the app, we are always happy to stay in touch with you. You can reach us at 
 """, attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]))
        
        // E-posta adresi için altı çizili bir stil ekliyoruz
        attributedText.append(NSAttributedString(string: "randomjourneyapp@gmail.com", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]))
        
        attributedText.append(NSAttributedString(string: """
  We will do our best to respond to you as soon as possible!

""", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]))
        
        attributedText.append(NSAttributedString(string: "\nVersion Information\n\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]))
        attributedText.append(NSAttributedString(string: """
Current Version: 1.0
We are continuously working to improve our app. Don't forget to keep notifications enabled to receive updates about new features and enhancements!
""", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]))
        
        // TextView özelliklerini ayarlıyoruz
        aboutTextView.attributedText = attributedText
        aboutTextView.isEditable = false  // Metnin düzenlenmesini engelliyoruz
        aboutTextView.isScrollEnabled = true  // Kaydırılabilir yapıyoruz
        aboutTextView.translatesAutoresizingMaskIntoConstraints = false  // Auto Layout için ayarlıyoruz
    }
}
