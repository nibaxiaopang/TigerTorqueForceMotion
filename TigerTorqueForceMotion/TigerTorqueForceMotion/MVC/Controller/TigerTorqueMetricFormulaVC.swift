//
//  MetricFormulaViewController.swift
//  Tiger Torque ForceMotion
//
//  Created by Mac on 24/10/24.
//

import UIKit

class TigerTorqueMetricFormulaVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func TapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func TapOnCalculator(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MetricViewController") as! TigerTorqueMetricVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
