//
//  User.h
//  twitter
//
//  Created by Fiona Barry on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

// MARK: Properties
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (nonatomic) BOOL isVerified;
@property (strong, nonatomic) NSURL *profileImageURL;
@property (strong, nonatomic) NSURL *bannerURL;
@property (strong, nonatomic) NSString *descriptionText;
@property (nonatomic) int numTweets;
@property (nonatomic) int numFollowing;
@property (nonatomic) int numFollowers;


// MARK: Methods
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
