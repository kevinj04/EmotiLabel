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
@property (strong, nonatomic) NSString *replacementString;
@property (assign, nonatomic) CGRect    emoticonFrame;

+ (id)data;

@end
