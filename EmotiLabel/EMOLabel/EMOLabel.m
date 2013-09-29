//
//  EMOLabel.m
//  EmotiLabel
//
//  Created by Kevin Jenkins on 9/22/13.
//  Copyright (c) 2013 somethingpointless. All rights reserved.
//

#import "EMOLabel.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import "EMOHelper.h"
#import "EMOData.h"

@implementation EMOLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// http://stackoverflow.com/questions/9827680/iphone-break-the-text-into-line-for-frame
// https://developer.apple.com/library/mac/samplecode/CoreTextArcCocoa/Listings/CoreTextArcCocoa_APLCoreTextArcView_m.html#//apple_ref/doc/uid/DTS40007771-CoreTextArcCocoa_APLCoreTextArcView_m-DontLinkElementID_4

- (CGPathRef)createBoundingPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.frame);
    return path;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    NSArray *emotis = [EMOHelper replacementStringsForString:self.attributedText];
    self.attributedText = [EMOHelper eraseStringsForEmoti:emotis fromString:self.attributedText];
    self.lineBreakMode = NSLineBreakByWordWrapping;

    CGContextRef context = UIGraphicsGetCurrentContext();

    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(self.attributedText));
    CGPathRef path = [self createBoundingPath];
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, self.text.length), path, NULL);

    CFArrayRef lines = CTFrameGetLines(frame);
    CFIndex lineCount = CFArrayGetCount(lines);

    CGPoint *lineOffsets = malloc(sizeof(CGPoint)*lineCount);
    CTFrameGetLineOrigins(frame, CFRangeMake(0, lineCount), lineOffsets);

    NSInteger emotiIndex = 0;
    EMOData *emoti;

    NSUInteger idx = 0;
    for (; idx < lineCount; idx++) {
        emoti = emotis[emotiIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, idx);
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);

        NSString *lineString = [self.text substringWithRange:range];

        CGPoint lineOffset = lineOffsets[idx];
        NSLog(@"line offset: %@", NSStringFromCGPoint(lineOffset));

        NSRange searchResultRange = [lineString rangeOfString:emoti.replacementStringMarker];
        if (searchResultRange.location != NSNotFound) {

            CGFloat descent;
            CTLineGetTypographicBounds(line, NULL, &descent, NULL);
            [emoti updateWithFontDescent:descent];

            CFArrayRef runArray = CTLineGetGlyphRuns(line);
            CFIndex runCount = CFArrayGetCount(runArray);

            CGRect bounds;
            for (int runIndex = 0; runIndex < runCount; runIndex++) {

                CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
                if (CTRunGetGlyphCount(run) > searchResultRange.location) {
                    CFRange runRange = CTRunGetStringRange(run);
                    bounds = CTRunGetImageBounds(run, context, CFRangeMake(searchResultRange.location, runRange.length - searchResultRange.location));
                    bounds = CGRectMake(bounds.origin.x, self.frame.size.height - lineOffset.y - gs*descent, emoti.emoticonSize.width, emoti.emoticonSize.height);

                }
            }

            UIImage *img = [UIImage imageNamed:@"allthethings.png"];
            [img drawInRect:bounds];

            emotiIndex++;
        }
        
        idx++;
    }

    self.attributedText = [EMOHelper eraseMarkerStringsForEmoti:emotis fromString:self.attributedText];

    [super drawRect:rect];

}


@end
