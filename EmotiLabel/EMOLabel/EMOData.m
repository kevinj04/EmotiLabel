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
        self.replacementRange = NSMakeRange(0, 0);
        self.emoticonSize = CGSizeZero;
        self.replacementString = nil;
        self.replacementStringMarker = nil;
        self.index = -1;
    }
    return self;
}

+ (id)data {
    return [[EMOData alloc] init];
}

#pragma mark - Replacement Calculations
- (CGSize)heightOfCharacter:(NSString *)character withAttributes:(NSDictionary *)attributes {
    NSMutableAttributedString *styledCharacter = [[NSMutableAttributedString alloc] initWithString:character];
    [styledCharacter addAttributes:attributes range:NSMakeRange(0, 1)];
    return CGSizeMake(ceilf(styledCharacter.size.width), ceilf(styledCharacter.size.height));
}

- (CGSize)sizeForHeight:(CGFloat)height withImageSize:(CGSize)imageSize {
    CGFloat width = ceilf((imageSize.width / imageSize.height) * height);
    return CGSizeMake(width, height);
}

- (NSString *)stringOfSize:(CGSize)size withAttributes:(NSDictionary *)attributes {
    CGSize sizeOfX = [self heightOfCharacter:@" " withAttributes:attributes];
    NSInteger numberOfSpaces = ceilf(size.width / sizeOfX.width);
    NSMutableString *xString = [NSMutableString stringWithString:@""];
    for (int i = 0; i < numberOfSpaces; i++) {
        [xString appendString:@" "];
    }
    return [NSString stringWithString:xString];
}

- (void)updateReplacementStringWithAttributes:(NSDictionary *)attributes {

    CGSize sizeOfSpace = [self heightOfCharacter:@" " withAttributes:attributes];
    self.emoticonSize = [self sizeForHeight:sizeOfSpace.height withImageSize:CGSizeMake(500, 355)];
    NSString *spaceString = [self stringOfSize:self.emoticonSize withAttributes:attributes];
    NSString *indexString = [NSString stringWithFormat:@"%i", self.index];
    NSString *replacement = [NSString stringWithFormat:@"%@%@", indexString, [spaceString substringToIndex:spaceString.length-indexString.length]];
    self.replacementStringMarker = replacement;
    self.replacementString = spaceString;
}

- (void)updateWithFontDescent:(CGFloat)descent {
    self.emoticonSize = [self sizeForHeight:self.emoticonSize.height-descent withImageSize:CGSizeMake(500, 355)];
}

#pragma mark - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@<%p> %@ at %@", self.class, self, self.name, NSStringFromRange(self.range)];
}

@end
