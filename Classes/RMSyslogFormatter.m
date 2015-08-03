//
//  RMSyslogFormatter.m
//  Pods
//
//  Created by Malayil Philip George on 5/7/14.
//  Copyright (c) 2014 Rogue Monkey Technologies & Systems Private Limited. All rights reserved.
//
//

#import "RMSyslogFormatter.h"

static NSString * const RMAppUUIDKey = @"RMAppUUIDKey";

@implementation RMSyslogFormatter

@synthesize machineName = _machineName;
@synthesize programName = _programName;

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *msg = logMessage.message;
    
    NSString *logLevel;
    switch (logMessage.flag)
    {
        case DDLogFlagError     : logLevel = @"11"; break;
        case DDLogFlagWarning   : logLevel = @"12"; break;
        case DDLogFlagInfo      : logLevel = @"14"; break;
        case DDLogFlagDebug     : logLevel = @"15"; break;
        case DDLogFlagVerbose   : logLevel = @"15"; break;
        default                 : logLevel = @"15"; break;
    }
    
    //Also display the file the logging occurred in to ease later debugging
    NSString *file = [[logMessage.file lastPathComponent] stringByDeletingPathExtension];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:logMessage.timestamp];
    
    //Get vendor id
    NSString *machineName = [self machineName];
    
    //Get program name
    NSString *programName = [self programName];
    
    NSString *log = [NSString stringWithFormat:@"<%@>%@ %@ %@: %@ %@@%@@%lu \"%@\"", logLevel, timestamp, machineName, programName, logMessage.threadID, file, logMessage.function, (unsigned long)logMessage.line, msg];
    
    return log;
}

-(void)setMachineName:(NSString *)machineName
{
    _machineName = machineName;
}

-(NSString *) machineName
{
    if(!_machineName)
    {
        _machineName = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }

    return _machineName;
}

-(void)setProgramName:(NSString *)programName
{
    _programName = programName;
}

-(NSString *) programName
{
    if (!_programName)
    {
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey];
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey];

        _programName = [@[appName, appVersion] componentsJoinedByString:@"-"];
    }

    return _programName;
}

@end
