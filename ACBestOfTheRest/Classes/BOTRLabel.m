//
//  UIRemoteLabel.m
//  ACBestOfTheRest
//
//  Created by Alexander Murzanaev on 30.09.14.
//  Copyright (c) 2014 AppCraft. All rights reserved.
//

#import "BOTRLabel.h"

@implementation BOTRLabel

- (void)setRemoteValue:(id)value {
    if (self.convertor)
        self.text = [self.convertor convertValue:value forLabel:self];
    else
        if (value)
            self.text = [NSString stringWithFormat:@"%@", value];
        else
            self.text = self.defaultValue ?: @"";
}

@end
