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

@property (strong, nonatomic) NHContainerView *leftView;
@property (strong, nonatomic) NSLayoutConstraint *leftLeftViewInset;
@property (strong, nonatomic) NSLayoutConstraint *topLeftViewInset;
@property (strong, nonatomic) NSLayoutConstraint *bottomLeftViewInset;

@property (strong, nonatomic) NHContainerView *rightView;
@property (strong, nonatomic) NSLayoutConstraint *rightRightViewInset;
@property (strong, nonatomic) NSLayoutConstraint *topRightViewInset;
@property (strong, nonatomic) NSLayoutConstraint *bottomRightViewInset;

@property (nonatomic, strong) UIButton *sendButton;

@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) NSLayoutConstraint *rightSeparatorInset;
@property (strong, nonatomic) NSLayoutConstraint *leftSeparatorInset;
@property (strong, nonatomic) NSLayoutConstraint *bottomSeparatorInset;

@property (strong, nonatomic) NHContainerView *topView;
@property (strong, nonatomic) NSLayoutConstraint *rightTopViewInset;
@property (strong, nonatomic) NSLayoutConstraint *leftTopViewInset;

@property (strong, nonatomic) NHContainerView *bottomView;
@property (strong, nonatomic) NSLayoutConstraint *rightBottomViewInset;
@property (strong, nonatomic) NSLayoutConstraint *leftBottomViewInset;

@property (strong, nonatomic) id changeKeyboardObserver;
@property (strong, nonatomic) id showKeyboardObserver;
@property (strong, nonatomic) id hideKeyboardObserver;

@property (strong, nonatomic) id foundResponderForTextView;
@property (strong, nonatomic) id foundResponderForTextField;

@property (strong, nonatomic) id textFieldTextObserver;
@property (strong, nonatomic) id textViewTextObserver;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (weak, nonatomic) UIView *keyboardView;

@property (nonatomic, assign) BOOL isInteractive;

