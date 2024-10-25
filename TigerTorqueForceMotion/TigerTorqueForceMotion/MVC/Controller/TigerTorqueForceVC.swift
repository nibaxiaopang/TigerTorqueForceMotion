//
//  ForceVC.swift
//  Tiger Torque ForceMotion
//
//  Created by Mac on 23/10/24.
//

import UIKit

class TigerTorqueForceVC: UIViewController {
    
    @IBOutlet weak var txtPressureInPSI: UITextField!
    @IBOutlet weak var txtPistonAreaInInchesSquare: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var viewResult: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.viewResult.isHidden = true
    }
    
    @IBAction func TapOnCalculate(_ sender: Any) {
        self.viewResult.isHidden = false
        
        calculateForceOfCylinder()
    }
    
    @IBAction func TapOnClear(_ sender: Any) {
        self.viewResult.isHidden = true
        txtPressureInPSI.text = ""
        txtPistonAreaInInchesSquare.text = ""
        lblResult.text = ""
    }
    
    @IBAction func TapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func calculateForceOfCylinder() {
        guard let pressureText = txtPressureInPSI.text,
              let pistonAreaText = txtPistonAreaInInchesSquare.text,
              let pressure = Double(pressureText),
              let pistonArea = Double(pistonAreaText) else {
            lblResult.text = "Invalid input"
            return
        }
        
        if pistonArea == 0 {
            lblResult.text = "Piston area cannot be zero"
            return
        }
        
        let force = pressure * pistonArea
        
        lblResult.text = String(format: "Force: %.2f lbs", force)
    }
}
