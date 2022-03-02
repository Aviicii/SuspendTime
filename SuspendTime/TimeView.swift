//
//  TimeView.swift
//  SuspendTime
//
//  Created by jekun on 2022/2/25.
//

import UIKit

class TimeView: UIView {
    
    private var timeL: UILabel!
    private var timer: Timer?
    private var timer2: Timer?
    private var fps: FPSLabel!
    private var s: SpeedTest!
    private var speedL: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        timeL = UILabel.init()
        timeL.textAlignment = .center
        timeL.text = getTime()
        timeL.font = .boldSystemFont(ofSize: 30)
        timeL.textColor = .black
        timeL.adjustsFontSizeToFitWidth = true
        addSubview(timeL)
        timeL.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        fps = FPSLabel()
        addSubview(fps)
        fps.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
        
        speedL = UILabel.init()
        speedL.textAlignment = .right
        speedL.numberOfLines = 0
        addSubview(speedL)
        speedL.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalTo(fps.snp.left).offset(-10)
            make.width.equalTo(100)
        }
        
        s = SpeedTest.init()
    }
    
    func setupAtt(string:String) {
        let att:NSMutableAttributedString = NSMutableAttributedString.init(string: string)
        att.addAttribute(NSMutableAttributedString.Key.foregroundColor, value: UIColor.red, range: .init(location: string.count - 4, length: 4))
        timeL.attributedText = att
    }
    
    private func getTime() -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "HH:mm:ss.SSS"
        let time = formatter.string(from: Date.init())
        return time
    }
    
    public func run() {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(speed), userInfo: nil, repeats: true)
        UIApplication.shared.isIdleTimerDisabled = true
        UIApplication.shared.addObserver(self, forKeyPath: "idleTimerDisabled", options: .new, context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if UIApplication.shared.isIdleTimerDisabled == false {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
        timer2?.invalidate()
        timer2 = nil
        UIApplication.shared.isIdleTimerDisabled = false
        UIApplication.shared.removeObserver(self, forKeyPath: "idleTimerDisabled")
    }
    
    @objc private func startAnimation() {
        setupAtt(string: getTime())
    }
    
    @objc private func speed() {
        s.currentNetSpeed()
        self.speedL.text = "上传 " + s.down + "\n" + "下载 " + s.upload
    }

}

