import Foundation
import UserNotifications

class NotificationManager{
    static let notificationTitles = ["A New Adventure is Just One Click Away!",
                                     "Are You Ready to Explore?",
                                     "Draw Your Route, Discover the World!",
                                     "Push Your Limits!",
                                     "Adventure is at the Door!",
                                     "It's Time to Explore!",
                                     "Come On, Travel the World!",
                                     "Break Free from Routines!",
                                     "New Places, New Experiences!",
                                     "What's Your Next Destination?",
                                     "Come On, Update Your Map!",
                                     "Where's the Next Destination?",
                                     "Every Journey is a Discovery!",
                                     "The World is Yours!",
                                     "It's the Perfect Time to Go Somewhere!",
                                     "Step Across the World!",
                                     "Come On, Hit the Road!",
                                     "New Discoveries Just for You!",
                                     "The Journey is Calling You!",
                                     "The World is at Your Feet!",
                                     "Every Moment is a New Adventure!",
                                     "Never Stop Exploring!",
                                     "Your Route is Ready, Are You?",
                                     "Jump into Adventure with One Click!",
                                     "New Discoveries Await You!",
                                     "New Coordinate, New Adventure!",
                                     "The World Exists to Be Explored!",
                                     "Adventure is Just One Step Away!",
                                     "Where's Your Next Stop?",
                                     "Don't Waste Time, Start Exploring!",
                                     "The World is Waiting for You to Explore!",
                                     "The Journey Begins!",
                                     "Say Goodbye to Ordinary!",
                                     "New Discoveries Await You!",
                                     "It's the Perfect Time to Explore the World!",
                                     "Routes Just for You!",
                                     "One Click to New Worlds!",
                                     "Discover Hidden Paradises!",
                                     "Are You Ready for the Journey?",
                                     "Cross Your Boundaries!",
                                     "Discover the World Step by Step!",
                                     "New Adventures Are Knocking on Your Door!",
                                     "A Journey to Unknown Places!",
                                     "Discover the World with Just One Click!",
                                     "Towards New Horizons!",
                                     "Your Route is Ready, Start Exploring!",
                                     "Feel the Excitement of Discovery!",
                                     "New Adventures Await You!",
                                     "Jump into Adventure in One Step!",
                                     "Keep Exploring!",
                                     "The Hidden Corners of the World Are Waiting for You!",
                                     "Coordinates Are Ready, Are You?",
                                     "Adventure is Everywhere!",
                                     "It's Your Turn to Explore!",
                                     "Say Goodbye to Ordinary!",
                                     "New Routes Are Calling You!"]
    
    static let notificationBodies = ["Come on, discover new coordinates and start your adventure!",
                                     "A world full of new opportunities awaits you every 10 minutes!",
                                     "The best time to discover a new place is now! Click and hit the road!",
                                     "New places are waiting for you! Open the map and start exploring now.",
                                     "Every minute brings a new opportunity. Take action now!",
                                     "New coordinates are waiting for you! Open now and find out where to go.",
                                     "Are you ready for new adventures waiting for you? Discover your new coordinates now!",
                                     "It's a perfect moment to discover a new place! Start your adventure!",
                                     "Start exploring now and say goodbye to the ordinary!",
                                     "Exclusive new coordinates are waiting for you! Hit the road now!",
                                     "New discoveries await you. Click now and start your journey!",
                                     "Are you ready to discover places you don't know? Start now!",
                                     "Set your new route and start your adventure immediately!",
                                     "New adventures are just one click away. Start exploring!",
                                     "Your next adventure is waiting for you! Take action now!",
                                     "There are places you haven't explored yet! Find the coordinates and start discovering!",
                                     "New routes, new adventures! Discover your coordinates now!",
                                     "A place you've never been to is waiting for you. Discover it now!",
                                     "Are you ready for a new adventure? Discover new places now!",
                                     "Don't leave any place unseen! Learn your new coordinates now and hit the road!",
                                     "Start discovering the world with one click. New routes are waiting for you!",
                                     "Your next adventure is waiting! Discover new routes now!",
                                     "Now is the perfect time to discover a new place! Open the map and set off!",
                                     "If you're ready to see places you haven't explored, take action now!",
                                     "The world is waiting for you! Discover a new place now!",
                                     "Now is the perfect time to embark on a new adventure! Discover now!",
                                     "The next coordinate is waiting for you. Come on, discover a new place!",
                                     "If you're ready to discover new places, take action now!",
                                     "If you're eager to explore, learn your new coordinates now!",
                                     "The world is waiting for you! Are you ready for new adventures?",
                                     "Coordinates are ready, are you? Come on, hit the road!",
                                     "It's the perfect time to discover a new place! Set off now!",
                                     "New places, new experiences await you. Start exploring now!",
                                     "Each new coordinate is a new adventure! Take action now!",
                                     "Don't leave any place unexplored. Set sail for new routes now!",
                                     "Are you ready to explore? The world's unknown places are waiting for you!",
                                     "Come on, open the map and embark on new adventures!",
                                     "New routes are waiting for you! Take action now and start exploring!",
                                     "Unknown places are waiting for you. Discover them now!",
                                     "Places you haven't explored are waiting for you. Set off now and push your limits!",
                                     "Each new coordinate is a new adventure. Take action now!",
                                     "Never stop exploring! Keep stepping across the world.",
                                     "Exclusive new coordinates are waiting for you. Discover them now!",
                                     "Now is the perfect time to discover new places. Embark on an adventure!",
                                     "A new world is waiting for you. Learn your coordinates now!",
                                     "Come on, new routes are waiting for you. Take action now to explore!",
                                     "Each new coordinate brings new excitement. Are you ready to step across the world?",
                                     "Your coordinates are ready! Set off now to discover new places!",
                                     "Discover the hidden beauties waiting for you! Take action now.",
                                     "The world is big and waiting for you! Are you ready to explore new places?",
                                     "Discover your new coordinates now and head towards the unknown.",
                                     "It's time to discover new places. Start exploring now!",
                                     "Are you ready to explore new places? Take action now!",
                                     "Are you ready to discover places you've never seen? New coordinates await you!",
                                     "Come on, discover new places and break away from the ordinary!",
                                     "Start exploring every corner of the world! Learn your coordinates now!"]
    
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
