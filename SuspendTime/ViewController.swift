//
//  ViewController.swift
//  SuspendTime
//
//  Created by jekun on 2022/2/23.
//

import UIKit
import AVKit
import SnapKit

class ViewController: UIViewController {
    
    var playerLayer : AVPlayerLayer = AVPlayerLayer()
    var player : AVPlayer!
    var pictureInPictureController : AVPictureInPictureController!
    var timeV: TimeView!
    
    //设置PictureInPicture
    func setupPictureInPicture() {
        guard let videoURL = Bundle.main.url(forResource: "3", withExtension: "mp4") else {
            return
        }
        //设置AVPlayerLayer
        playerLayer.frame = self.view.frame
        self.view.layer.addSublayer(playerLayer)
        
        //设置AVPlayer
        let asset = AVURLAsset(url: videoURL)
        let playerItem:AVPlayerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        player.rate = 0
        player.play()
        if let player = player {
            playerLayer.player = player
        }
        
        // Ensure PiP is supported by current device.  isPictureInPictureSupported()判断设备是否支持画中画
        if AVPictureInPictureController.isPictureInPictureSupported() {
            pictureInPictureController = AVPictureInPictureController(playerLayer: playerLayer)
            pictureInPictureController.delegate = self
            pictureInPictureController.requiresLinearPlayback = true //隐藏快进
        } else {
            print("当前设备不支持PiP")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .red
        setupPictureInPicture()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tt()
        }
    }
    
    @objc func tt() {
        //判断Pip是否在Active状态
        guard let isActive = pictureInPictureController?.isPictureInPictureActive else { return }
        if (isActive) {
            //停止画中画
            pictureInPictureController?.stopPictureInPicture()
        } else {
            //启动画中画
            pictureInPictureController?.startPictureInPicture()
        }
    }
}

extension ViewController: AVPictureInPictureControllerDelegate {
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        let w:UIWindow = UIApplication.shared.windows.first!
        timeV = TimeView.init()
        timeV.backgroundColor = .yellow
        w.addSubview(timeV)
        timeV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        timeV.run()
//        pictureInPictureController.setValue(false, forKey: "_showsPlaybackControls")
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        timeV.stop()
    }
    
}


