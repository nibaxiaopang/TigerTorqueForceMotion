//
//  StartVC.swift
//  Tiger Torque ForceMotion
//
//  Created by Mac on 23/10/24.
//

import UIKit
import StoreKit

class TigerTorqueStartVC: UIViewController, UNUserNotificationCenterDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }

    
    @IBAction func TapONShare(_ sender: Any) {
        let objectsToShare = ["Tiger Torque ForceMotion"]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 200, width: 300, height: 300)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func TapOnRate(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func TapOnStar(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! TigerTorqueHomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
