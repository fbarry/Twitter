//
//  ComposeViewController.m
//  twitter
//
//  Created by Fiona Barry on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *replyToLabel;
@property (weak, nonatomic) IBOutlet UILabel *charCount;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == REPLY_TWEET) {
        self.replyToLabel.text = [NSString stringWithFormat:@"Replying to @%@", self.tweet.user.screenName];
        self.textView.text = [NSString stringWithFormat:@"@%@ ", self.tweet.user.screenName];
    }
    else {
        self.replyToLabel.text = nil;
    }
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tweetButton:(id)sender {
    
    if (self.type == STATUS_TWEET) {
        [[APIManager shared] postStatusWithText:self.textView.text completion:^(Tweet *tweet, NSError *error) {
            if (tweet) {
                NSLog(@"tweet success!");
                [self.delegate didTweet];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSLog(@"😫😫😫 Error posting: %@", error.localizedDescription);
            }
        }];
    }
    else if (self.type == REPLY_TWEET) {
        NSString *atUser = [NSString stringWithFormat:@"@%@ ", self.tweet.user.screenName];
        if (![self.textView.text containsString:atUser]) {
            self.textView.text = [atUser stringByAppendingString:self.textView.text];
        }
            
        [[APIManager shared] postReplyToTweet:self.tweet withText:self.textView.text completion:^(Tweet *tweet, NSError *error) {
            if (tweet) {
                NSLog(@"reply success!");
                [self.delegate didTweet];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSLog(@"😫😫😫 Error posting: %@", error.localizedDescription);
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
