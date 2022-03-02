//
//  FPSLabel.swift
//  SuspendTime
//
//  Created by jekun on 2022/3/2.
//

import UIKit

class FPSLabel: UILabel {

    fileprivate var displayLink: CADisplayLink?
    fileprivate var lastTime: TimeInterval = 0
    fileprivate var count: Int = 0
    
    deinit {
        displayLink?.invalidate()
    }
    
    override func didMoveToSuperview() {
        
        backgroundColor = UIColor.black
        textColor = UIColor.green
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 24)
        run()
    }
    
    func run() {
        displayLink = CADisplayLink(target: self, selector: #selector(FPSLabel.tick(_:)))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    @objc func tick(_ displayLink: CADisplayLink) {
        if lastTime == 0 {
            lastTime = displayLink.timestamp
            return
        }
        
        count += 1
        let timeDelta = displayLink.timestamp - lastTime
        if timeDelta < 0.25 {
            return
        }
        
        lastTime = displayLink.timestamp
        let fps: Double = Double(count) / timeDelta
        count = 0
        text = String(format: "%.0f fps", fps)
        textColor = fps > 50 ? UIColor.green : UIColor.red
    }

}
