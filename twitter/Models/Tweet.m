//
//  Tweet.m
//  twitter
//
//  Created by Fiona Barry on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {

        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil){
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

            // Change tweet to original tweet
            dictionary = originalTweet;
        }
                
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
                
        if (dictionary[@"entities"]) {
            NSDictionary *entities = dictionary[@"entities"];
            if (entities[@"media"]) {
                NSArray *media = entities[@"media"];
                for (int i = 0; i < media.count; i++) {
                    if (media[i][@"media_url_https"]) {
                        NSLog(@"%@", self.text);
                        NSLog(@"%@", media[i][@"media_url_https"]);
                        self.postImage = [NSURL URLWithString:media[i][@"media_url_https"]];
                        break;
                    }
                }
            }
        }
                
        // TODO: initialize user
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
                
        // TODO: Format and set createdAtString
        // Format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        self.createdDate = [formatter dateFromString:createdAtOriginalString];
    }
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
