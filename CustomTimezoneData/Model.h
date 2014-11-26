//
//  Model.h
//  CustomTimezoneData
//
//  Created by David Anderson on 2014-11-25.
//  Copyright (c) 2014 Robots and Pencils Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

+ (void)setupTimezoneData;
+ (NSData *)cachedTimezoneDataForTimezoneName:(NSString *)timezoneName;


+ (NSString *)formattedDate:(NSDate *)date usingAppTimezoneDatabaseWithRespectToTimezone:(NSString *)timezone formatter:(NSDateFormatter *)formatter;
+ (NSString *)formattedDate:(NSDate *)date usingOSTimezoneDatabaseWithRespectToTimezone:(NSString *)timezone formatter:(NSDateFormatter *)formatter;

+ (NSDateFormatter *)datetimeFormatter;
+ (NSDateFormatter *)UTCTimeOffsetDateFormatter;

@end
