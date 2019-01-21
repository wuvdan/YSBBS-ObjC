//
//  NSDate+date.m
//  YSBBSApp
//
//  Created by wudan on 2018/11/15.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "NSDate+date.h"

@implementation NSDate (date)

// 判断是否为今年
- (BOOL)isThisYear {
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // NSCalendarUnit枚举代表想获得哪些差值（这里设置年月日时分秒，那么接下来差值就会显示这几项的信息）
    //    NSCalendarUnit unit = NSCalendarUnitYear; // 这里直接放在下面就好了，不用再声明一个NSCalendarUnit对象
    
    
    // 获得某个时间的“年”这个元素
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self]; // 传进来的创建时间
    
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]]; //当前时间
    
    return dateCmps.year == nowCmps.year;
}

// 判断是否是今天
- (BOOL)isThisToday {
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 先将这两个NSDate对象转换成NSString对象
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:nowDate];
    
    // 将不含时分秒的date字符串相比较，年月日完全相同时自然是同一天，也就是今天了
    return [dateStr isEqualToString:nowStr];
    
}

// 判断是否是昨天
- (BOOL)isThisYesterday {
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 先将这两个NSDate对象转换成NSString对象
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:nowDate];
    
    // 再将NSString按照fmt格式转换成不含 时分秒 的NSDate格式（目的就是为了去除 时分秒，单纯比较年月日）
    NSDate *date = [fmt dateFromString:dateStr];
    nowDate = [fmt dateFromString:nowStr];
    
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:nowDate options:0];
    
    // 我们只判断year与month相同情况下的day。year不同那么就算是昨天是去年的最后一天，我们也按照“非今年”的格式显示。month不同那么就算是昨天是上个月的最后一天我们也按照“今年的其他日子”的格式显示
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}




// 另外提供一种比较简便的写法，但只适用于 iOS 8 以后
/*
 NS_AVAILABLE宏告诉我们这方法分别随Mac OS 10.9和iOS 8.0被引入
 
 - (BOOL)isDateInToday:(NSDate *)date NS_AVAILABLE(10_9, 8_0);
 - (BOOL)isDateInYesterday:(NSDate *)date NS_AVAILABLE(10_9, 8_0);
 - (BOOL)isDateInTomorrow:(NSDate *)date NS_AVAILABLE(10_9, 8_0);
 - (BOOL)isDateInWeekend:(NSDate *)date NS_AVAILABLE(10_9, 8_0);
 */

/*
 - (BOOL)isThisYear
 {
 // 获取当前日期对象
 NSDate *curDate = [NSDate date];
 // 获取日历类
 NSCalendar *curCalendar = [NSCalendar currentCalendar];
 // 获取自己日期组件(年,月,等)
 NSDateComponents *selfCmp = [curCalendar components:NSCalendarUnitYear fromDate:self];
 // 获取当前时间日期组件(年,月,等)
 NSDateComponents *curCmp = [curCalendar components:NSCalendarUnitYear fromDate:curDate];
 return  curCmp.year == selfCmp.year;
 }
 // 判断是否是今天
 - (BOOL)isThisToday
 {
 // 获取日历类
 NSCalendar *curCalendar = [NSCalendar currentCalendar];
 return [curCalendar isDateInToday:self];
 }
 - (BOOL)isThisYesterday
 {
 NSCalendar *curCalendar = [NSCalendar currentCalendar];
 return [curCalendar isDateInYesterday:self];
 }
 */


@end


