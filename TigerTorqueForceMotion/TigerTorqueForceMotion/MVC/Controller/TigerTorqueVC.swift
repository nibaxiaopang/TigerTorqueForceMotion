//
//  TorqueVC.swift
//  Tiger Torque ForceMotion
//
//  Created by Tiger Torque ForceMotion on 23/10/24.
//

import UIKit

class TigerTorqueVC: UIViewController {

    @IBOutlet weak var txtPowerInHP: UITextField!
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
        calculateTorque()
    }

    @IBAction func TapOnReset(_ sender: Any) {
        viewResult.isHidden = true
        txtPowerInHP.text = ""
        txtRPM.text = ""
        lblResult.text = ""
    }

    private func calculateTorque() {
        guard let powerText = txtPowerInHP.text,
              let rpmText = txtRPM.text,
              let power = Double(powerText),
              let rpm = Double(rpmText) else {
            lblResult.text = "Invalid input"
            return
        }

        if rpm == 0 {
            lblResult.text = "RPM cannot be zero"
            return
        }

        let constant = 5252.0

        let torque = (power * constant) / rpm

        lblResult.text = String(format: "Torque: %.2f lb-ft", torque)
    }
}
