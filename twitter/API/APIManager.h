//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getCurrentUser:(void(^)(User *user, NSError *error))completion;

- (void)updateHomeTimelineAfter:(Tweet *)tweet withCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)getMentionsWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)postReplyToTweet:(Tweet *)tweet withText:(NSString *)text completion:(void(^)(Tweet *tweet, NSError *error))completion;

- (void)postStatusWithText:(NSString *)text completion:(void(^)(Tweet *tweet, NSError *error))completion;

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

@end
