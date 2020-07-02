//
//  ReplyViewController.m
//  twitter
//
//  Created by Fiona Barry on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ReplyViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ReplyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *replyToLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.replyToLabel.text = [NSString stringWithFormat:@"Replying to @%@", self.tweet.user.screenName];
    self.textView.text = [NSString stringWithFormat:@"@%@ ", self.tweet.user.screenName];
    
    // Do any additional setup after loading the view.
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)replyButton:(id)sender {
    
    NSString *atUser = [NSString stringWithFormat:@"@%@ ", self.tweet.user.screenName];
    if (![self.textView.text containsString:atUser]) {
        self.textView.text = [atUser stringByAppendingString:self.textView.text];
    }
    
    [[APIManager shared] postReplyToTweet:self.tweet withText:self.textView.text completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            NSLog(@"reply success!");
            [self.delegate didReply];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"😫😫😫 Error posting: %@", error.localizedDescription);
        }
    }];
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
