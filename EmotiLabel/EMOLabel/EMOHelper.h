//
//  EMOHelper.h
//  EmotiLabel
//
//  Created by Kevin Jenkins on 9/29/13.
//  Copyright (c) 2013 somethingpointless. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMOHelper : NSObject

+ (void)setEmotiMap:(NSDictionary *)map;
+ (UIImage *)emotiForName:(NSString *)string;
+ (NSArray *)replacementStringsForString:(NSAttributedString *)string;
+ (NSAttributedString *)eraseStringsForEmoti:(NSArray *)emotis fromString:(NSAttributedString *)string;
+ (NSAttributedString *)eraseMarkerStringsForEmoti:(NSArray *)emotis fromString:(NSAttributedString *)string;

@end
