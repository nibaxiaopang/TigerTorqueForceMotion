//
//  ForceFormulaVC.swift
//  Tiger Torque ForceMotion
//
//  Created by Tiger Torque ForceMotion on 23/10/24.
//

import UIKit

class TigerTorqueForceFormulaVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func TapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func TapOnCalculator(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForceVC") as! TigerTorqueForceVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
