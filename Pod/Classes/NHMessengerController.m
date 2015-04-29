//
//  NMessengerController.m
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

#import "NHMessengerController.h"

@interface NHMessengerController ()<UIGestureRecognizerDelegate>{
    Class responderType;
}

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIView *superview;

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) id textInputResponder;
@property (strong, nonatomic) NSLayoutConstraint *leftTextViewInset;
@property (strong, nonatomic) NSLayoutConstraint *rightTextViewInset;
@property (strong, nonatomic) NSLayoutConstraint *topTextViewInset;
@property (strong, nonatomic) NSLayoutConstraint *bottomTextViewInset;

@property (strong, nonatomic) id changeKeyboardObserver;
@property (strong, nonatomic) id showKeyboardObserver;
@property (strong, nonatomic) id hideKeyboardObserver;

@property (strong, nonatomic) id foundResponderForTextView;
@property (strong, nonatomic) id foundResponderForTextField;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (weak, nonatomic) UIView *keyboardView;

@property (nonatomic, assign) BOOL isInteractive;
@end

@implementation NHMessengerController

- (instancetype)initWithScrollView:(UIScrollView*)scrollView {
    return [self initWithScrollView:scrollView
                      andSuperview:scrollView];
}

- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                     andSuperview:(UIView*)superview {
    return [self initWithScrollView:scrollView andSuperview:superview andTextInputClass:[UITextView class]];
}

- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                      andSuperview:(UIView*)superview
                 andTextInputClass:(Class)textInputClass {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _superview = superview;
        responderType = textInputClass;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {

    _textViewInsets = UIEdgeInsetsMake(5, 5, 5, 5);

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    self.container = [[UIView alloc] initWithFrame:CGRectZero];
    [self.container setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.container.backgroundColor = [UIColor redColor];

    self.bottomConstraint = [NSLayoutConstraint constraintWithItem:self.container
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.superview
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0];

    [self.superview addSubview:self.container];
    [self.superview bringSubviewToFront:self.container];
    [self.superview addConstraint:self.bottomConstraint];

    [self.container addConstraint:[NSLayoutConstraint constraintWithItem:self.container
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                  toItem:self.container
                                                               attribute:NSLayoutAttributeHeight
                                                              multiplier:0
                                                                constant:30]];

    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.container
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0
                                                                constant:0]];

    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.container
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1.0
                                                                constant:0]];

    self.textInputResponder = [[responderType alloc] initWithFrame:CGRectZero];
    ((UIView*)self.textInputResponder).backgroundColor = [UIColor greenColor];
    [((UIView*)self.textInputResponder) setTranslatesAutoresizingMaskIntoConstraints:NO];
    if ([self.textInputResponder respondsToSelector:@selector(setInputAccessoryView:)]) {
        [self.textInputResponder performSelector:@selector(setInputAccessoryView:) withObject:[UIView new]];
    }

    [self.container addSubview:self.textInputResponder];

    self.topTextViewInset = [NSLayoutConstraint constraintWithItem:self.textInputResponder
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.container
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:self.textViewInsets.top];
    [self.container addConstraint:self.topTextViewInset];

    self.bottomTextViewInset = [NSLayoutConstraint constraintWithItem:self.textInputResponder
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.container
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:-self.textViewInsets.bottom];
    [self.container addConstraint:self.bottomTextViewInset];

    self.leftTextViewInset = [NSLayoutConstraint constraintWithItem:self.textInputResponder
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:self.textViewInsets.left];
    [self.container addConstraint:self.leftTextViewInset];

    self.rightTextViewInset = [NSLayoutConstraint constraintWithItem:self.textInputResponder
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.container
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:-self.textViewInsets.right];
    [self.container addConstraint:self.rightTextViewInset];


    __weak __typeof(self) weakSelf = self;
    self.changeKeyboardObserver = [[NSNotificationCenter defaultCenter]
                                   addObserverForName:UIKeyboardWillChangeFrameNotification
                                   object:nil
                                   queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       __strong __typeof(weakSelf) strongSelf = weakSelf;

                                       [strongSelf processKeyboardNotification:note.userInfo];
    }];

    self.showKeyboardObserver = [[NSNotificationCenter defaultCenter]
                                   addObserverForName:UIKeyboardWillShowNotification
                                   object:nil
                                   queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       __strong __typeof(weakSelf) strongSelf = weakSelf;

                                       [strongSelf processKeyboardNotification:note.userInfo];

                                       strongSelf.keyboardView.hidden = NO;
                                       strongSelf.panGesture.enabled = YES;
                                   }];

    self.hideKeyboardObserver = [[NSNotificationCenter defaultCenter]
                                   addObserverForName:UIKeyboardWillHideNotification
                                   object:nil
                                   queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       __strong __typeof(weakSelf) strongSelf = weakSelf;

                                       [strongSelf processKeyboardNotification:note.userInfo];

                                       strongSelf.panGesture.enabled = NO;
                                   }];

    self.foundResponderForTextView = [[NSNotificationCenter defaultCenter]
                                 addObserverForName:UITextViewTextDidBeginEditingNotification
                                 object:nil
                                 queue:nil
                                 usingBlock:^(NSNotification *note) {
                                     __strong __typeof(weakSelf) strongSelf = weakSelf;
                                     [strongSelf getKeyboardViewFromFirstResponder:note.object];
                                 }];

    self.foundResponderForTextField = [[NSNotificationCenter defaultCenter]
                                 addObserverForName:UITextFieldTextDidBeginEditingNotification
                                 object:nil
                                 queue:nil
                                 usingBlock:^(NSNotification *note) {
                                     __strong __typeof(weakSelf) strongSelf = weakSelf;
                                     [strongSelf getKeyboardViewFromFirstResponder:note.object];
                                 }];

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(panGestureAction:)];
    self.panGesture.maximumNumberOfTouches = 1;
    self.panGesture.minimumNumberOfTouches = 1;
    self.panGesture.delegate = self;
    [self.scrollView addGestureRecognizer:self.panGesture];

    if (self.scrollView.keyboardDismissMode != UIScrollViewKeyboardDismissModeOnDrag) {
        self.isInteractive = YES;
        self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
    }
    else {
        self.isInteractive = NO;
    }

}

