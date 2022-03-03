//
//  ViewController.m
//  SuppendTime-OC
//
//  Created by jekun on 2022/3/3.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>

@interface ViewController () <AVPictureInPictureControllerDelegate>
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPictureInPictureController *pictureInPictureController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.redColor;
    [self setupPictureInPicture];
}

- (void)setupPictureInPicture {
    NSURL *videoPath = [[NSBundle mainBundle] URLForResource:@"3" withExtension:@"mp4"];
    AVAsset *asset = [AVAsset assetWithURL:videoPath];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.view.frame;
    [self.view.layer addSublayer:self.playerLayer];
    [self.player play];
    
    if (AVPictureInPictureController.isPictureInPictureSupported) {
        self.pictureInPictureController = [[AVPictureInPictureController alloc] initWithPlayerLayer:_playerLayer];
        self.pictureInPictureController.delegate = self;
        self.pictureInPictureController.requiresLinearPlayback = YES; //隐藏快进
    }else{
        NSLog(@"当前设备不支持PiP");
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5), dispatch_get_main_queue(), ^{
        [self tt];
    });
    
}

- (void)tt {
    if (self.pictureInPictureController.isPictureInPictureActive) {
        [self.pictureInPictureController stopPictureInPicture];
    }else{
        [self.pictureInPictureController startPictureInPicture];
    }
}

- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    UIWindow *w = [[[UIApplication sharedApplication] windows] firstObject];
    UIView *v = [UIView new];
    v.backgroundColor = UIColor.yellowColor;
    [w addSubview:v];
    v.frame = w.frame;
}

- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    
}

@end
