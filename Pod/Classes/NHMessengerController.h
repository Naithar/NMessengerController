//
//  NMessengerController.h
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

@import UIKit;
#import "NHContainerView.h"

//delegate
//send
//changetext
//change send button state
//keyboard appear
//keyboard dissapear
//should change insets?
//did start
//did finish

@interface NHMessengerController : NSObject

@property (nonatomic, assign) UIEdgeInsets textViewInsets;
@property (nonatomic, assign) UIEdgeInsets containerInsets;
@property (nonatomic, assign) UIEdgeInsets separatorInsets;

@property (nonatomic, assign) CGSize sendButtonSize;

@property (strong, readonly, nonatomic) UIView *container;
@property (strong, readonly, nonatomic) id textInputResponder;
@property (strong, readonly, nonatomic) NHContainerView *topView;
@property (strong, readonly, nonatomic) NHContainerView *leftView;
@property (strong, readonly, nonatomic) NHContainerView *bottomView;
@property (strong, readonly, nonatomic) NHContainerView *rightView;
@property (strong, readonly, nonatomic) UIView *separatorView;

@property (nonatomic, assign) UIEdgeInsets initialScrollViewInsets;
@property (nonatomic, assign) UIEdgeInsets additionalInsets;
@property (nonatomic, readonly, assign) UIEdgeInsets keyboardInsets;
@property (nonatomic, readonly, assign) UIEdgeInsets messengerInsets;

- (instancetype)initWithScrollView:(UIScrollView*)scrollView;
- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                     andSuperview:(UIView*)superview;
- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                      andSuperview:(UIView*)superview
                 andTextInputClass:(Class)textInputClass;

- (void)updateMessengerView;
- (void)scrollToBottom;

@end