@property (nonatomic, assign) UIEdgeInsets keyboardInsets;
@property (nonatomic, assign) UIEdgeInsets messengerInsets;
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
    _containerInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _separatorInsets = UIEdgeInsetsMake(0, 0, 1, 0);
    _sendButtonSize = CGSizeMake(60, 40);
    _initialScrollViewInsets = self.scrollView.contentInset;
    _additionalInsets = UIEdgeInsetsZero;

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    self.container = [[UIView alloc] initWithFrame:CGRectZero];
    [self.container setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.container.opaque = NO;
    self.container.backgroundColor = [UIColor redColor];
    self.container.clipsToBounds = YES;

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
                                                               relatedBy:NSLayoutRelationLessThanOrEqual
                                                                  toItem:self.container
                                                               attribute:NSLayoutAttributeHeight
                                                              multiplier:0
                                                                constant:self.superview.bounds.size.height - 325]];

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

    self.separatorView = [[UIView alloc] initWithFrame:CGRectZero];
    self.separatorView.opaque = NO;
    self.separatorView.backgroundColor = [UIColor blackColor];
    [self.separatorView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.container addSubview:self.separatorView];

    [self.container addConstraint:[NSLayoutConstraint constraintWithItem:self.separatorView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.container
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0
                                                                constant:0]];

    self.leftSeparatorInset = [NSLayoutConstraint constraintWithItem:self.separatorView
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.container
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:self.separatorInsets.left];

    [self.container addConstraint:self.leftSeparatorInset];

    self.rightSeparatorInset = [NSLayoutConstraint constraintWithItem:self.separatorView
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.container
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:-self.separatorInsets.right];

    [self.container addConstraint:self.rightSeparatorInset];

    [self.separatorView addConstraint:[NSLayoutConstraint constraintWithItem:self.separatorView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.separatorView
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:0
                                                                    constant:0.5]];

    self.topView = [[NHContainerView alloc] initWithFrame:CGRectZero];
    self.topView.opaque = NO;
    [self.topView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.topView.backgroundColor = [UIColor darkGrayColor];
//    self.topView.contentSize = CGSizeMake(50, 50);
    [self.container addSubview:self.topView];

    self.bottomSeparatorInset = [NSLayoutConstraint constraintWithItem:self.topView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.separatorView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:self.separatorInsets.bottom];

    [self.container addConstraint:self.bottomSeparatorInset];

    self.leftTopViewInset = [NSLayoutConstraint constraintWithItem:self.topView
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.container
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:self.containerInsets.left];

    [self.container addConstraint:self.leftTopViewInset];

    self.rightTopViewInset = [NSLayoutConstraint constraintWithItem:self.topView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.container
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:-self.containerInsets.right];

    [self.container addConstraint:self.rightTopViewInset];


    self.bottomView = [[NHContainerView alloc] initWithFrame:CGRectZero];
    self.bottomView.opaque = NO;
    [self.bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.bottomView.backgroundColor = [UIColor darkGrayColor];
    [self.container addSubview:self.bottomView];

    self.leftBottomViewInset = [NSLayoutConstraint constraintWithItem:self.bottomView
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.container
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:self.containerInsets.left];

    [self.container addConstraint:self.leftBottomViewInset];

    self.rightBottomViewInset = [NSLayoutConstraint constraintWithItem:self.bottomView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.container
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-self.containerInsets.right];

    [self.container addConstraint:self.rightBottomViewInset];

    [self.container addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.container
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:0]];

    self.textInputResponder = [[responderType alloc] initWithFrame:CGRectZero];
    ((UIView*)self.textInputResponder).backgroundColor = [UIColor greenColor];
    [((UIView*)self.textInputResponder) setTranslatesAutoresizingMaskIntoConstraints:NO];
    if ([self.textInputResponder respondsToSelector:@selector(setInputAccessoryView:)]) {
        [self.textInputResponder performSelector:@selector(setInputAccessoryView:) withObject:[UIView new]];
    }
    [self.container addSubview:self.textInputResponder];

    self.leftView = [[NHContainerView alloc] initWithFrame:CGRectZero];
    self.leftView.opaque = NO;
    self.leftView.backgroundColor = [UIColor lightGrayColor];
    [self.leftView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.leftView.clipsToBounds = YES;
    [self.container addSubview:self.leftView];

    self.rightView = [[NHContainerView alloc] initWithFrame:CGRectZero];
    self.rightView.opaque = NO;
    [self.rightView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.rightView.backgroundColor = [UIColor lightGrayColor];
    self.rightView.hidden = YES;
    self.rightView.contentSize = CGSizeMake(0, self.sendButtonSize.height);
    [self.container addSubview:self.rightView];

    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.sendButtonSize.width, self.sendButtonSize.height)];
    self.sendButton.opaque = NO;
    [self.sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.backgroundColor = [UIColor redColor];
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.rightView addSubview:self.sendButton];

    self.leftLeftViewInset = [NSLayoutConstraint constraintWithItem:self.leftView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.container
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:self.containerInsets.left];
    [self.container addConstraint:self.leftLeftViewInset];

    self.bottomLeftViewInset = [NSLayoutConstraint constraintWithItem:self.leftView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.bottomView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant:-self.containerInsets.bottom];

    [self.container addConstraint:self.bottomLeftViewInset];

    self.topLeftViewInset = [NSLayoutConstraint constraintWithItem:self.leftView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:self.topView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:self.containerInsets.top];

    [self.container addConstraint:self.topLeftViewInset];



    self.topTextViewInset = [NSLayoutConstraint constraintWithItem:self.textInputResponder
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                            toItem:self.topView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:self.textViewInsets.top];
    [self.container addConstraint:self.topTextViewInset];

    self.bottomTextViewInset = [NSLayoutConstraint constraintWithItem:self.textInputResponder
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.bottomView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant:-self.textViewInsets.bottom];
    [self.container addConstraint:self.bottomTextViewInset];

    self.leftTextViewInset = [NSLayoutConstraint constraintWithItem:self.textInputResponder
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.leftView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:self.textViewInsets.left];
    [self.container addConstraint:self.leftTextViewInset];

    self.rightTextViewInset = [NSLayoutConstraint constraintWithItem:self.textInputResponder
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.rightView
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:-self.textViewInsets.right];
    [self.container addConstraint:self.rightTextViewInset];

    self.rightRightViewInset = [NSLayoutConstraint constraintWithItem:self.rightView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.container
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-self.containerInsets.right];
    [self.container addConstraint:self.rightRightViewInset];

    self.bottomRightViewInset = [NSLayoutConstraint constraintWithItem:self.rightView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                                toItem:self.bottomView
                                                             attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant:-self.containerInsets.bottom];

    [self.container addConstraint:self.bottomRightViewInset];

    self.topRightViewInset = [NSLayoutConstraint constraintWithItem:self.rightView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                             toItem:self.topView
                                                          attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:self.containerInsets.top];

    [self.container addConstraint:self.topRightViewInset];


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

                                       if ([weakSelf.delegate respondsToSelector:@selector(willShowKeyboardForMessenger:)]) {
                                           [weakSelf.delegate willShowKeyboardForMessenger:weakSelf];
                                       }
                                   }];

    self.hideKeyboardObserver = [[NSNotificationCenter defaultCenter]
                                   addObserverForName:UIKeyboardWillHideNotification
                                   object:nil
                                   queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       __strong __typeof(weakSelf) strongSelf = weakSelf;

                                       [strongSelf processKeyboardNotification:note.userInfo];

//                                       strongSelf.keyboardView.hidden = NO;
                                       strongSelf.panGesture.enabled = NO;

                                       if ([weakSelf.delegate respondsToSelector:@selector(willHideKeyboardForMessenger:)]) {
                                           [weakSelf.delegate willHideKeyboardForMessenger:weakSelf];
                                       }
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

    self.textFieldTextObserver = [[NSNotificationCenter defaultCenter]
                                  addObserverForName:UITextFieldTextDidChangeNotification
                                  object:self.textInputResponder
                                  queue:nil
                                  usingBlock:^(NSNotification *note) {
                                      __strong __typeof(weakSelf) strongSelf = weakSelf;
                                      [strongSelf processText];
                                  }];

    self.textViewTextObserver = [[NSNotificationCenter defaultCenter]
                                  addObserverForName:UITextViewTextDidChangeNotification
                                  object:self.textInputResponder
                                  queue:nil
                                  usingBlock:^(NSNotification *note) {
                                      __strong __typeof(weakSelf) strongSelf = weakSelf;
                                      [strongSelf processText];
                                  }];

    if ([self.textInputResponder respondsToSelector:@selector(text)]) {
        [self.textInputResponder addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }

    [self.container addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

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

    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];

    _messengerInsets = UIEdgeInsetsMake(0, 0, self.container.bounds.size.height, 0);

}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"text"]
        && object == self.textInputResponder) {

        NSString *oldText = change[NSKeyValueChangeOldKey];
        NSString *newText = change[NSKeyValueChangeNewKey];

        if ([oldText isEqualToString:newText]) {
            return;
        }

        [self processText];
    }

    if ([keyPath isEqualToString:@"bounds"]
        && object == self.container) {

        CGRect oldRect = [change[NSKeyValueChangeOldKey] CGRectValue];
        CGRect newRect = [change[NSKeyValueChangeNewKey] CGRectValue];

        if (CGRectEqualToRect(oldRect, newRect)) {
            return;
        }

        self.messengerInsets = UIEdgeInsetsMake(0, 0, newRect.size.height, 0);

        [self updateInsets];
    }
}
- (void)processText {
    if ([self.textInputResponder respondsToSelector:@selector(text)]) {
        NSString *currentText = [[self.textInputResponder text]
                                 stringByTrimmingCharactersInSet:[NSCharacterSet
                                                                  whitespaceAndNewlineCharacterSet]];

        __weak __typeof(self) weakSelf = self;
        if ([weakSelf.delegate respondsToSelector:@selector(messenger:didChangeText:)]) {
            [weakSelf.delegate messenger:weakSelf didChangeText:currentText];
        }

        CGFloat newSize = (currentText && [currentText length] > 0) ? self.sendButtonSize.width : 0;

        if (newSize == self.rightView.contentSize.width) {
            return;
        }

        if (newSize != 0) {
            self.rightView.hidden = NO;
        }

        if ([weakSelf.delegate respondsToSelector:@selector(messenger:didChangeButtonHiddenTo:)]) {
            [weakSelf.delegate messenger:weakSelf didChangeButtonHiddenTo:newSize == 0];
        }

        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.rightView.contentSize = CGSizeMake(newSize, self.sendButtonSize.height);
            [self.rightView invalidateIntrinsicContentSize];
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished){
            self.rightView.hidden = newSize == 0;
        }];
    }
}

