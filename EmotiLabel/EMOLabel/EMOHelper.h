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
+ (NSArray *)replacementStringsForString:(NSString *)string;

@end
