//
//  EMOHelper.m
//  EmotiLabel
//
//  Created by Kevin Jenkins on 9/29/13.
//  Copyright (c) 2013 somethingpointless. All rights reserved.
//

#import "EMOHelper.h"

static NSDictionary *emotiMap;

@implementation EMOHelper

#pragma mark - Setup Methods
+ (void)setEmotiMap:(NSDictionary *)map {
    emotiMap = map;
}

#pragma mark - Parser Methods
+ (NSArray *)imageNamesForString:(NSString *)string {

    NSArray *possibleEmoti = [string componentsSeparatedByString:@":"];
    NSMutableArray *emoti = @[].mutableCopy;
    for (NSString *token in possibleEmoti) {
        if ([emotiMap.allKeys containsObject:token]) {
            [emoti addObject:token];
        }
    }
    return [NSArray arrayWithArray:emoti];
}

#pragma mark - Access Methods
+ (UIImage *)emotiForName:(NSString *)string {
    return [emotiMap objectForKey:string];g
}

@end
