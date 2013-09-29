//
//  EMOViewController.m
//  EmotiLabel
//
//  Created by Kevin Jenkins on 9/22/13.
//  Copyright (c) 2013 somethingpointless. All rights reserved.
//

#import "EMOViewController.h"
#import "EMOHelper.h"

@interface EMOViewController ()

@end

@implementation EMOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    NSDictionary *emotis = @{@"allthethings": @"allthethings.png"};
    [EMOHelper setEmotiMap:emotis];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
