//
//  ViewController.m
//  CustomTimezoneData
//
//  Created by David Anderson on 2014-11-25.
//  Copyright (c) 2014 Robots and Pencils Inc. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *timezone = @"America/Grand_Turk";
    
    NSDate *beforeDate = [[Model UTCTimeOffsetDateFormatter] dateFromString:@"2014-11-01T15:15:00-0400"];
    NSDate *afterDate = [[Model UTCTimeOffsetDateFormatter] dateFromString:@"2014-11-03T15:15:00-0500"];

    NSString *formattedBeforeDateWithAppDatabase = [Model formattedDate:beforeDate usingAppTimezoneDatabaseWithRespectToTimezone:timezone formatter:[Model datetimeFormatter]];
    NSString *formattedAfterDateWithAppDatabase = [Model formattedDate:afterDate usingAppTimezoneDatabaseWithRespectToTimezone:timezone formatter:[Model datetimeFormatter]];
    
    NSString *formattedBeforeDateWithOSDatabase = [Model formattedDate:beforeDate usingOSTimezoneDatabaseWithRespectToTimezone:timezone formatter:[Model datetimeFormatter]];
    NSString *formattedAfterDateWithOSDatabase = [Model formattedDate:afterDate usingOSTimezoneDatabaseWithRespectToTimezone:timezone formatter:[Model datetimeFormatter]];


    NSLog(@"Before Nov 2 2014, America/Grand_Turk was using EDT");
    NSLog(@"Expect 2014-11-01T15:15:00-0400 from any recent version of iOS (or the bundled 2014j timezone database) to be formatted as Nov 01, 2014, 3:15 PM");
    NSLog(@"2014-11-01T15:15:00-0400 via iOS tz database is %@", formattedBeforeDateWithOSDatabase);
    NSLog(@"2014-11-01T15:15:00-0400 via bundled 2014j tz database is %@", formattedBeforeDateWithAppDatabase);
    NSLog(@"\n\nThe 2014g tz database bunded with iOS 8.1 believes that America/Grand_Turk is using AST after Nov 2, 2014");
    NSLog(@"\nThe 2014j tz database bunded with this app knows that America/Grand_Turk is using EST/EDT until Nov 1, 2015");
    
    NSLog(@"\n\nExpect 2014-11-03T15:15:00-0500 from iOS 8.1 (which uses tz 2014g) to be **incorrectly** formatted as Nov 03, 2014, 4:15 PM");
    NSLog(@"\n\nExpect 2014-11-03T15:15:00-0500 from using the bundled 2014j tz database to be correctly formatted as Nov 03, 2014, 3:15 PM");
    NSLog(@"2014-11-03T15:15:00-0500 via iOS tz database is %@", formattedAfterDateWithOSDatabase);
    NSLog(@"2014-11-03T15:15:00-0500 via bundled 2014j tz database is %@", formattedAfterDateWithAppDatabase);
    NSLog(@" ^ if this is formatted as Nov 03, 2014, 4:15 PM then `NSTimeZone timeZoneWithName:data:` is ignoring the tz data we are attempting to supply");
    
    NSLog(@"This version of iOS is using tz %@", [NSTimeZone timeZoneDataVersion]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
