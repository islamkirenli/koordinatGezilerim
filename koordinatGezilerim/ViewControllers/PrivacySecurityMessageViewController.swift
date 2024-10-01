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
            ("Kişisel Verilerinizin Korunması\n", boldAttributes),
            ("Uygulamamızı kullanırken paylaştığınız tüm kişisel veriler, gizliliğinizin korunmasına büyük özen gösterilerek saklanır. Verileriniz, yalnızca uygulamanın işlevselliği için gerekli olduğunda işlenir ve üçüncü taraflarla paylaşılmaz. Verilerinizi ne şekilde topladığımız ve nasıl koruduğumuz konusunda şeffaf bir politika izliyoruz.\n\n", normalAttributes),
            ("Topladığımız Veriler\n", boldAttributes),
            ("Uygulama deneyiminizi geliştirmek amacıyla bazı verilerinizi topluyor olabiliriz:\n- Konum verileri (uygulamamızın rastgele koordinat özelliği için)\n- Hesap bilgileri (uygulamaya giriş yaparken sağladığınız bilgiler)\n\n", normalAttributes),
            ("Veri Güvenliği\n", boldAttributes),
            ("Verilerinizin güvenliğini sağlamak için en güncel güvenlik protokollerini kullanıyoruz. Tüm kullanıcı verileri güvenli sunucularımızda saklanır ve yalnızca yetkilendirilmiş kişiler tarafından erişilebilir. Güvenliğinizi sağlamak için:\n- Veriler şifrelenmiş bir şekilde saklanır.\n- Hassas bilgilere erişim sadece güvenli bağlantılar üzerinden yapılır.\n\n", normalAttributes),
            ("İzinler\n", boldAttributes),
            ("Uygulamamız, yalnızca işlevselliği için gerekli olan izinleri talep eder. Talep edilen izinler şunlardır:\n- Konum İzni: Rastgele koordinatlar oluşturmak için gereklidir.\n- Bildirim İzni: Yeni özellikler ve önemli güncellemeler hakkında sizi bilgilendirmek için kullanılır.\n\n", normalAttributes),
            ("Verilerinizi Nasıl Yönetebilirsiniz?\n", boldAttributes),
            ("Kullanıcı olarak, kişisel verilerinize dair tam kontrol sizdedir. Hesabınızı silmek istediğinizde, uygulamadaki tüm verileriniz kalıcı olarak silinecektir. Ayrıca, verilerinizin güncellenmesi veya düzeltilmesi için bizimle iletişime geçebilirsiniz.\n\n", normalAttributes),
            ("İletişim\n", boldAttributes),
            ("Gizlilik ve güvenlikle ilgili sorularınız veya endişeleriniz varsa, lütfen bizimle randomjourneyapp@gmail.com adresinden iletişime geçin. Size en kısa sürede yardımcı olacağız.", normalAttributes)
        ]
        
        // Build the attributed string by appending each section
        for (text, attributes) in sections {
            let attributedSection = NSAttributedString(string: text, attributes: attributes)
            attributedString.append(attributedSection)
        }
        
        return attributedString
    }
}


