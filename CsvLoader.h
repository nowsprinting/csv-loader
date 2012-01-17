//
//  CsvLoader.m
//    for testing
//
//  Created by Koji Hasegawa on 10/10/12.
//  Copyright 2010-2012 HUB Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CsvLoader : NSObject{
    NSMutableArray  *rows_;  //Array of Row data in NSDictionary.
}
@property (nonatomic, readonly) NSMutableArray *rows;


/**
 * Load csv file, into rows_.
 * 
 * Input file is...
 * - Character encode is utf-8
 * - Comma separated.
 * - Line feed code is LF(\n). CR(\r) is ignored.
 */
- (BOOL)loadCsv:(NSString*)filename;

@end
