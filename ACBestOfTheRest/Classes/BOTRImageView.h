//
//  UIRemoteImageView.h
//  ACBestOfTheRest
//
//  Created by Alexander Murzanaev on 21.10.14.
//  Copyright (c) 2014 AppCraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BOTRImageViewConvertorProtocol;

@interface BOTRImageView : UIImageView

@property (nonatomic, strong) IBInspectable NSString *key;
@property (nonatomic, strong) IBInspectable NSString *defaultImage;
@property (weak, nonatomic) IBOutlet id <BOTRImageViewConvertorProtocol> convertor;

- (void)setRemoteValue:(id)value;

@end

@protocol BOTRImageViewConvertorProtocol <NSObject>

- (NSString *)convertValue:(id)value forImageView:(BOTRImageView *)imageView;

@end
