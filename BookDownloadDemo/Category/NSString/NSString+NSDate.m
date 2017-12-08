//
//  NSString+NSDate.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/8.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "NSString+NSDate.h"

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.f)
#define iOS9_1_Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

@implementation NSString (NSDate)

+ (NSString *)currentTime {
    return [self creatCurrentTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)currentTimeWithMillisecond {
    return [self creatCurrentTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss:sss"];
}

+(NSString *)creatCurrentTimeWithFormatter:(NSString *)dateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    return  [formatter stringFromDate:[NSDate date]];
}

+(NSString *)getTodayTimeWithFormatter:(NSString *)dateFormat{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
//    NSDateComponents *components;
//    if (iOS8Later) {
//         components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
//    } else {
//        components = [calendar components:[self calendarUnitFlags] fromDate:[NSDate date]];
//    }
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    
    NSDate *todayDate = [calendar dateFromComponents:components];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:todayDate];
}

+ (NSCalendarUnit)calendarUnitFlags NS_DEPRECATED_IOS(2.0, 8.0, "Use NSCalendarUnit instead") {
    return (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
}

+(NSString *)createCurrentTimeWithLocalZone:(NSString *)timeZoneName dateFormatter:(NSString *)dateFormatter{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter    =  [[NSDateFormatter alloc] init];
    [formatter    setDateFormat:dateFormatter];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:date];
}

+(CGFloat)getTimeIntervalFromTimeStringSince1970:(NSString *)timeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * someDayDate = [formatter dateFromString:timeString];
    return  [someDayDate timeIntervalSince1970];
    
}

+(CGFloat)getTimeIntervalFromCurrentTimeSinceTimeString:(NSString *)timeString{
    NSString *currentTimeString = [self getTodayTimeWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
    CGFloat currentInterval = [self getTimeIntervalFromTimeStringSince1970:currentTimeString];
    CGFloat oneDayInterval  = [self getTimeIntervalFromTimeStringSince1970:timeString];
    return currentInterval - oneDayInterval;
}

+(NSString*)convertTimeWithDateStr:(NSString*)sourceDateStr{
    if(!sourceDateStr)
    {
        return @"";
    }
    
    if([sourceDateStr rangeOfString:@"-"].location == NSNotFound &&  [sourceDateStr rangeOfString:@"/"].location == NSNotFound)
    {//时间戳 进行转换
        NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
        formatter1.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [formatter1 setDateStyle:NSDateFormatterMediumStyle];
        [formatter1 setTimeStyle:NSDateFormatterShortStyle];
        [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        // 毫秒值转化为秒
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[sourceDateStr doubleValue]/ 1000.0];
        sourceDateStr = [formatter1 stringFromDate:date];
    }
    NSString *wishStr = @"";
    NSString *dateStr = [sourceDateStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
    [newFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [newFormatter stringFromDate:currentDate];
    
    NSString *currentZeroDateStr;
    if (sourceDateStr.length > 19) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        currentZeroDateStr = [NSString stringWithFormat:@"%@ 00:00:00.000",currentDateStr];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        currentZeroDateStr = [NSString stringWithFormat:@"%@ 00:00:00",currentDateStr];
    }
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];//东八区
    //    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];//GMT+0时区
    
    NSDate *strDate = [formatter dateFromString:dateStr];
    if (!strDate) {
        return dateStr;
    }
    
    NSDate *currentZeroDate = [formatter dateFromString:currentZeroDateStr];
    [newFormatter setDateFormat:@"yyyy"];
    NSString *currentYearStr = [newFormatter stringFromDate:currentDate];
    NSTimeInterval secondsZeroInterval= [currentZeroDate timeIntervalSinceDate:strDate];
    NSTimeInterval secondsInterval= [currentDate timeIntervalSinceDate:strDate];
    if (secondsInterval<=60) {
        wishStr = NSLocalizedString(@"justNow", @"刚刚");
    }
    else if(secondsInterval<3600)
    {
        wishStr = [NSString stringWithFormat:@"%d%@",(int)secondsInterval/60,NSLocalizedString(@"minuteAgo", @"分钟前")];
    }
    else if(secondsInterval<3600*24)
    {
        wishStr = [NSString stringWithFormat:@"%d%@",(int)secondsInterval/3600,NSLocalizedString(@"hourAgo", @"小时前")];
    }
    else if (secondsZeroInterval<3600*24)
    {
        wishStr = NSLocalizedString(@"yestday", @"昨天");
    }
    else if (secondsZeroInterval<3600*24*7)
    {
        
        wishStr = [NSString stringWithFormat:@"%d%@",(int)secondsZeroInterval/(3600*24)+1,NSLocalizedString(@"dayAgo", @"天前")];
    }
    else{ //超过8天
        if([dateStr rangeOfString:currentYearStr].location != NSNotFound) //今年
        {
            [newFormatter setDateFormat:@"MM-dd"];
            wishStr = [newFormatter stringFromDate:strDate];
        }
        else{ //往年
            [newFormatter setDateFormat:@"yyyy-MM-dd"];
            wishStr = [newFormatter stringFromDate:strDate];
        }
        
    }
    
    return wishStr;
}

@end
