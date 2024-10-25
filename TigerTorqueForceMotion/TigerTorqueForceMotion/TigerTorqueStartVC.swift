//
//  StartVC.swift
//  Tiger Torque ForceMotion
//
//  Created by Mac on 23/10/24.
//

import UIKit
import StoreKit

class TigerTorqueStartVC: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var adsActivityView: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var ppBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    
    var needRatAD: Bool = false  {
        didSet {
            self.stackView.isHidden = needRatAD
            self.ppBtn.isHidden = needRatAD
            self.startBtn.isHidden = needRatAD
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.adsActivityView.hidesWhenStopped = true
        self.adsActivityView.stopAnimating()
        self.TorqueLoadADsData()
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
    
    private func TorqueLoadADsData() {
        guard self.torqueNeedShowAds() else {
            return
        }
        
        self.needRatAD = true
        self.adsActivityView.startAnimating()
        if TigerTorqueReachManager.shared().isReachable {
            TorqueReqAdsLocalData()
        } else {
            TigerTorqueReachManager.shared().setReachabilityStatusChange { status in
                if TigerTorqueReachManager.shared().isReachable {
                    self.TorqueReqAdsLocalData()
                    TigerTorqueReachManager.shared().stopMonitoring()
                }
            }
            TigerTorqueReachManager.shared().startMonitoring()
        }
    }
    
    private func TorqueReqAdsLocalData() {
        TorqueLocalAdsData { dataDic in
            if let dataDic = dataDic {
                self.TorqueConfigAdsData(pulseDataDic: dataDic)
            } else {
                self.adsActivityView.stopAnimating()
                self.needRatAD = false
            }
        }
    }
    
    private func TorqueConfigAdsData(pulseDataDic: [String: Any]?) {
        if let aDic = pulseDataDic {
            let adsData: [String: Any]? = aDic["jsonObject"] as? Dictionary
            if let adsData = adsData {
                if let adsUr = adsData["data"] as? String, !adsUr.isEmpty {
                    UserDefaults.standard.set(adsData, forKey: "TigerTorqueDegData")
                    torqueShowAdViewC(adsUr)
                    return
                }
            }
        }
        self.needRatAD = false
        self.adsActivityView.stopAnimating()
    }
    
    private func TorqueLocalAdsData(completion: @escaping ([String: Any]?) -> Void) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            completion(nil)
            return
        }
        
        let url = URL(string: "https://op\(self.torqueMainHostUrl())/open/PostTorqueLocalAdsData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "appLocal": UIDevice.current.localizedModel ,
            "appModelName": UIDevice.current.model,
            "appKey": "3be2f2b69d974730a54e00c02bbd98de",
            "appPackageId": bundleId,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        let dictionary: [String: Any]? = resDic["data"] as? Dictionary
                        if let dataDic = dictionary {
                            completion(dataDic)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }
}
