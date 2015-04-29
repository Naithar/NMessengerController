//
//  NMessengerController.h
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

@import UIKit;
#import "NHContainerView.h"

@interface NHMessengerController : NSObject

@property (nonatomic, assign) UIEdgeInsets textViewInsets;
@property (nonatomic, assign) UIEdgeInsets containerInsets;
@property (nonatomic, assign) UIEdgeInsets separatorInsets;

@property (nonatomic, assign) CGSize sendButtonSize;

@property (strong, readonly, nonatomic) UIView *container;
@property (strong, readonly, nonatomic) id textInputResponder;
@property (strong, readonly, nonatomic) NHContainerView *leftView;
@property (strong, readonly, nonatomic) NHContainerView *rightView;
@property (strong, readonly, nonatomic) UIView *separatorView;

- (instancetype)initWithScrollView:(UIScrollView*)scrollView;
- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                     andSuperview:(UIView*)superview;
- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                      andSuperview:(UIView*)superview
                 andTextInputClass:(Class)textInputClass;

- (void)updateMessengerView;

@end
