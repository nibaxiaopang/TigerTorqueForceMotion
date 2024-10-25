//
//  PowerVC.swift
//  TorqueForceMotion
//
//  Created by Mac on 23/10/24.
//

import UIKit

class TigerTorquePowerVC: UIViewController {
    
    @IBOutlet weak var txtTorqueInFeetLb: UITextField!
    @IBOutlet weak var txtRPM: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var viewResult: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        viewResult.isHidden = true
    }
  
    @IBAction func TapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TapOnCalculate(_ sender: Any) {
        viewResult.isHidden = false
        calculateHorsePower()
    }
    
    @IBAction func TapOnReset(_ sender: Any) {
        viewResult.isHidden = true
        txtTorqueInFeetLb.text = ""
        txtRPM.text = ""
        lblResult.text = ""
    }
    
    private func calculateHorsePower() {
        guard let torqueText = txtTorqueInFeetLb.text,
              let rpmText = txtRPM.text,
              let torque = Double(torqueText),
              let rpm = Double(rpmText) else {
            lblResult.text = "Invalid input"
            return
        }

        if rpm == 0 {
            lblResult.text = "RPM cannot be zero"
            return
        }

        let constant = 5252.0

        let horsePower = (torque * rpm) / constant

        lblResult.text = String(format: "Horsepower: %.2f HP", horsePower)
    }
}
