//
//  FortuneManager.h
//  fortune
//
//  Created by Pavel Tsybulin on 10.12.15.
//  Copyright © 2015 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>

// 5 minutes per each fortune
#define FORTUNE_DURATION_MINUTE 5
#define FORTUNE_DURATION FORTUNE_DURATION_MINUTE * 60


@interface FortuneManager : NSObject

+ (instancetype)sharedManager ;
- (NSString *)randomFortune ;
- (NSString *)currentFortune ;
- (NSUInteger)count ;
- (NSString *)fortuneWithDate:(NSDate *)date ;

@end
