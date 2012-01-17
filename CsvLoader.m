//
//  CsvLoader.m
//    for testing
//
//  Created by Koji Hasegawa on 10/10/12.
//  Copyright 2010-2012 HUB Systems, Inc. All rights reserved.
//

#import "CsvLoader.h"


@implementation CsvLoader

@synthesize rows    = rows_;


- (id)init{
    self = [super init];
    if(self!=nil){
        rows_   = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (void)dealloc{
    [rows_ release];
    [super dealloc];
}


/**
 * Column value into NSDictionary.
 *
 */
- (void)setColumn2row:(NSMutableDictionary *)rowData column:(NSInteger)column text:(NSString *)text colNames:(NSMutableArray *)colNames{
    if(column>=[colNames count]){
        //先頭行は項目名として退避しておく
        [colNames addObject:[text copy]];
        
    }else{
        //カラムを特定し、行Dictionaryに追加
        NSString *colName = [colNames objectAtIndex:column];
        NSString *pattern = @"^(\\-?[0-9]+\\.?[0-9]*)$";
        NSError  *error = nil;
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        if(error==nil){
            NSTextCheckingResult *match = [regexp firstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
            if(match.numberOfRanges>0){
                //数値
                NSRange regex = [text rangeOfString:@"\\." options:NSRegularExpressionSearch];
                if(regex.location!=NSNotFound){
                    //実数
                    [rowData setObject:[NSNumber numberWithDouble:[text doubleValue]] forKey:colName];
                }else{
                    //整数
                    [rowData setObject:[NSNumber numberWithInteger:[text integerValue]] forKey:colName];
                }
            }else{
                //数値以外はNAN
                [rowData setObject:[NSNumber numberWithDouble:NAN] forKey:colName];
            }
        }else{
            NSLog(@"Regex Error! error:%@", error);
        }
    }
}


/**
 * Load csv file, into rows_.
 *
 */
- (BOOL)loadCsv:(NSString*)filename{
    
    //ファイルオープン
    NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:@"csv"];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:filepath];
    if(file==nil){
        return NO;
    }
    
    //読み込み（とりあえず全部読んでから解析）
    NSData *csvdata = [file readDataToEndOfFile];
    NSString *csv2string = [[[NSString alloc] initWithData:csvdata encoding:NSUTF8StringEncoding] autorelease];
    [file closeFile];
    
    //CSVデータの解析
    NSMutableDictionary *rowData    = [[NSMutableDictionary alloc] initWithCapacity:10];
    NSMutableArray      *colNames   = [NSMutableArray array];
    NSMutableString     *buf        = [[NSMutableString alloc] init];
    NSInteger row = 0;
    NSInteger col = 0;
    NSInteger i = 0;
    BOOL isQuotable = NO;
    while (i<[csv2string length]) {
        NSString *current = [csv2string substringWithRange:NSMakeRange(i, 1)];
        
        if([@"," compare:current]==NSOrderedSame && !isQuotable){
            //カンマ
            //カラムの値をDictionaryにセット
            [self setColumn2row:rowData column:col++ text:buf colNames:colNames];
            //文字列バッファを初期化
            [buf deleteCharactersInRange:NSMakeRange(0, [buf length])];
            
        }else if([@"\n" compare:current]==NSOrderedSame){
            //改行
            if(isQuotable){
                //クォート内はそのまま改行扱い
                [buf appendString:current];
                
            }else{
                //行の終端
                //カラムの値をDictionaryにセット
                [self setColumn2row:rowData column:col++ text:buf colNames:colNames];
                //Beanを配列に格納（先頭行は飛ばす）
                if(row>0){
                    [rows_ addObject:rowData];
                }
                //行を初期化
                rowData = [[NSMutableDictionary alloc] initWithCapacity:10];
                row++;
                col = 0;
                //文字列バッファを初期化
                [buf deleteCharactersInRange:NSMakeRange(0, [buf length])];
            }
            
        }else if([@"\r" compare:current]==NSOrderedSame){
            //改行コードだが無視
            
        }else if([@"\"" compare:current]==NSOrderedSame){
            //クォート
            isQuotable = !isQuotable;
            
        }else{
            //文字をバッファにためる
            [buf appendString:current];
        }
        i++;
    }
    
    return YES;
}

@end
