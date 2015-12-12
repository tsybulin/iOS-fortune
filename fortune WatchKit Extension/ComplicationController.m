//
//  ComplicationController.m
//  fortune WatchKit Extension
//
//  Created by Pavel Tsybulin on 10.12.15.
//  Copyright © 2015 Pavel Tsybulin. All rights reserved.
//

#import "ComplicationController.h"
#import "FortuneManager.h"

@interface ComplicationController () {
    NSMutableDictionary<NSNumber *, CLKComplicationTemplate *> *templates ;
}

@end

@implementation ComplicationController

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(CLKComplicationTimeTravelDirectionForward|CLKComplicationTimeTravelDirectionBackward) ;
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

- (NSDate *)timelineStartDate {
    return [NSDate dateWithTimeIntervalSinceNow:86400 * -1] ;
}

- (NSDate *)timelineEndDate {
    return [NSDate dateWithTimeIntervalSinceNow:86400] ;
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler([self timelineStartDate]) ;
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler([self timelineEndDate]) ;
}

#pragma mark - Timeline Population

- (CLKComplicationTemplate *)populateTimelineEntryForComplication:(CLKComplication *)complication date:(NSDate *)date {
    CLKComplicationTemplate *template = [self templateForeComplication:complication] ;
    if (!template) {
        return nil ;
    }
    
    NSString *fortune ;
    
    switch (complication.family) {
        case CLKComplicationFamilyModularLarge:
            fortune = [[FortuneManager sharedManager] fortuneWithDate:date] ;
            ((CLKSimpleTextProvider *)((CLKComplicationTemplateModularLargeTallBody *)template).bodyTextProvider).text = fortune ;
            break ;
        case CLKComplicationFamilyUtilitarianLarge:
            fortune = [[FortuneManager sharedManager] fortuneWithDate:date] ;
            ((CLKSimpleTextProvider *)((CLKComplicationTemplateUtilitarianLargeFlat *)template).textProvider).text = fortune ;
            break ;
        default:
            break ;
    }

    return template ;
}

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    CLKComplicationTemplate *template = [self populateTimelineEntryForComplication:complication date:[NSDate date]] ;
    
    if (!template) {
        handler(nil) ;
        return ;
    }

    CLKComplicationTimelineEntry *tle = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:template] ;
    handler(tle);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    NSMutableArray<CLKComplicationTimelineEntry *> *tles = [NSMutableArray array] ;
    for (NSInteger i = 1; i < limit; i++) {
        NSDate *prevDate = [date dateByAddingTimeInterval:i * FORTUNE_DURATION * -1] ;
        CLKComplicationTemplate *template = [self populateTimelineEntryForComplication:complication date:prevDate] ;
        if (!template) {
            continue ;
        }
        CLKComplicationTimelineEntry *tle = [CLKComplicationTimelineEntry entryWithDate:prevDate complicationTemplate:template] ;
        [tles addObject:tle] ;
    }
    
    handler(tles) ;
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    NSMutableArray<CLKComplicationTimelineEntry *> *tles = [NSMutableArray array] ;
    for (NSInteger i = 1; i < limit; i++) {
        NSDate *nextDate = [date dateByAddingTimeInterval:i * FORTUNE_DURATION] ;
        CLKComplicationTemplate *template = [self populateTimelineEntryForComplication:complication date:nextDate] ;
        if (!template) {
            continue ;
        }
        CLKComplicationTimelineEntry *tle = [CLKComplicationTimelineEntry entryWithDate:nextDate complicationTemplate:template] ;
        [tles addObject:tle] ;
    }

    handler(tles) ;
}

#pragma mark Update Scheduling

- (void)getNextRequestedUpdateDateWithHandler:(void(^)(NSDate * __nullable updateDate))handler {
    handler([NSDate dateWithTimeIntervalSinceNow:FORTUNE_DURATION]) ;
}

#pragma mark - Placeholder Templates

- (CLKComplicationTemplateModularLargeTallBody *)complicationTemplateModularLargeTallBody {
    CLKComplicationTemplateModularLargeTallBody *template = [[CLKComplicationTemplateModularLargeTallBody alloc] init] ;
    template.headerTextProvider = [CLKSimpleTextProvider textProviderWithText:@"Fortune"] ;
    template.bodyTextProvider = [CLKSimpleTextProvider textProviderWithText:@"---"] ;
    template.tintColor = [UIColor yellowColor] ;
    return template ;
}

- (CLKComplicationTemplateUtilitarianLargeFlat *)complicationTemplateUtilitarianLargeFlat {
    CLKComplicationTemplateUtilitarianLargeFlat *template = [[CLKComplicationTemplateUtilitarianLargeFlat alloc] init] ;
    template.textProvider = [CLKSimpleTextProvider textProviderWithText:@"FORTUNE"] ;
    template.tintColor = [UIColor yellowColor] ;
    return template ;
}

- (CLKComplicationTemplate *)templateForeComplication:(CLKComplication *)complication {
    CLKComplicationTemplate *template = nil ;
    
    if (!templates) {
        templates = [NSMutableDictionary dictionary] ;
    }
    
    NSNumber *family = [NSNumber numberWithInt:complication.family] ;
    if (family) {
        template = [templates objectForKey:family] ;
    } else {
        return nil ;
    }
    
    if (template) {
        return template ;
    }
    
    switch (complication.family) {
        case CLKComplicationFamilyModularLarge:
            template = [self complicationTemplateModularLargeTallBody] ;
            break ;
        case CLKComplicationFamilyUtilitarianLarge:
            template = [self complicationTemplateUtilitarianLargeFlat] ;
            break ;
        default:
            break ;
    }
    
    if (template) {
        [templates setObject:template forKey:family] ;
    }
    
    return template ;
}

- (void)getPlaceholderTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    CLKComplicationTemplate *template = [self templateForeComplication:complication] ;
    handler(template) ;
}

@end
