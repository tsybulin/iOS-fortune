//
//  ViewController.m
//  fortune
//
//  Created by Pavel Tsybulin on 10.12.15.
//  Copyright © 2015 Pavel Tsybulin. All rights reserved.
//

#import "ViewController.h"
#import "FortuneManager.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fortune = [[FortuneManager sharedManager] currentFortune] ;
    ((UILabel *)[self.view viewWithTag:1]).text = fortune ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRefresh:(id)sender {
    NSString *fortune = [[FortuneManager sharedManager] randomFortune] ;
    ((UILabel *)[self.view viewWithTag:1]).text = fortune ;

    if (![WCSession isSupported]) {
        return ;
    }

    WCSession *wcsession = [WCSession defaultSession] ;
    if (![wcsession isPaired]) {
        return ;
    }

    if(![wcsession isWatchAppInstalled]) {
        return ;
    }

    NSDictionary<NSString *, NSString *> *dict = @{@"fortune" : fortune} ;
    [wcsession updateApplicationContext:dict error:nil] ;
}

@end
