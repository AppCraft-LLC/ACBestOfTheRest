//
//  ACDetailsViewController.m
//  ACBestOfTheRest
//
//  Created by Александр Мурзанаев on 16/10/2016.
//  Copyright © 2016 Alexander. All rights reserved.
//

#import "ACDetailsViewController.h"

@interface ACDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;

@end

@implementation ACDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailsTextView.text = self.item[@"text"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
