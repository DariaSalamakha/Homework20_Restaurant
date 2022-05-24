//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Daria Salamakha on 14.05.2022.
//

import UIKit

// MARK: - OrderConfirmationViewController
class OrderConfirmationViewController: UIViewController {
    
    // MARK: - Properties
    let minutesToPrepare: Int
    let secondsToPrepare: Double
    
    // MARK: - Outlets
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var confirmationLabel: UILabel!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes."
        progressBar.progress = 0
        
        setProgressTimer()
        createNotification()
    }
    
    // MARK: - Initialize
    init?(coder: NSCoder, prepTime: Int) {
        minutesToPrepare = prepTime
        secondsToPrepare = Double(minutesToPrepare*60)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setProgressTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.progressBar.progress += Float(1.0/(self.secondsToPrepare))
            
            if self.progressBar.progress == 1 {
                timer.invalidate()
            }
        }
    }
    
    func createNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hope you're hungry!"
        content.body = "Your order will be ready in 10 minutes."
        
        var alertTime = 3.0
        if secondsToPrepare-600 > 0 {
            alertTime = secondsToPrepare-600
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: alertTime, repeats: false)
        let request = UNNotificationRequest(identifier: "tenMinuteAlert", content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { error in
            if let error = error {
                print("Notification add error: \(error.localizedDescription)")
            }
        }
    }
}
