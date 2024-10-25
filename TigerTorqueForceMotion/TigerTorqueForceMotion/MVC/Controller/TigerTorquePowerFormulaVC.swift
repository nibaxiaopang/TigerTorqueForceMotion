//
//  PowerFormulaVC.swift
//  TorqueForceMotion
//
//  Created by Mac on 23/10/24.
//

import UIKit

class TigerTorquePowerFormulaVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func TapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TapOnCalculator(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PowerVC") as! TigerTorquePowerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
