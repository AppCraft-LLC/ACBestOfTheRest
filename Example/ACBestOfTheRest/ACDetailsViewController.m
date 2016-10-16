//
//  ACDetailsViewController.m
//  ACBestOfTheRest
//
//  Created by Александр Мурзанаев on 16/10/2016.
//  Copyright © 2016 Alexander. All rights reserved.
//

#import "ACDetailsViewController.h"
#import "BOTRCore.h"

@interface ACDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;

@end

@implementation ACDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BOTRCore mapDictionary:self.item onView:self.view];
}

@end
