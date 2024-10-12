import Foundation
import UserNotifications

class NotificationManager{
    static let notificationTitles = ["Yeni Bir Macera Sadece Bir Tık Uzakta!", "Keşfetmeye Hazır Mısın?", "Rotanı Çiz, Dünyayı Keşfet!", "Sınırlarını Zorla!", "Macera Kapıda!", "Keşfetmenin Zamanı Geldi!", "Haydi, Dünyayı Gez!", "Rutinlerden Kurtul!", "Yeni Yerler, Yeni Deneyimler!", "Bir Sonraki Hedefin Ne?", "Hadi, Haritanı Güncelle!", "Sıradaki Hedef Neresi?", "Her Yolculuk Bir Keşif!", "Dünya Senin Olsun!", "Bir Yere Gitmenin Tam Zamanı!", "Dünyayı Adımla!", "Haydi, Yola Çık!", "Sana Özel Yeni Keşifler!", "Yolculuk Seni Çağırıyor!", "Dünya Ayağının Altında!", "Her An Yeni Bir Macera!", "Keşfetmekten Vazgeçme!", "Rotan Hazır, Sen de Hazır Mısın?", "Bir Tıkla Maceraya Atıl!", "Yeni Keşifler Seni Bekliyor!", "Yeni Koordinat, Yeni Serüven!", "Dünya Keşfetmek İçin Var!", "Macera Sadece Bir Adım Uzakta!", "Sıradaki Durağın Neresi?", "Keşfetmek İçin Zaman Kaybetme!", "Dünya Senin Keşfetmeni Bekliyor!", "Yolculuk Başlıyor!", "Sıradanlığa Elveda De!", "Yeni Keşifler Seni Bekliyor!", "Dünyayı Keşfetmenin Tam Zamanı!", "Sana Özel Rotalar!", "Bir Tıkla Yeni Dünyalara!", "Gizli Cennetleri Keşfet!", "Yolculuğa Hazır Mısın?", "Sınırlarını Aş!", "Dünyayı Adım Adım Keşfet!", "Yeni Maceralar Kapını Çalıyor!", "Bilmediğin Yerlere Yolculuk!", "Sadece Bir Tıkla Dünyayı Keşfet!", "Yeni Ufuklara Doğru!", "Rota Hazır, Keşfetmeye Başla!", "Keşfetmenin Heyecanını Yaşa!", "Yeni Maceralar Seni Bekliyor!", "Bir Adımda Maceraya Atıl!", "Keşfetmeye Devam Et!", "Dünyanın Gizli Yerleri Seni Bekliyor!", "Koordinatlar Hazır, Sen de Hazır Mısın?", "Macera Her Yerde!", "Keşfetmenin Sırası Sende!", "Sıradanlığa Veda Et!", "Yeni Rotalar Seni Çağırıyor!"]
    
