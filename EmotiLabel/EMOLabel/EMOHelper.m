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
+ (NSArray *)replacementStringsForString:(NSAttributedString *)attributedString {

    NSString *string = attributedString.string;

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
                data.index = emotis.count;
                NSDictionary *attributes = [attributedString attributesAtIndex:textResult.range.location effectiveRange:NULL];
                [data updateReplacementStringWithAttributes:attributes];
                [emotis addObject:data];
            }
        }
    }

    return [NSArray arrayWithArray:emotis];
}

+ (NSAttributedString *)eraseStringsForEmoti:(NSArray *)emotis fromString:(NSAttributedString *)string {

    NSMutableAttributedString *temp = string.mutableCopy;

    NSInteger locationOffset = 0;
    for (EMOData *data in emotis) {
        NSRange range = NSMakeRange(data.range.location + locationOffset, data.range.length);
        [temp replaceCharactersInRange:range withString:data.replacementStringMarker];
        data.replacementRange = NSMakeRange(data.range.location + locationOffset, data.replacementStringMarker.length);
        locationOffset = locationOffset - (data.range.length - data.replacementStringMarker.length);
    }
    NSLog(@"%@", temp.string);
    return [[NSAttributedString alloc] initWithAttributedString:temp];
}

+ (NSAttributedString *)eraseMarkerStringsForEmoti:(NSArray *)emotis fromString:(NSAttributedString *)string {

    NSMutableAttributedString *temp = string.mutableCopy;

    for (EMOData *data in emotis) {
        if (data.replacementRange.length < 1) { continue; }
        [temp replaceCharactersInRange:data.replacementRange withString:data.replacementString];
    }
    return [[NSAttributedString alloc] initWithAttributedString:temp];
}

#pragma mark - Access Methods
+ (UIImage *)emotiForName:(NSString *)string {
    return [emotiMap objectForKey:string];
}

@end
