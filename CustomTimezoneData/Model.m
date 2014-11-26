//
//  Model.m
//  CustomTimezoneData
//
//  Created by David Anderson on 2014-11-25.
//  Copyright (c) 2014 Robots and Pencils Inc. All rights reserved.
//

#import "Model.h"
#import "SSZipArchive.h"

@implementation Model

+ (void)setupTimezoneData {
    
    // we may have just downloaded this file
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tzdata" ofType:@"zip"];
    
    if (!filePath) {
        NSLog(@"Error: no timezone data available – date formatting will rely on iOS-supplied tzdata");
    }
    
    NSString *cacheDirectoryPath = [[[self class] timezoneCacheDirectory] path];
    [SSZipArchive unzipFileAtPath:filePath toDestination:cacheDirectoryPath];
}

+ (NSData *)cachedTimezoneDataForTimezoneName:(NSString *)timezoneName {
    
    // check if we have a path name
    
    NSString *timezoneCachePath = [[[self class] timezoneCacheDirectory] path];
    NSString *specificTimezonePath = [timezoneCachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",timezoneName]];
    
    NSData *data = [NSData dataWithContentsOfFile:specificTimezonePath];
    return data;
}

+ (NSString *)formattedDate:(NSDate *)date usingAppTimezoneDatabaseWithRespectToTimezone:(NSString *)timezone formatter:(NSDateFormatter *)formatter {
    
    // format per the correct timezone
    if (timezone) {
        if (![[formatter.timeZone name] isEqualToString:timezone]) {
            
            NSData *data = [[self class] cachedTimezoneDataForTimezoneName:timezone];
            
            NSTimeZone *airportTimeZone = nil;
            if (data) {
                // use the timezone database bundled with the app
                airportTimeZone = [NSTimeZone timeZoneWithName:timezone data:data];
                
//                NSDate *date = [NSDate date];
//                NSDate *lastYear = [NSDate dateWithTimeIntervalSinceNow:-31557600];
//                NSDate *nextYear = [NSDate dateWithTimeIntervalSinceNow:31557600];
//                
//                NSInteger currentOffset = [airportTimeZone secondsFromGMTForDate:date];
//                NSInteger lastYearOffset = [airportTimeZone secondsFromGMTForDate:lastYear];
//                NSInteger nextYearOffset = [airportTimeZone secondsFromGMTForDate:nextYear];
//                
//                NSInteger currentOffset_OS = [airportTimeZone_OS secondsFromGMTForDate:date];
//                NSInteger lastYearOffset_OS = [airportTimeZone_OS secondsFromGMTForDate:lastYear];
//                NSInteger nextYearOffset_OS = [airportTimeZone_OS secondsFromGMTForDate:nextYear];
                
            } else {
                airportTimeZone = [[NSTimeZone alloc] initWithName:timezone]; // fall back on the OS timezones
            }
            formatter.timeZone = airportTimeZone;
        }
    } else { // use the default timezone
        if (![formatter.timeZone isEqualToTimeZone:[NSTimeZone defaultTimeZone]]) {
            formatter.timeZone = [NSTimeZone defaultTimeZone];
        }
    }
    return [formatter stringFromDate:date];
}

+ (NSString *)formattedDate:(NSDate *)date usingOSTimezoneDatabaseWithRespectToTimezone:(NSString *)timezone formatter:(NSDateFormatter *)formatter {
    
    // format per the correct timezone
    if (timezone) {
        if (![[formatter.timeZone name] isEqualToString:timezone]) {
            
            // use the OS-supplied timezone database
            NSTimeZone *airportTimeZone = [[NSTimeZone alloc] initWithName:timezone]; // fall back on the OS timezones
            formatter.timeZone = airportTimeZone;
        }
    } else { // use the default timezone
        if (![formatter.timeZone isEqualToTimeZone:[NSTimeZone defaultTimeZone]]) {
            formatter.timeZone = [NSTimeZone defaultTimeZone];
        }
    }
    return [formatter stringFromDate:date];
}


+ (NSDateFormatter *)datetimeFormatter {
    
    static NSDateFormatter *_datetimeFormatter;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _datetimeFormatter = [[NSDateFormatter alloc] init];
        _datetimeFormatter.dateFormat = @"MMM dd, yyyy, h:mm a";
    });
    return _datetimeFormatter;
}

+ (NSDateFormatter *)UTCTimeOffsetDateFormatter {
    
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    });
    return _dateFormatter;
}

#pragma mark - Private

+ (NSURL *)cacheDirectory {
    NSURL *cacheDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    return cacheDirectoryURL;
}

+ (NSURL *)timezoneCacheDirectory {
    NSURL *timezoneCacheDirectory = [[self cacheDirectory] URLByAppendingPathComponent:@"tzdata"];
    return timezoneCacheDirectory;
}


@end
