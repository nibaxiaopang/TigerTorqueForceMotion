//
//  HomeVC.swift
//  Tiger Torque ForceMotion
//
//  Created by Mac on 23/10/24.
//

import UIKit

class TigerTorqueHomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
    }
   
    @IBAction func TapOn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TapOnTravelSpeed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CylinderFormulaVC") as! TigerTorqueCylinderFormulaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func TapOnForceOfCylinder(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForceFormulaVC") as! TigerTorqueForceFormulaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    @IBAction func TapOnForceOfCylinderMetric(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MetricFormulaViewController") as! TigerTorqueMetricFormulaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func TapOnTorque(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TorqueFormulaVC") as! TigerTorqueFormulaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func TapOnTorqueMetric(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MetricFormulaVC") as! TigerTorqueMetricFormulaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func TapOnHorsePower(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PowerFormulaVC") as! TigerTorquePowerFormulaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
