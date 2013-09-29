//
//  EMOData.h
//  EmotiLabel
//
//  Created by Kevin Jenkins on 9/29/13.
//  Copyright (c) 2013 somethingpointless. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMOData : NSObject

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSRange   range;
@property (assign, nonatomic) NSRange   replacementRange;
@property (strong, nonatomic) NSString *replacementString;
@property (strong, nonatomic) NSString *replacementStringMarker;
@property (assign, nonatomic) CGSize    emoticonSize;
@property (assign, nonatomic) NSInteger index;

+ (id)data;
- (void)updateReplacementStringWithAttributes:(NSDictionary *)attributes;
- (void)updateWithFontDescent:(CGFloat)descent;

@end
