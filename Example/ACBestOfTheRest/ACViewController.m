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

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[ACApiManager init];
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
}

- (NSString *)convertValue:(id)value forLabel:(BOTRLabel *)label
{
    if (value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@", value] integerValue]];
        return date ? [self.dateFormatter stringFromDate:date] : @"No date";
    }
    return @"No date";
}

@end
