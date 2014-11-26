//
//  CustomTimezoneDataTests.m
//  CustomTimezoneDataTests
//
//  Created by David Anderson on 2014-11-25.
//  Copyright (c) 2014 Robots and Pencils Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Model.h"

@interface CustomTimezoneDataTests : XCTestCase

@property (strong, nonatomic) NSString *targetTimezone;
@property (strong, nonatomic) NSDate *beforeDate;
@property (strong, nonatomic) NSDate *afterDate;

@end

@implementation CustomTimezoneDataTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.targetTimezone = @"America/Grand_Turk";
    
    self.beforeDate = [[Model UTCTimeOffsetDateFormatter] dateFromString:@"2014-11-01T15:15:00-0400"];
    self.afterDate = [[Model UTCTimeOffsetDateFormatter] dateFromString:@"2014-11-03T15:15:00-0500"];

    /*
    NSString *formattedAfterDateWithAppDatabase = [Model formattedDate:afterDate usingAppTimezoneDatabaseWithRespectToTimezone:timezone formatter:[[self class] datetimeFormatter]];
    
    NSString *formattedBeforeDateWithOSDatabase = [Model formattedDate:beforeDate usingOSTimezoneDatabaseWithRespectToTimezone:timezone formatter:[[self class] datetimeFormatter]];
    NSString *formattedAfterDateWithOSDatabase = [Model formattedDate:afterDate usingOSTimezoneDatabaseWithRespectToTimezone:timezone formatter:[[self class] datetimeFormatter]];
    
    
    NSLog(@"Before Nov 2 2014, America/Grand_Turk was using EDT");
    NSLog(@"Expect 2014-11-01T15:15:00-0400 from any recent version of iOS (or the bundled 2014j timezone database) to be formatted as Nov 01, 2014, 3:15 PM");
    NSLog(@"2014-11-01T15:15:00-0400 via iOS tz database is %@", formattedBeforeDateWithOSDatabase);
    NSLog(@"2014-11-01T15:15:00-0400 via bundled 2014j tz database is %@", formattedBeforeDateWithAppDatabase);
    NSLog(@"\n\nThe 2014g tz database bunded with iOS 8.1 believes that America/Grand_Turk is using AST after Nov 2, 2014");
    NSLog(@"\nThe 2014j tz database bunded with this app knows that America/Grand_Turk is using EST/EDT until Nov 1, 2015");
    
    NSLog(@"\n\nExpect 2014-11-03T15:15:00-0500 from iOS 8.1 (which uses tz 2014g) to be **incorrectly** formatted as Nov 01, 2014, 4:15 PM");
    NSLog(@"\n\nExpect 2014-11-03T15:15:00-0500 from using the bundled 2014j tz database to be correctly formatted as Nov 01, 2014, 3:15 PM");
    NSLog(@"2014-11-03T15:15:00-0500 via iOS tz database is %@", formattedAfterDateWithOSDatabase);
    NSLog(@"2014-11-03T15:15:00-0500 via bundled 2014j tz database is %@", formattedAfterDateWithAppDatabase);
    NSLog(@" ^ if this is formatted as Nov 03, 2014, 4:15 PM then `NSTimeZone timeZoneWithName:data:` is ignoring the tz data we are attempting to supply");
    
    NSLog(@"This version of iOS is using tz %@", [NSTimeZone timeZoneDataVersion]);
     */
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBeforeSwitchToStandardTimeUsingOSTimezoneDatabase {
    
    NSString *formattedBeforeDateWithOSDatabase = [Model formattedDate:self.beforeDate usingOSTimezoneDatabaseWithRespectToTimezone:self.targetTimezone formatter:[Model datetimeFormatter]];
    // Expect 2014-11-01T15:15:00-0400 from any recent version of iOS (or the bundled 2014j timezone database) to be formatted as Nov 01, 2014, 3:15 PM
    XCTAssertEqualObjects(formattedBeforeDateWithOSDatabase, @"Nov 01, 2014, 3:15 PM");
}

- (void)testBeforeSwitchToStandardTimeAttemptingToUseAppSuppliedTimezoneDatabase {
    
    NSString *formattedBeforeDateWithAppDatabase = [Model formattedDate:self.beforeDate usingAppTimezoneDatabaseWithRespectToTimezone:self.targetTimezone formatter:[Model datetimeFormatter]];
    // Expect 2014-11-01T15:15:00-0400 from any recent version of iOS (or the bundled 2014j timezone database) to be formatted as Nov 01, 2014, 3:15 PM
    XCTAssertEqualObjects(formattedBeforeDateWithAppDatabase, @"Nov 01, 2014, 3:15 PM");
    
    // NOTE: because both the iOS 8.1 supplied 2014g tz database and the 2014j tz database both have the same rule for 2014-11-01T15:15:00-0400, this test does not prove (or disprove) whether `NSTimeZone timeZoneWithName:data:` is using the app-supplied 2014j tz database or not
}

- (void)testAfterSwitchToStandardTimeUsingOSTimezoneDatabase {
    
    NSString *formattedAfterDateWithOSDatabase = [Model formattedDate:self.afterDate usingOSTimezoneDatabaseWithRespectToTimezone:self.targetTimezone formatter:[Model datetimeFormatter]];
    // Expect 2014-11-03T15:15:00-0500 from iOS 8.1 (which uses tz 2014g) to be **incorrectly** formatted as Nov 01, 2014, 4:15 PM
    // NOTE: the 2014g to 2014i versions of the tz database **incorrectly** indicate that "America/Grand_Turk" will be observing AST as of Nov 2, 2014. The 2014j version of the tz database fixes this issue ("America/Grand_Turk" will begin observing AST as of Nov 1, 2015)
    XCTAssertEqualObjects(formattedAfterDateWithOSDatabase, @"Nov 03, 2014, 4:15 PM");

}

- (void)testAfterSwitchToStandardTimeAttemptingToUseAppSuppliedTimezoneDatabase {
    NSString *formattedAfterDateWithAppDatabase = [Model formattedDate:self.afterDate usingAppTimezoneDatabaseWithRespectToTimezone:self.targetTimezone formatter:[Model datetimeFormatter]];
    // In an attempt to bundle the 2014j version of the tz database with the app to correct for the issues in 2014g to 2014i, this ^ call should be formatted per EST (not AST)
    // Expect 2014-11-03T15:15:00-0500 from using the bundled 2014j tz database to be correctly formatted as Nov 01, 2014, 3:15 PM
    XCTAssertEqualObjects(formattedAfterDateWithAppDatabase, @"Nov 03, 2014, 3:15 PM");
    // ^ if this is formatted as Nov 03, 2014, 4:15 PM then `NSTimeZone timeZoneWithName:data:` is ignoring the tz data we are attempting to supply
    // This means that `NSTimeZone timeZoneWithName:data:` is ignoring the data supplied and is using the 2014g tz database bundled with iOS 8.1
}


@end
