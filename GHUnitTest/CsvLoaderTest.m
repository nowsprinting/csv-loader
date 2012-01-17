//
//  CsvLoaderTest.m
//    for GHUnit testing
//
//  Created by Koji Hasegawa on 12/01/18.
//  Copyright 2010-2012 HUB Systems, Inc. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "CsvLoader.h"


@interface CsvLoaderTest : GHTestCase {
    CsvLoader *loader_;
}
@end


@implementation CsvLoaderTest

- (void)setUp {
    loader_ = [[CsvLoader alloc] init];
}

- (void)tearDown {
    [loader_ release];
}


//NSDictionary中のintを検証
- (void)assertInteger:(NSInteger)expected actualDict:(NSDictionary*)dict actualKey:(NSString*)key{
    NSNumber *actual = (NSNumber*)[dict valueForKey:key];
    GHAssertEquals(expected, [actual integerValue], @"%@は正しい", key);
}

//NSDictionary中のdoubleを検証
- (void)assertDouble:(double)expected actualDict:(NSDictionary*)dict actualKey:(NSString*)key{
    NSNumber *actual = (NSNumber*)[dict valueForKey:key];
    GHAssertEquals(expected, [actual doubleValue], @"%@は正しい", key);
}


#pragma mark - TestCases

- (void)testLoadCsv_rowcount{
    BOOL isSuccess = [loader_ loadCsv:@"testdata"];
    GHAssertTrue(isSuccess, @"ファイル読み込みは成功");
    NSUInteger expected = 3;
    GHAssertEquals(expected, [loader_.rows count], @"データ行数は正しい");
}

- (void)testLoadCsv_file_not_found{
    BOOL isSuccess = [loader_ loadCsv:@"not_exist_file"];
    GHAssertFalse(isSuccess, @"ファイル読み込み失敗時はNOが返る");
}

- (void)testLoadCsv_row0_normally{
    [loader_ loadCsv:@"testdata"];
    NSMutableDictionary *row = [loader_.rows objectAtIndex:0];
    [self assertInteger:8 actualDict:row actualKey:@"int1"];
    [self assertInteger:128 actualDict:row actualKey:@"整数2"];
    [self assertDouble:1.41421356 actualDict:row actualKey:@"double1"];
    [self assertDouble:314.1592 actualDict:row actualKey:@"カンマ,付"];
}

- (void)testLoadCsv_row1_minus{
    [loader_ loadCsv:@"testdata"];
    NSMutableDictionary *row = [loader_.rows objectAtIndex:1];
    [self assertInteger:-4 actualDict:row actualKey:@"int1"];
    [self assertInteger:-256 actualDict:row actualKey:@"整数2"];
    [self assertDouble:-1.7320508 actualDict:row actualKey:@"double1"];
    [self assertDouble:-33.333 actualDict:row actualKey:@"カンマ,付"];
}

- (void)testLoadCsv_row3_invalid{
    [loader_ loadCsv:@"testdata"];
    NSMutableDictionary *row = [loader_.rows objectAtIndex:2];
    [self assertInteger:NAN actualDict:row actualKey:@"int1"];
    [self assertInteger:NAN actualDict:row actualKey:@"整数2"];
    [self assertDouble:NAN actualDict:row actualKey:@"double1"];
    [self assertDouble:NAN actualDict:row actualKey:@"カンマ,付"];
}

@end