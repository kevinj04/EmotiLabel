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


- (CGSize)heightOfCharacter:(NSString *)character withAttributes:(NSDictionary *)attributes {
    NSMutableAttributedString *styledCharacter = [[NSMutableAttributedString alloc] initWithString:character];
    [styledCharacter addAttributes:attributes range:NSMakeRange(0, 1)];
    return CGSizeMake(ceilf(styledCharacter.size.width), ceilf(styledCharacter.size.height));
}

- (NSDictionary *)attributesForSubstring:(NSString *)substring {
    NSRange range = [self.text rangeOfString:substring];
    return [self.attributedText attributesAtIndex:range.location effectiveRange:NULL];
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    NSDictionary *attributes = [self attributesForSubstring:@":allthethings:"];
    CGSize sizeOfSpace = [self heightOfCharacter:@" " withAttributes:attributes];
    CGSize emoticonSize = [self sizeForHeight:sizeOfSpace.height withImageSize:CGSizeMake(500, 355)];
    NSString *spaceString = [self stringOfSize:emoticonSize withAttributes:attributes];

    CGContextRef context;

    context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f));

    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);

    CGPathRef path = [[UIBezierPath bezierPathWithRect:self.frame] CGPath];
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);

    CFArrayRef lines = CTFrameGetLines(frame);
    CFIndex lineCount = CFArrayGetCount(lines);

    NSUInteger idx = 0;
    for (; idx < lineCount; idx++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, idx);
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);

        NSString *lineString = [self.text substringWithRange:range];

        NSRange searchResultRange = [lineString rangeOfString:@":allthethings:"];
        if (searchResultRange.location != NSNotFound) {

            CFArrayRef runArray = CTLineGetGlyphRuns(line);
            CFIndex runCount = CFArrayGetCount(runArray);

            CGRect daBears;
            for (int runIndex = 0; runIndex < runCount; runIndex++) {

                CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
                if (CTRunGetGlyphCount(run) > searchResultRange.location) {
                    daBears = CTRunGetImageBounds(run, context, CFRangeMake(searchResultRange.location, searchResultRange.length));
                    daBears = CGRectMake(daBears.origin.x, daBears.origin.y, emoticonSize.width, emoticonSize.height);
                    NSLog(@"%@", NSStringFromCGRect(daBears));
                }
            }


            self.text = [self.attributedText.string stringByReplacingCharactersInRange:searchResultRange withString:spaceString];
            CFRelease(line);


            CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.4);
            CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f));
            CGContextFillRect(context, daBears);


            UIImage *img = [UIImage imageNamed:@"allthethings.png"];
            //CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f));
            [img drawInRect:daBears];

            break;
        }
        
        idx++;
    }
    [super drawRect:rect];
}
- (void)drawRect2:(CGRect)rect
{
    NSRange range = [self.text rangeOfString:@":allthethings:"];

    CFStringRef string; CTFontRef font; CGContextRef context;

    string = (__bridge CFStringRef)(self.text);
    font = (__bridge CTFontRef)self.font;
    context = UIGraphicsGetCurrentContext();

    CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f));

    // Initialize string, font, and context
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };

    CFDictionaryRef attributes =
    CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys,
                       (const void**)&values, sizeof(keys) / sizeof(keys[0]),
                       &kCFTypeDictionaryKeyCallBacks,
                       &kCFTypeDictionaryValueCallBacks);

    CFAttributedStringRef attrString =
    CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
    CFRelease(string);
    CFRelease(attributes);

    CTLineRef line = CTLineCreateWithAttributedString(attrString);
    CGFloat offset = CTLineGetOffsetForStringIndex(line, range.location, nil);

    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runArray);

    CGRect daBears;
    for (int runIndex = 0; runIndex < runCount; runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        daBears = CTRunGetImageBounds(run, context, CFRangeMake(range.location, range.length));
        NSLog(@"%@", NSStringFromCGRect(daBears));
    }

    // Set text position and draw the line into the graphics context
    CGContextSetTextPosition(context, 0.0, 10.0);
    CTLineDraw(line, context);
    CFRelease(line);

    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.4);
    CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f));
    CGContextFillRect(context, daBears);

}


@end
