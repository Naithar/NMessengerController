//
//  NMessengerController.h
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

@import UIKit;

@interface NHMessengerController : NSObject

@property (strong, readonly, nonatomic) UIView *container;
@property (strong, readonly, nonatomic) id textInputResponder;

- (instancetype)initWithScrollView:(UIScrollView*)scrollView;
- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                     andSuperview:(UIView*)superview;
- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                      andSuperview:(UIView*)superview
                 andTextInputClass:(Class)textInputClass;

@end
