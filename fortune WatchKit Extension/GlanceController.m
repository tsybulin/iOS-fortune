//
//  GlanceController.m
//  fortune WatchKit Extension
//
//  Created by Pavel Tsybulin on 10.12.15.
//  Copyright © 2015 Pavel Tsybulin. All rights reserved.
//

#import "GlanceController.h"
#import "FortuneManager.h"

@interface GlanceController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblFortune;

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fortuneChanged:) name:@"FORTUNE_CHANGED" object:nil] ;
}

- (void)willActivate {
    [super willActivate] ;
    
    NSString *fortune = [[FortuneManager sharedManager] currentFortune] ;
    [self.lblFortune setText:fortune] ;
}

- (void)didDeactivate {
    [super didDeactivate];
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