- (void)processKeyboardNotification:(NSDictionary *)data {

    NSValue *keyboardRect = data[UIKeyboardFrameEndUserInfoKey];

    if (keyboardRect) {

        CGRect rect = [self.superview convertRect:[keyboardRect CGRectValue] fromView:nil];

        CGFloat offset = MAX(0, self.superview.frame.size.height - rect.origin.y);

        self.bottomConstraint.constant = -offset;
        self.keyboardInsets = UIEdgeInsetsMake(0, 0, offset, 0);
        [self updateInsets];
        [self.superview layoutIfNeeded];
    }
}

- (void)getKeyboardViewFromFirstResponder:(UIResponder*)responder {
    if (responder.inputAccessoryView
        && !self.keyboardView) {
        self.keyboardView.hidden = NO;
        self.keyboardView = responder.inputAccessoryView.superview;
        self.keyboardView.hidden = NO;
    }

    __weak __typeof(self) weakSelf = self;
    if ([weakSelf.delegate respondsToSelector:@selector(didStartEditingInMessenger:)]) {
        [weakSelf.delegate didStartEditingInMessenger:weakSelf];
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
                                 self.keyboardInsets = UIEdgeInsetsMake(0, 0, offset, 0);
                                 [self updateInsets];
//                                 [self.container setNeedsLayout];
                                 [self.superview layoutIfNeeded];
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
                                     self.keyboardInsets = UIEdgeInsetsMake(0, 0, offset, 0);
                                     [self updateInsets];

//                                     [self.container setNeedsLayout];
                                     [self.superview layoutIfNeeded];
                                 }
                                 completion:^(BOOL _){
//                                     self.keyboardView.userInteractionEnabled = YES;
                                     [self updateInsets];
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

    [self.superview layoutIfNeeded];

    [self didChangeValueForKey:@"textViewInsets"];
}

- (void)updateMessengerView {
    [self.topView calculateContentSize];
    [self.topView invalidateIntrinsicContentSize];

    [self.bottomView calculateContentSize];
    [self.bottomView invalidateIntrinsicContentSize];

    [self.leftView calculateContentSize];
    [self.leftView invalidateIntrinsicContentSize];

    [self.rightView invalidateIntrinsicContentSize];

    if ([self.textInputResponder respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
        [self.textInputResponder invalidateIntrinsicContentSize];
    }

    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];

    self.messengerInsets = UIEdgeInsetsMake(0, 0, self.container.bounds.size.height, 0);
    [self updateInsets];
}


- (void)setContainerInsets:(UIEdgeInsets)containerInsets {
    [self willChangeValueForKey:@"containerInsets"];
    _containerInsets = containerInsets;

    self.leftLeftViewInset.constant = _containerInsets.left;
    self.topLeftViewInset.constant = _containerInsets.top;
    self.bottomLeftViewInset.constant = - _containerInsets.bottom;

    self.rightRightViewInset.constant = - _containerInsets.right;
    self.topRightViewInset.constant = _containerInsets.top;
    self.bottomRightViewInset.constant = - _containerInsets.bottom;

    self.leftTopViewInset.constant = _containerInsets.left;
    self.rightTopViewInset.constant = - _containerInsets.right;

    self.leftBottomViewInset.constant = _containerInsets.left;
    self.rightBottomViewInset.constant = - _containerInsets.right;

    [self.superview layoutIfNeeded];

    [self didChangeValueForKey:@"containerInsets"];
}

- (void)setSeparatorInsets:(UIEdgeInsets)separatorInsets {
    [self willChangeValueForKey:@"separatorInsets"];
    _separatorInsets = separatorInsets;
    self.leftSeparatorInset.constant = _separatorInsets.left;
    self.rightSeparatorInset.constant = - _separatorInsets.right;
    self.bottomSeparatorInset.constant = _separatorInsets.bottom;
    [self didChangeValueForKey:@"separatorInsets"];
}

- (void)setSendButtonSize:(CGSize)sendButtonSize {
    [self willChangeValueForKey:@"sendButtonSize"];

    self.sendButton.frame = CGRectMake(0, 0, sendButtonSize.width, sendButtonSize.height);
    if (CGSizeEqualToSize(self.rightView.contentSize, _sendButtonSize)) {
        self.rightView.contentSize = sendButtonSize;
        [self.rightView invalidateIntrinsicContentSize];
        [self.superview layoutIfNeeded];
    }

    _sendButtonSize = sendButtonSize;

    [self didChangeValueForKey:@"sendButtonSize"];
}

- (void)sendButtonAction:(UIButton*)sender {
    __weak __typeof(self) weakSelf = self;
    if ([weakSelf.delegate respondsToSelector:@selector(messenger:didSendText:)]) {
        NSString *currentText;

        if ([self.textInputResponder respondsToSelector:@selector(text)]) {
            currentText = [[self.textInputResponder text]
                           stringByTrimmingCharactersInSet:[NSCharacterSet
                                                            whitespaceAndNewlineCharacterSet]];
        }

        [weakSelf.delegate messenger:weakSelf didSendText:currentText];
    }
}

- (void)updateInsets {
    self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top,
                                                    self.scrollView.contentInset.left,
                                                    self.initialScrollViewInsets.bottom
                                                    + self.additionalInsets.bottom
                                                    + self.messengerInsets.bottom
                                                    + self.keyboardInsets.bottom,
                                                    self.scrollView.contentInset.right);

    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
}

- (void)scrollToBottom {
    [self scrollToBottomAnimated:NO];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    [self.scrollView scrollRectToVisible:CGRectMake(0, self.scrollView.contentSize.height - 1, 1, 1) animated:animated];
}

- (void)dealloc {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if ([self.textInputResponder respondsToSelector:@selector(text)]) {
        [self.textInputResponder removeObserver:self forKeyPath:@"text" context:nil];
    }
    [self.container removeObserver:self forKeyPath:@"bounds" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.changeKeyboardObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.showKeyboardObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.hideKeyboardObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.foundResponderForTextView];
    [[NSNotificationCenter defaultCenter] removeObserver:self.foundResponderForTextField];
    [[NSNotificationCenter defaultCenter] removeObserver:self.textFieldTextObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.textViewTextObserver];
    self.keyboardView.userInteractionEnabled = YES;
    self.keyboardView.hidden = NO;
    [self.scrollView removeGestureRecognizer:self.panGesture];
    self.panGesture.delegate = nil;
}
@end