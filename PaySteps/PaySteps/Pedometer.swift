//
//  Pedometer.swift
//  PaySteps
//
//  Created by Spencer Gray on 11/4/20.
//

import Foundation
import CoreMotion

class Pedometer {
    
    private let pedometer: CMPedometer = CMPedometer()
    private var steps: Int?
    private var distance: Double?
    private var startDate: Date?
    private var inUpdate: Bool = false
    
    static let sharedInstance: Pedometer = {
        
        let instance = Pedometer()
        
        if CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable() {
            
            let startDate2 = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            
            instance.pedometer.queryPedometerData(from: startDate2 ?? Date(), to: Date()) { (data, error) in
                guard let data = data, error == nil else { return }
                
                instance.steps = data.numberOfSteps.intValue
                instance.distance = data.distance?.doubleValue
                instance.startDate = Date()
            }
        }
        
        return instance
    }()
    
    func getSteps() -> Int {
        
        return steps ?? 0
    }
    
    func getDistance() -> Double {
        
        return distance ?? 0.0
    }
    
    func update() {
        
        if !inUpdate {
        
            inUpdate.toggle()
            
            OperationQueue.main.addOperation{
                self.pedometer.startUpdates(from: self.startDate ?? Date()){ (data, error) in
                    guard let data = data, error == nil else { return }
                    
                    self.steps = data.numberOfSteps.intValue
                    self.distance = data.distance?.doubleValue
                }
            }
            
            inUpdate.toggle()
        }
    }
}
