//
//  User.m
//  twitter
//
//  Created by Fiona Barry on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.isVerified = [dictionary[@"verified"] boolValue];
        self.profileImageURL = [NSURL URLWithString:dictionary[@"profile_image_url_https"]];
        self.bannerURL = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
        self.descriptionText = dictionary[@"description"];
        self.numTweets = [dictionary[@"statuses_count"] intValue];
        self.numFollowers = [dictionary[@"followers_count"] intValue];
        self.numFollowing = [dictionary[@"friends_count"] intValue];
    }
    return self;
}

@end
