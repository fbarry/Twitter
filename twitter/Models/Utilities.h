//
//  Utilities.h
//  twitter
//
//  Created by Fiona Barry on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetCell.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Utilities : NSObject

+ (nonnull UITableViewCell *)initTweetCellWithTweet:(Tweet *)tweet
                                       forTableView:(nonnull UITableView *)tableView
                              cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
