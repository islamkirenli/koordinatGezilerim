import UIKit

class PrivacySecurityMessageViewController: UIViewController {

    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Privacy&Security"

        // Add the text view to the view controller's view
        view.addSubview(messageTextView)

        // Set constraints for the text view to take up the full screen
        NSLayoutConstraint.activate([
            messageTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            messageTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Set the attributed message
        messageTextView.attributedText = createAttributedMessage()
    }
    
    // Function to create the attributed message with bold headings
    func createAttributedMessage() -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        // Define paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 10
        
        // Define attributes
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.white
        ]
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.white
        ]
        
        // Add content with mixed attributes (bold for titles, normal for body text)
        let sections = [
            ("Protection of Your Personal Data\n", boldAttributes),
            ("All personal data you share while using our app is stored with great care to protect your privacy. Your data is processed only when necessary for the functionality of the app and is not shared with third parties. We follow a transparent policy regarding how we collect and protect your data.\n\n", normalAttributes),
            ("Data We Collect\n", boldAttributes),
            ("We may collect some of your data to enhance your app experience:\n- Location data (for the app's random coordinate feature)\n- Account information (the details you provide when logging into the app)\n\n", normalAttributes),
            ("Data Security\n", boldAttributes),
            ("We use the latest security protocols to ensure the safety of your data. All user data is stored on secure servers and can only be accessed by authorized personnel. To protect your security:\n- Data is stored in an encrypted format.\n- Access to sensitive information is only allowed through secure connections.\n\n", normalAttributes),
            ("Permissions\n", boldAttributes),
            ("Our app only requests permissions necessary for its functionality. The requested permissions are:\n- Location Permission: Required to generate random coordinates.\n- Notification Permission: Used to inform you about new features and important updates.\n\n", normalAttributes),
            ("How Can You Manage Your Data?\n", boldAttributes),
            ("As a user, you have full control over your personal data. If you choose to delete your account, all your data within the app will be permanently deleted. You can also contact us to update or correct your data.\n\n", normalAttributes),
            ("Contact\n", boldAttributes),
            ("If you have any questions or concerns regarding privacy and security, please contact us at randomjourneyapp@gmail.com. We will assist you as soon as possible.", normalAttributes)
        ]
        
        // Build the attributed string by appending each section
        for (text, attributes) in sections {
            let attributedSection = NSAttributedString(string: text, attributes: attributes)
            attributedString.append(attributedSection)
        }
        
        return attributedString
    }
}


