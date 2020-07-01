//
//  ButtonView.h
//  twitter
//
//  Created by Fiona Barry on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    REPLY,
    RETWEET,
    FAVOR,
    MESSAGE
} ButtonType;

@protocol ButtonViewProtocol <NSObject>

- (void)didTapRetweet;
- (void)didTapFavor;

@end

@interface ButtonView : UIView

@property (nonatomic, weak) id <ButtonViewProtocol> delegate;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *buttonIcon;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic) ButtonType type;

@end

NS_ASSUME_NONNULL_END
