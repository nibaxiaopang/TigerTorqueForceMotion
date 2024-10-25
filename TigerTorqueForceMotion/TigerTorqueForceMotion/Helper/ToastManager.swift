//
//  ToastManager.swift
//  TigerTorqueForceMotion
//
//  Created by jin fu on 2024/10/25.
//

import UIKit


//MARK: - Toast Manager

public class ToastManager {
    
    public static let shared = ToastManager()
    
    public var style = ToastStyle()
    
    public var isTapToDismissEnabled = true
    
    public var isQueueEnabled = false
    
    public var duration: TimeInterval = 3.0
    
    public var position: ToastPosition = .bottom
    
}