- (void)processKeyboardNotification:(NSDictionary *)data {

    NSValue *keyboardRect = data[UIKeyboardFrameEndUserInfoKey];

    if (keyboardRect) {

        CGRect rect = [self.superview convertRect:[keyboardRect CGRectValue] fromView:nil];

        CGFloat offset = MAX(0, self.superview.frame.size.height - rect.origin.y);

        self.bottomConstraint.constant = -offset;
        [self.container layoutIfNeeded];
    }
}

- (void)getKeyboardViewFromFirstResponder:(UIResponder*)responder {
    if (responder.inputAccessoryView
        && !self.keyboardView) {
        self.keyboardView.hidden = NO;
        self.keyboardView = responder.inputAccessoryView.superview;
        self.keyboardView.hidden = NO;
    }
}
- (void)panGestureAction:(UIPanGestureRecognizer*)recognizer {
    if (!self.isInteractive) {
        return;
    }
    
    if (!self.keyboardView) {
        if ([self.textInputResponder respondsToSelector:@selector(inputAccessoryView)]) {
            self.keyboardView = ((UIResponder*)self.textInputResponder).inputAccessoryView.superview;
        }
        return;
    }


    CGFloat maxHeight = self.superview.bounds.size.height;

    CGPoint pointInView = [recognizer locationInView:self.superview];
    CGPoint velocityInView = [recognizer velocityInView:self.superview];
    [recognizer setTranslation:CGPointZero inView:self.superview];
//    BOOL keyboardIsDismissing = CGRectContainsPoint(CGRectInset(self.container.frame, 0, -5), pointInView);

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
//            self.keyboardView.userInteractionEnabled = NO;
            CGRect keyboardFrame = self.keyboardView.frame;
            CGFloat keyboardHeight = keyboardFrame.size.height;

            keyboardFrame.origin.y = pointInView.y + self.container.bounds.size.height;

            keyboardFrame.origin.y = MIN(keyboardFrame.origin.y, maxHeight);
            keyboardFrame.origin.y = MAX(keyboardFrame.origin.y, maxHeight - keyboardHeight);

            if (CGRectGetMinY(keyboardFrame) == CGRectGetMinY(self.keyboardView.frame)) {
                return;
            }




            [UIView animateWithDuration:0.0
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionNone
                             animations:^{
                                 CGFloat offset = MAX(0, self.superview.frame.size.height - keyboardFrame.origin.y);
                                 self.keyboardView.frame = keyboardFrame;
                                 self.bottomConstraint.constant = -offset;
                                 [self.container setNeedsLayout];
                                 [self.container layoutIfNeeded];
                             }
                             completion:nil];
        } break;
        default: {
//            if (keyboardIsDismissing) {
                [UIView animateWithDuration:0.3
                                      delay:0.0
                                    options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionNone
                                 animations:^{
                                     CGRect keyboardFrame = self.keyboardView.frame;
                                     CGFloat keyboardHeight = keyboardFrame.size.height;
                                     keyboardFrame.origin.y = maxHeight - ((velocityInView.y < 0) ? keyboardHeight : 0);
                                     CGFloat offset = (velocityInView.y < 0) ? keyboardHeight : 0;
                                     self.keyboardView.frame = keyboardFrame;
                                     self.bottomConstraint.constant = -offset;

                                     [self.container setNeedsLayout];
                                     [self.container layoutIfNeeded];
                                 }
                                 completion:^(BOOL _){
//                                     self.keyboardView.userInteractionEnabled = YES;
                                     if (velocityInView.y >= 0) {
                                     self.keyboardView.hidden = YES;
                                     [[UIApplication sharedApplication].keyWindow endEditing:YES];

                                     }
                                 }];
//            }
        } break;
    }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)setTextViewInsets:(UIEdgeInsets)textViewInsets {
    [self willChangeValueForKey:@"textViewInsets"];
    _textViewInsets = textViewInsets;

    self.leftTextViewInset.constant = _textViewInsets.left;
    self.rightTextViewInset.constant = - _textViewInsets.right;
    self.topTextViewInset.constant = _textViewInsets.top;
    self.bottomTextViewInset.constant = - _textViewInsets.bottom;

    [self didChangeValueForKey:@"textViewInsets"];
}
- (void)dealloc {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self.changeKeyboardObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.showKeyboardObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.hideKeyboardObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.foundResponderForTextView];
    [[NSNotificationCenter defaultCenter] removeObserver:self.foundResponderForTextField];
    self.keyboardView.userInteractionEnabled = YES;
    self.keyboardView.hidden = NO;
    [self.scrollView removeGestureRecognizer:self.panGesture];
    self.panGesture.delegate = nil;
}
@end