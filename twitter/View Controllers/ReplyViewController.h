//
//  ReplyViewController.h
//  twitter
//
//  Created by Fiona Barry on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ReplyProtocol <NSObject>

- (void)didReply;

@end

@interface ReplyViewController : UIViewController

@property (nonatomic) id <ReplyProtocol> delegate;
@property (strong, nonatomic) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
