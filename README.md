# NSTimeZone timeZoneWithName:data: ignores supplied data

The 2014g to 2014i versions of the tz database **incorrectly** indicate that "America/Grand_Turk" will be observing AST as of Nov 2, 2014. The 2014j version of the tz database fixes this issue ("America/Grand_Turk" will begin observing AST as of Nov 1, 2015)
This sample project attempts to supply the 2014j tz database to `NSTimeZone timeZoneWithName:data:` in order to present correctly formatted times (formatted per EST, not AST) after Nov 2, 2014.
As evidenced by the failure of the unit test `testAfterSwitchToStandardTimeAttemptingToUseAppSuppliedTimezoneDatabase` ignores the 2014j data supplied to `NSTimeZone timeZoneWithName:data:` and instead just uses the 2014g data that ships with iOS 8.1
That is, `NSTimeZone timeZoneWithName:data:` does not appear to leverage use the `data:` parameter.

Either `NSTimeZone timeZoneWithName:data:` should properly accept and use the `data:` parameter (providing an error if the data supplied is not usable), or this method (and the related `initWithName:data:` method) should be deprecated.