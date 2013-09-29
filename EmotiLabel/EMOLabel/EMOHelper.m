//
//  EMOHelper.m
//  EmotiLabel
//
//  Created by Kevin Jenkins on 9/29/13.
//  Copyright (c) 2013 somethingpointless. All rights reserved.
//

#import "EMOHelper.h"
#import "EMOData.h"

static NSDictionary *emotiMap;

@implementation EMOHelper

#pragma mark - Setup Methods
+ (void)setEmotiMap:(NSDictionary *)map {
    emotiMap = map;
}

#pragma mark - Parser Methods
+ (NSArray *)replacementStringsForString:(NSString *)string {

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @":\\w+:" options:0 error:nil];
    NSArray *results = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];

    NSMutableArray *emotis = @[].mutableCopy;
    for (NSTextCheckingResult *textResult in results)
    {
        if (textResult.range.length > 0)
        {
            NSString *substring = [string substringWithRange:textResult.range];
            NSString *name = [substring stringByReplacingOccurrencesOfString:@":" withString:@""];
            if ([emotiMap.allKeys containsObject:name]) {
                EMOData *data = [EMOData data];
                data.name = name;
                data.range = textResult.range;
                [emotis addObject:data];
            }
        }
    }

    return [NSArray arrayWithArray:emotis];
}

#pragma mark - Access Methods
+ (UIImage *)emotiForName:(NSString *)string {
    return [emotiMap objectForKey:string];
}

@end
