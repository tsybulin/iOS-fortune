//
//  InterfaceController.m
//  fortune WatchKit Extension
//
//  Created by Pavel Tsybulin on 10.12.15.
//  Copyright © 2015 Pavel Tsybulin. All rights reserved.
//

#import "InterfaceController.h"
#import "FortuneManager.h"
// #import <ClockKit/ClockKit.h>

@interface InterfaceController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblFortune;

- (IBAction)onRefresh ;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context] ;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fortuneChanged:) name:@"FORTUNE_CHANGED" object:nil] ;
}

- (void)willActivate {
    [super willActivate] ;

    NSString *fortune = [[FortuneManager sharedManager] currentFortune] ;
    [self.lblFortune setText:fortune] ;
}

- (void)didDeactivate {
    [super didDeactivate] ;
}

- (IBAction)onRefresh {
    NSString *fortune = [[FortuneManager sharedManager] randomFortune] ;
    [self.lblFortune setText:fortune] ;

//    CLKComplicationServer *server = [CLKComplicationServer sharedInstance];
//    for(CLKComplication *complication in server.activeComplications) {
//        [server reloadTimelineForComplication:complication] ;
//    }
}

- (void)fortuneChanged:(NSNotification *)notification {
    if (notification.userInfo) {
        NSString *fortune = [notification.userInfo objectForKey:@"fortune"] ;
        if (fortune) {
            [self.lblFortune setText:fortune] ;
        }
    }
}

@end



