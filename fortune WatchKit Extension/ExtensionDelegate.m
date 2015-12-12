//
//  ExtensionDelegate.m
//  fortune WatchKit Extension
//
//  Created by Pavel Tsybulin on 10.12.15.
//  Copyright © 2015 Pavel Tsybulin. All rights reserved.
//

#import "ExtensionDelegate.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface ExtensionDelegate () <WCSessionDelegate>

@end

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    if ([WCSession isSupported]) {
        WCSession *wcsession = [WCSession defaultSession] ;
        wcsession.delegate = self ;
        [wcsession activateSession] ;
    }
}

- (void)applicationDidBecomeActive {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillResignActive {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
}

#pragma mark - WCSessionDelegate
- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, NSString *> *)applicationContext {
    if ([applicationContext objectForKey:@"fortune"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FORTUNE_CHANGED" object:nil userInfo:applicationContext] ;
    }
}

@end
