import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Attributed string oluşturuyoruz
        let attributedText = NSMutableAttributedString()

        // Başlık ve açıklamaları ekliyoruz
        attributedText.append(NSAttributedString(string: "Keşfe Çıkmaya Hazır mısınız?\n\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]))
        attributedText.append(NSAttributedString(string: """
Dünyanın her köşesinde keşfedilmeyi bekleyen gizli güzellikler var ve bu uygulama size yeni maceralar sunmak için burada! Uygulamamız, seçtiğiniz ülkeden rastgele bir koordinat oluşturarak sizi o noktayı keşfetmeye teşvik eder. Her macera, yeni deneyimlerle dolu olabilir ve biz de sizi bu serüvene çıkarmaktan mutluluk duyuyoruz.

""", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]))
        
        attributedText.append(NSAttributedString(string: "\nNasıl Çalışır?\n\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]))
        attributedText.append(NSAttributedString(string: """
Uygulamamız oldukça basit ve kullanımı keyifli! İlk olarak, keşfetmek istediğiniz ülkeyi seçin. Daha sonra uygulama sizin için o ülkeden rastgele bir koordinat oluşturacak. Bu koordinat sizi doğrudan maceraya davet ederken, çevredeki ilgi çekici yerler hakkında da öneriler sunacağız. Yeni yerler keşfetmek, bilmediğiniz güzelliklere yolculuk etmek için mükemmel bir fırsat!

""", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]))
        
        attributedText.append(NSAttributedString(string: "\nGizliliğiniz Bizim İçin Önemli\n\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]))
        attributedText.append(NSAttributedString(string: """
Kişisel verilerinizin gizliliği ve güvenliği bizim önceliğimizdir. Uygulamada paylaştığınız hiçbir bilgi üçüncü taraflarla paylaşılmayacak ve tamamen güvenli bir şekilde saklanacaktır. Gizlilik politikamız hakkında daha fazla bilgi almak isterseniz, ayarlar menüsünden "Gizlilik ve Güvenlik" sekmesine göz atabilirsiniz.

""", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]))
        
        attributedText.append(NSAttributedString(string: "\nİletişim\n\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]))
        
        attributedText.append(NSAttributedString(string: """
 Uygulama ile ilgili geri bildirimlerinizi, önerilerinizi veya yaşadığınız sorunları paylaşmak isterseniz, her zaman sizinle iletişimde olmaktan memnuniyet duyarız. Bizimle 
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
  adresinden iletişime geçebilirsiniz. Size en kısa sürede dönüş yapmaya çalışacağız!

""", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]))
        
        attributedText.append(NSAttributedString(string: "\nSürüm Bilgisi\n\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]))
        attributedText.append(NSAttributedString(string: """
Mevcut Sürüm: 1.0
Uygulamamızı geliştirmeye devam ediyoruz. Yeni özellikler ve iyileştirmeler hakkında güncellemeler almak için bildirimleri açık tutmayı unutmayın!
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
