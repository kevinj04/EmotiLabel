//
//  EMOData.m
//  EmotiLabel
//
//  Created by Kevin Jenkins on 9/29/13.
//  Copyright (c) 2013 somethingpointless. All rights reserved.
//

#import "EMOData.h"

@implementation EMOData

#pragma mark - Initialization
- (id)init {
    self = [super init];
    if (self) {
        self.name = nil;
        self.range = NSMakeRange(0, 0);
        self.emoticonFrame = CGRectZero;
        self.replacementString = nil;
    }
    return self;
}

+ (id)data {
    return [[EMOData alloc] init];
}

#pragma mark - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@<%p> %@ at %@", self.class, self, self.name, NSStringFromRange(self.range)];
}

@end