    static let notificationBodies = ["Haydi, yeni koordinatlar keşfet ve maceraya başla!", "10 dakikada bir dünya dolusu yeni fırsat seni bekliyor!", "Yeni bir yer keşfetmek için en iyi zaman şimdi! Hemen tıklayıp yola koyul!", "Yeni yerler seni bekliyor! Hemen haritayı aç ve keşfe başla.", "Her dakika yeni bir fırsat doğuyor. Sen de şimdi harekete geç!", "Yeni koordinatlar seni bekliyor! Şimdi aç ve nereye gitmen gerektiğini öğren.", "Seni bekleyen yeni maceralara hazır mısın? Yeni koordinatlarını hemen öğren!", "Yeni bir yer keşfetmek için mükemmel bir an! Maceraya başla!", "Şimdi keşfetmeye başla ve sıradanlığa veda et!", "Sana özel yeni koordinatlar seni bekliyor! Şimdi yola çık!", "Yeni keşifler seni bekliyor. Hemen tıklayıp yolculuğa başla!", "Bilmediğin yerleri keşfetmek için hazır mısın? Şimdi başla!", "Yeni rotanı belirle ve macerana hemen başla!", "Yeni maceralar sadece bir tık uzakta. Keşfe başla!", "Sıradaki maceran seni bekliyor! Şimdi harekete geç!", "Keşfetmediğin yerler var! Koordinatları bul ve keşfe çık!", "Yeni rotalar, yeni maceralar! Şimdi koordinatlarını keşfet!", "Daha önce hiç gitmediğin bir yer seni bekliyor. Hemen keşfet!", "Yeni bir macera için hazır mısın? Hemen yeni yerleri keşfet!", "Görmediğin yer kalmasın! Şimdi yeni koordinatlarını öğren ve yola koyul!", "Bir tıkla dünyayı keşfetmeye başla. Yeni rotalar seni bekliyor!", "Sıradaki maceran seni bekliyor! Şimdi yeni rotaları keşfet!", "Yeni bir yer keşfetmek için şimdi doğru zaman! Haritayı aç ve yola çık!", "Keşfetmediğin yerleri görmek için hazırsan, hemen harekete geç!", "Dünya seni bekliyor! Hemen yeni bir yer keşfet!", "Yeni bir serüvene atılmak için en doğru zaman! Hemen keşfet!", "Sıradaki koordinat seni bekliyor. Haydi, yeni bir yer keşfet!", "Yeni yerler keşfetmeye hazırsan, şimdi harekete geç!", "Keşfetmek için sabırsızlanıyorsan, yeni koordinatlarını şimdi öğren!", "Dünya seni bekliyor! Yeni maceralara atılmaya var mısın?", "Koordinatlar hazır, sen de hazır mısın? Haydi, yola çık!", "Yeni bir yer keşfetmek için mükemmel bir zaman! Şimdi yola çık!", "Yeni yerler, yeni deneyimler seni bekliyor. Şimdi keşfetmeye başla!", "Her yeni koordinat, yeni bir macera! Hemen harekete geç!", "Keşfetmediğin yer kalmasın. Şimdi yeni rotalara yelken aç!", "Keşfetmeye hazır mısın? Dünyanın bilinmeyen yerleri seni bekliyor!", "Haydi, haritayı aç ve yeni maceralara başla!", "Yeni rotalar seni bekliyor! Şimdi harekete geç ve keşfetmeye başla!", "Seni bekleyen bilinmeyen yerler var. Hemen keşfet!", "Keşfetmediğin yerler seni bekliyor. Şimdi yola çık ve sınırları zorla!", "Her yeni koordinat yeni bir macera. Şimdi harekete geç!", "Keşfetmekten vazgeçme! Dünyayı adımlamaya devam et.", "Sana özel yeni koordinatlar seni bekliyor. Hemen keşfet!", "Yeni yerler keşfetmek için şimdi doğru zaman. Maceraya atıl!", "Seni bekleyen yeni bir dünya var. Koordinatlarını hemen öğren!", "Haydi, yeni rotalar seni bekliyor. Keşfetmek için şimdi harekete geç!", "Her yeni koordinat yeni bir heyecan. Dünyayı adımlamaya hazır mısın?", "Koordinatların hazır! Yeni yerler keşfetmek için hemen yola çık!", "Seni bekleyen gizli güzellikleri keşfet! Şimdi harekete geç.", "Dünya büyük ve seni bekliyor! Yeni yerleri keşfetmek için hazır mısın?", "Hemen yeni koordinatlarını keşfet ve bilinmeyen yerlere doğru yola çık.", "Yeni yerler keşfetmenin vakti geldi. Şimdi keşfetmeye başla!", "Yeni yerleri keşfetmeye var mısın? Hemen harekete geç!", "Bilmediğin yerleri keşfetmek için hazır mısın? Yeni koordinatlar seni bekliyor!", "Haydi, yeni yerler keşfet ve sıradanlıktan uzaklaş!", "Dünyanın dört bir yanını keşfetmeye başla! Koordinatlarını şimdi öğren!"]
    
    // Çarşamba ve Cuma günü için bildirim planlama
    static func scheduleMidWeekAndFridayNotifications() {
        // Çarşamba günü için bildirim planlama
        scheduleNotification(weekday: 4, hour: 20, minute: 0, identifier: "WednesdayNotification")
        
        // Cuma günü için bildirim planlama
        scheduleNotification(weekday: 6, hour: 20, minute: 0, identifier: "FridayNotification")
        
        // 1 hafta sonrası için bildirim planlama
        scheduleNotificationForOneWeekLater(day: 7, identifier: "OneWeekLaterNotification")
        
        // 2 hafta sonrası için bildirim planlama
        scheduleNotificationForOneWeekLater(day: 14, identifier: "TwoWeekLaterNotification")
        
        // 1 ay sonrası için bildirim planlama
        scheduleNotificationForOneWeekLater(day: 30, identifier: "OneMonthLaterNotification")
    }
    
    // Bildirim planlama işlevi
    static func scheduleNotification(weekday: Int, hour: Int, minute: Int, identifier: String) {
        let randomIndex = Int.random(in: 0..<NotificationManager.notificationTitles.count)
        
        let title = NotificationManager.notificationTitles[randomIndex]
        let body = NotificationManager.notificationBodies[randomIndex]
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        // Haftanın belirtilen günü ve saati için tetikleyici
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday  // Haftanın günü (Çarşamba = 4, Cuma = 6)
        dateComponents.hour = hour        // Saat (20 = 8 PM)
        dateComponents.minute = minute    // Dakika

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Bildirimi planla
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Bildirim planlama hatası: \(error.localizedDescription)")
            } else {
                print("\(identifier) başarıyla planlandı")
            }
        }
    }

    // 1 hafta sonrası için bildirim planlama
    static func scheduleNotificationForOneWeekLater(day: Int, identifier: String) {
        let randomIndex = Int.random(in: 0..<NotificationManager.notificationTitles.count)
        
        let title = NotificationManager.notificationTitles[randomIndex]
        let body = NotificationManager.notificationBodies[randomIndex]
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        // Şu anki tarih ve 1 hafta sonrası
        let currentDate = Date()
        let oneWeekLater = Calendar.current.date(byAdding: .day, value: day, to: currentDate)

        // 1 hafta sonrası için DateComponents oluşturma
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: oneWeekLater!)

        // 1 hafta sonrasına tetikleyici
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Bildirimi planla
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Bildirim planlama hatası: \(error.localizedDescription)")
            } else {
                print("\(identifier) başarıyla planlandı")
            }
        }
    }
}
