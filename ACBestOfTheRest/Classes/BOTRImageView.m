//
//  UIRemoteImageView.m
//  ACBestOfTheRest
//
//  Created by Alexander Murzanaev on 21.10.14.
//  Copyright (c) 2014 AppCraft. All rights reserved.
//

#import "BOTRImageView.h"
#import "UIImageView+AFNetworking.h"

static NSString *imagesURL = nil;

@implementation BOTRImageView

+ (void)initialize {
    imagesURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"API Images URL"];
}

- (void)setRemoteValue:(id)value {
    if (self.convertor)
        value = [self.convertor convertValue:value forImageView:self];
    if (value && [value isKindOfClass:[NSString class]] && ((NSString *)value).length) {
        NSString *url = (NSString *)value;
        if (![url hasPrefix:@"http"]) {
            NSAssert(imagesURL, @"Please specify API Images URL key in your Info.plist");
            url = [imagesURL stringByAppendingPathComponent:url];
        }
        [self setImageWithURL:[NSURL URLWithString:url] placeholderImage:self.defaultImage ? [UIImage imageNamed:self.defaultImage] : nil];
    }
    else
        if (self.defaultImage)
            self.image = [UIImage imageNamed:self.defaultImage];
        else
            self.image = nil;
}

@end
