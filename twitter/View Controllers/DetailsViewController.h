//
//  DetailsViewController.h
//  twitter
//
//  Created by Fiona Barry on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) Tweet *tweet;
@property (strong, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
