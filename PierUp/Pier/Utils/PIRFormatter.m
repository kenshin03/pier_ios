//
//  PIRFormatter.m

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRFormatter.h"

@implementation PIRFormatter

+ (NSString *)timestampStringFromTimestamp:(NSTimeInterval)unixTime
{
    // Return "Just now" if less than 1 minute has passed
    if ([[NSDate date] timeIntervalSince1970] - unixTime < 60) {
        return NSLocalizedString(@"Just now", nil);
    }
    
    NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:unixTime];
    NSDateComponents *dateComponents =  [[self calendar]
                                         components:(NSMinuteCalendarUnit|
                                                     NSDayCalendarUnit|
                                                     NSMonthCalendarUnit|
                                                     NSHourCalendarUnit|
                                                     NSYearCalendarUnit)
                                         fromDate:timestampDate
                                         toDate:[NSDate date]
                                         options:0];
    NSString *dateValueString;
    NSString *dateString;
    
    // Create relative time from components.
    if (dateComponents.year > 0) {
        dateValueString = [NSString stringWithFormat:@"%i", dateComponents.year];
        if (dateComponents.year > 1) {
            dateString = NSLocalizedString(@"yrs", nil);
        }else{
            dateString = NSLocalizedString(@"yr", nil);
        }
    }
    else if (dateComponents.month > 0) {
        dateValueString = [NSString stringWithFormat:@"%i", dateComponents.month];
        if (dateComponents.month > 1) {
            dateString = NSLocalizedString(@"months", nil);
        }else{
            dateString = NSLocalizedString(@"month", nil);
        }
    }
    else if (dateComponents.day > 0) {
        dateValueString = [NSString stringWithFormat:@"%i", dateComponents.day];
        if (dateComponents.day > 1) {
            dateString = NSLocalizedString(@"days", nil);
        }else{
            dateString = NSLocalizedString(@"day", nil);
        }
    }
    else if (dateComponents.hour > 0) {
        dateValueString = [NSString stringWithFormat:@"%i", dateComponents.hour];
        if (dateComponents.hour > 1) {
            dateString = NSLocalizedString(@"hrs", nil);
        }else{
            dateString = NSLocalizedString(@"hr", nil);
        }
    }
    else {
        dateValueString = [NSString stringWithFormat:@"%i", dateComponents.minute];
        if (dateComponents.minute > 1) {
            dateString = NSLocalizedString(@"mins", nil);
        }else{
            dateString = NSLocalizedString(@"min", nil);
        }
    }
    
    return [NSString stringWithFormat:@"%@ %@ %@", dateValueString, dateString, @" ago"];
}

#pragma mark - Private

+ (NSCalendar *)calendar
{
    static NSCalendar *sCalendar;
    if (!sCalendar) {
        sCalendar = [[NSCalendar alloc]
                     initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return sCalendar;
}


@end
