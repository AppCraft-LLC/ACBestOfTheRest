//
//  ACViewController.m
//  ACBestOfTheRest
//
//  Created by Alexander on 10/16/2016.
//  Copyright (c) 2016 Alexander. All rights reserved.
//

#import "ACViewController.h"
#import "ACApiManager.h"

@interface ACViewController ()

@end

@implementation ACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[ACApiManager init];
}

@end
