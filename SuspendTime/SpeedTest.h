//
//  SpeedTest.h
//  SuspendTime
//
//  Created by jekun on 2022/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SpeedBlock)(NSString *down, NSString *upload);

@interface SpeedTest : NSObject
@property (nonatomic, assign) uint32_t iBytes;
@property (nonatomic, assign) uint32_t oBytes;
@property (nonatomic, assign) SpeedBlock sp;
@property (nonatomic, strong) NSString *down;
@property (nonatomic, strong) NSString *upload;

- (void)currentNetSpeed;
@end

NS_ASSUME_NONNULL_END
