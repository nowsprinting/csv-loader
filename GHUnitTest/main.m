//
//  main.m
//  GHUnitTest
//
//  Created by Koji Hasegawa on 12/01/18.
//  Copyright 2010-2012 HUB Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    @autoreleasepool {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        int retVal = UIApplicationMain(argc, argv, nil, @"GHUnitIPhoneAppDelegate");
        [pool release];
        return retVal;
    }
}
