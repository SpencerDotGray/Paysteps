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
    
    func getHourlySteps() -> [Double] {
    
        var list: [Double] = [Double](repeating: 0.0, count: 24)
        
        for i in 0..<list.count {
            
            let dateAtMidnight = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.startOfDay(for: Date())
            let curHour: Date = Calendar.current.date(byAdding: .hour, value: i, to: dateAtMidnight)!
            let nextHour: Date = Calendar.current.date(byAdding: .hour, value: 1, to: curHour)!
            
            self.pedometer.queryPedometerData(from: curHour, to: nextHour) { (data, error) in
                guard let data = data, error == nil else { return }
                
                list[i] = data.numberOfSteps.doubleValue
            }
        }

        return list
    }
    
    func getHourlyDistance() -> [Double] {
    
        var list: [Double] = [Double](repeating: 0.0, count: 24)
        
        for i in 0..<list.count {
            
            let dateAtMidnight = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.startOfDay(for: Date())
            let curHour: Date = Calendar.current.date(byAdding: .hour, value: i, to: dateAtMidnight)!
            let nextHour: Date = Calendar.current.date(byAdding: .hour, value: 1, to: curHour)!
            
            if CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isStepCountingAvailable() {
                
                self.pedometer.queryPedometerData(from: curHour, to: nextHour) { (data, error) in
                    guard let data = data, error == nil else { return }
                    
                    let d = data.distance?.doubleValue ?? 0.0
                    list[i] = d
                }
            }
        }
    
        return list
    }
    
    func update() {
        
        if !inUpdate {
        
            inUpdate.toggle()
            
            OperationQueue.main.addOperation{
                self.pedometer.startUpdates(from: NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.startOfDay(for: Date())){ (data, error) in
                    guard let data = data, error == nil else { return }
                    
                    self.steps = data.numberOfSteps.intValue
                    self.distance = data.distance?.doubleValue
                }
            }
            
            inUpdate.toggle()
        }
    }
}
