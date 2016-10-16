//
//  BOTRViewController.h
//  ACBestOfTheRest
//
//  Created by Alexander Murzanaev on 15/10/2016.
//  Copyright © 2016 AppCraft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BOTRTableView.h"
#import "BOTRCollectionView.h"

@interface BOTRViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, BOTRLabelConvertorProtocol, BOTRImageViewConvertorProtocol>

@end
