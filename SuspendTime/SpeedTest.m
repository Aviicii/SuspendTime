//
//  SpeedTest.m
//  SuspendTime
//
//  Created by jekun on 2022/3/2.
//

#import "SpeedTest.h"
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation SpeedTest

#pragma mark 当前网速
- (void)currentNetSpeed {
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) return;
    
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    uint32_t allFlow = 0;

    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family) continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) continue;
        if (ifa->ifa_data == 0) continue;
        
        // network
        if (strncmp(ifa->ifa_name, "lo0", 2)) {
            struct if_data* if_data = (struct if_data*)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
        }
    }
    
    freeifaddrs(ifa_list);
    
    if (_iBytes != 0) {
        self.down = [[self stringWithbytes:iBytes - _iBytes] stringByAppendingString:@"/s"];
    }
    _iBytes = iBytes;
    
    if (_oBytes != 0) {
        self.upload = [[self stringWithbytes:oBytes - _oBytes] stringByAppendingString:@"/s"];
    }
    _oBytes = oBytes;
    
}

#pragma mark 转换
- (NSString *)stringWithbytes:(int)bytes {
    if (bytes < 1024) { // B
        return [NSString stringWithFormat:@"%dB", bytes];
    } else if (bytes >= 1024 && bytes < 1024 * 1024) { // KB
        return [NSString stringWithFormat:@"%.0fKB", (double)bytes / 1024];
    } else if (bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024) { // MB
        return [NSString stringWithFormat:@"%.1fMB", (double)bytes / (1024 * 1024)];
    } else { // GB
        return [NSString stringWithFormat:@"%.1fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

@end
