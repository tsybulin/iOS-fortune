//
//  FortuneManager.m
//  fortune
//
//  Created by Pavel Tsybulin on 10.12.15.
//  Copyright © 2015 Pavel Tsybulin. All rights reserved.
//

#import "FortuneManager.h"

@interface FortuneManager () {
    NSMutableArray<NSString *> *fortunes ;
}

@end

@implementation FortuneManager

+ (instancetype)sharedManager {
    static FortuneManager *sharedInstance = nil ;
    
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[FortuneManager alloc] init] ;
        }
    }
    
    return sharedInstance ;
}

- (instancetype)init {
    if (self = [super init]) {
        fortunes = [NSMutableArray array] ;
    }
    
    return self ;
}

- (void)initFortunes {
    @synchronized(self) {
        if (fortunes.count == 0) {
            NSError *error = nil ;
            NSArray<NSString *> *afortune = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fortune" ofType:@"json"]] options:0 error:&error] ;
            if (!error) {
                [fortunes addObjectsFromArray:afortune] ;
            }
            
            NSUInteger count = [fortunes count];
            for (NSUInteger i = 0; i < count; ++i) {
                NSUInteger nElements = count - i ;
                NSUInteger n = (arc4random() % nElements) + i ;
                [fortunes exchangeObjectAtIndex:i withObjectAtIndex:n] ;
            }
        }
    }
}

- (NSString *)randomFortune {
    [self initFortunes] ;
    u_int32_t rnd = arc4random_uniform((u_int32_t) fortunes.count) ;
    return [fortunes objectAtIndex:rnd] ;
}

- (NSString *)currentFortune {
    [self initFortunes] ;
    return [self fortuneWithDate:[NSDate date]] ;
}

- (NSUInteger)count {
    [self initFortunes] ;
    return fortunes.count ;
}

- (NSString *)fortuneWithIndex:(NSUInteger)index {
    return [fortunes objectAtIndex:index] ;
}

- (NSString *)fortuneWithDate:(NSDate *)date {
    [self initFortunes] ;

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date] ;
    NSUInteger n = (60 * components.hour + components.minute) / FORTUNE_DURATION_MINUTE ;
    NSUInteger i = n % fortunes.count ;
    return [fortunes objectAtIndex:i] ;
}
@end
