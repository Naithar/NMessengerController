//
//  NMessengerController.m
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

#import "NHMessengerController.h"

@interface NHMessengerController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIView *superview;

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) UITextView *textView;

@property (strong, nonatomic) id changeKeyboardObserver;
@property (strong, nonatomic) id showKeyboardObserver;
@property (strong, nonatomic) id hideKeyboardObserver;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation NHMessengerController

- (instancetype)initWithTableView:(UITableView*)tableView {
    return [self initWithTableView:tableView
                      andSuperview:tableView];
}

- (instancetype)initWithTableView:(UITableView*)tableView
                     andSuperview:(UIView*)superview {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _superview = superview;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.superview.bounds.size.width, 50)];
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
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.container
                                                               attribute:NSLayoutAttributeHeight
                                                              multiplier:0
                                                                constant:50]];

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

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.superview.bounds.size.width - 20, 30)];
    self.textView.backgroundColor = [UIColor greenColor];
    [self.container addSubview:self.textView];


    __weak __typeof(self) weakSelf = self;
    self.changeKeyboardObserver = [[NSNotificationCenter defaultCenter]
                                   addObserverForName:UIKeyboardWillChangeFrameNotification
                                   object:nil
                                   queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       __strong __typeof(weakSelf) strongSelf = self;

                                       [strongSelf processKeyboardNotification:note.userInfo];
    }];

    self.showKeyboardObserver = [[NSNotificationCenter defaultCenter]
                                   addObserverForName:UIKeyboardWillShowNotification
                                   object:nil
                                   queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       __strong __typeof(weakSelf) strongSelf = self;

                                       [strongSelf processKeyboardNotification:note.userInfo];
                                   }];

    self.hideKeyboardObserver = [[NSNotificationCenter defaultCenter]
                                   addObserverForName:UIKeyboardWillHideNotification
                                   object:nil
                                   queue:nil
                                   usingBlock:^(NSNotification *note) {
                                       __strong __typeof(weakSelf) strongSelf = self;

                                       [strongSelf processKeyboardNotification:note.userInfo];
                                   }];

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(panGestureAction:)];
    self.panGesture.delegate = self;
    [self.tableView addGestureRecognizer:self.panGesture];

}

- (void)processKeyboardNotification:(NSDictionary *)data {

    NSValue *keyboardRect = data[UIKeyboardFrameEndUserInfoKey];

    if (keyboardRect) {
//        var keyboardFrame = self.parentView?.convertRect(keyboardEndFrame!, fromView: nil) ?? nil

        CGRect rect = [self.superview convertRect:[keyboardRect CGRectValue] fromView:nil];

        CGFloat offset = MAX(0, self.superview.frame.size.height - rect.origin.y);

        self.bottomConstraint.constant = -offset;
        [self.superview layoutIfNeeded];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer*)recognizer {
    NSLog(@"%@",recognizer);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

//var height = keyboardFrame != nil
////        ? max(0, (self.parentView?.frame.height ?? 0) - (keyboardFrame?.origin.y ?? 0))
////        : 0
////
////        UIView.animateWithDuration(0,
////                                   delay: 0,
////                                   options: .BeginFromCurrentState | .TransitionNone,
////                                   animations: {
////                                       var newInset = self.originalContentInsets.bottom + height + (self.currentContainerHeight ?? 0)
////
////                                       if self.shouldChangeBottomInset?(self, newInset) != false {
////                                           self.scrollView?.contentInset.bottom = newInset
////                                           self.scrollView?.scrollIndicatorInsets.bottom = newInset
////
////                                           self.didChangeBottomInset?(self, newInset)
////                                       }
////
////                                       self.changeContainerOffset(height)
////
////                                       return
////                                   }, completion: nil)


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.changeKeyboardObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.showKeyboardObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.hideKeyboardObserver];
    [self.tableView removeGestureRecognizer:self.panGesture];
    self.panGesture.delegate = nil;
}
@end



//
//  MessengerController.swift
//  Messenger
//
//  Created by Naithar on 29.09.14.
//  Copyright (c) 2014 ITC-Project. All rights reserved.
//
//

//import Foundation
//import UIKit
//
//public class PlaceholderTextView: UITextView {
//
//    override public var font: UIFont! {
//        didSet {
//            self.placeholderLabel?.font = self.font
//        }
//    }
//
//    override public dynamic var text: String! {
//        didSet {
//            self.textChanged(nil)
//            //            NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: nil);
//        }
//    }
//    //    override public var textColor: UIColor! {
//    //        didSet {
//    //            self.placeholderLabel?.textColor = self.textColor != nil ? self.textColor.colorWithAlphaComponent(0.35)
//    //                : UIColor(white: 0.85, alpha: 1)
//    //        }
//    //    }
//    var placeholderLabel : UILabel!
//
//    required public init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        self.createLabel()
//    }
//
//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//
//        self.createLabel()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.createLabel()
//    }
//
//    func createLabel() {
//        if self.placeholderLabel != nil {
//            return
//        }
//
//        self.placeholderLabel = UILabel(frame: CGRectZero)
//        //R:0 G:0 B:0.098 A:0.22
//        self.placeholderLabel.textColor = UIColor(red: 0, green: 0, blue: 0.098, alpha: 0.22)
//        self.placeholderLabel.numberOfLines = 1
//        self.placeholderLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
//        self.placeholderLabel.backgroundColor = UIColor.clearColor()
//        if self.font != nil {
//            self.placeholderLabel.font = self.font
//        }
//        self.addSubview(self.placeholderLabel)
//
//        layout(self.placeholderLabel) { view in
//            view.left == view.superview!.left + 5
//            view.right == view.superview!.right - 5
//            view.top == view.superview!.top + 7.5
//        }
//
//        self.placeholderLabel.textAlignment = NSTextAlignment.Left
//        self.placeholderLabel.hidden = self.text != nil && self.text.utf16Count > 0
//
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChanged:", name: UITextViewTextDidChangeNotification, object: self)
//    }
//
//    func textChanged(notification: NSNotification!) {
//        if self.text != nil && self.text.utf16Count > 0 {
//            self.placeholderLabel?.hidden = true
//        }
//        else {
//            self.placeholderLabel?.hidden = false
//        }
//    }
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
//
//}
//
//public class MessengerController : NSObject, UITextViewDelegate {
//
//    enum State {
//    case Normal, Waiting
//    }
//
//    let loadingImageName = "loading-red"
//
//    public let defaultTextViewFont = UIFont(name: "Helvetica", size: 15)
//    public let defaultContainerColor = UIColor.whiteColor()
//    public let defaultTextViewColor = UIColor.whiteColor()
//    public let defaultTextColor = UIColor.blackColor()
//    public let defaultButtonColor = UIColor.whiteColor()
//    public let defaultNormalButtonTextColor = UIColor.blueColor()
//    public let defaultHighlightedButtonTextColor = UIColor.blueColor().colorWithAlphaComponent(0.25)
//    public let defaultDisabledButtonTextColor = UIColor(white: 0.85, alpha: 1)
//    public let defaultSeparatorColor = UIColor(
//                                               red: 200/255,
//                                               green: 200/255,
//                                               blue: 200/255,
//                                               alpha: 1)
//
//    public let defaultLeftOffset: Float = 10
//    public let defaultRightOffset: Float = 10
//    public let defaultTopOffset: Float = 5
//    public let defaultBottomOffset: Float = 5
//    public let defaultPlaceholder: String = "(chat_message_placeholder)"~~"MessengerController"
//
//    private let containerViewOffset: Float = 10
//    private let startTextViewHeight: Float = 20
//
//    public var maxLength: Int = -1
//
//    private var textViewHeightOffset: CGFloat {
//        get {
//            return (self.textView != nil
//                    ? self.textView.textContainerInset.top + self.textView.textContainerInset.bottom
//                    : 16)
//        }
//    }
//    private var textViewWidthOffset: CGFloat {
//        get {
//            return self.textView != nil
//            ? self.textView.textContainerInset.right + self.textView.textContainerInset.left + 10
//            : 10
//        }
//    }
//
//    private var lineHeight: CGFloat = 0
//
//    private(set) var containerView: UIView!
//    private(set) var sendButton: UIButton!
//    private(set) var loadingImageView: UIImageView!
//    private(set) var textView: PlaceholderTextView!
//    private var separatorView: UIView!
//    private var keyboardView : UIView!
//
//    weak private var parentView: UIView?
//    weak private var scrollView: UIScrollView?
//
//    private var containerBottomOffset: NSLayoutConstraint!
//    public var containerAdditionalOffset: Float = 0
//    private var textViewHeight: NSLayoutConstraint!
//
//    private var textViewLeftOffset: NSLayoutConstraint!
//    private var textViewRightOffset: NSLayoutConstraint!
//    private var textViewTopOffset: NSLayoutConstraint!
//    private var textViewBottomOffset: NSLayoutConstraint!
//    private var sendButtonBottomOffset: NSLayoutConstraint!
//
//    private var messengerListener: Listener!
//
//    public var maxLineCount: Int = 4
//    public var originalContentInsets: UIEdgeInsets = UIEdgeInsetsZero
//    public var originalScrollInsets: UIEdgeInsets = UIEdgeInsetsZero
//
//    public var editedTextColor : UIColor!
//    public var normalTextColor : UIColor!
//
//    dynamic public var sendButtonEnabled: Bool = true
//
//    public var maxTextLength: Int = 0
//
//    public var leftOffset: Float {
//        didSet {
//            self.textViewLeftOffset?.constant = CGFloat(self.leftOffset)
//        }
//    }
//    public var rightOffset: Float {
//        didSet {
//            self.textViewRightOffset?.constant = -CGFloat(self.rightOffset)
//        }
//    }
//    public var topOffset: Float {
//        didSet {
//            self.textViewTopOffset?.constant = CGFloat(self.topOffset)
//        }
//    }
//    public var bottomOffset: Float {
//        didSet {
//            self.textViewBottomOffset?.constant = -CGFloat(self.bottomOffset) - CGFloat(self.containerViewOffset)
//            self.sendButtonBottomOffset?.constant = -CGFloat(self.bottomOffset) - CGFloat(self.containerViewOffset)
//        }
//    }
//
//    var maxTextViewHeight: CGFloat {
//        get {
//            return CGFloat(self.maxLineCount - 1) * self.lineHeight + self.textViewHeightOffset
//        }
//    }
//
//    var currentContainerHeight: CGFloat {
//        get {
//            return self.containerView != nil
//            ? self.containerView!.bounds.height - CGFloat(self.containerViewOffset)
//            : 0
//        }
//    }
//
//    var font: UIFont? {
//        didSet {
//            self.textView?.font = self.font ?? self.defaultTextViewFont
//            self.recalculateTextViewHeight(self.textView, text: "")
//            self.changeContainerOffset(0)
//        }
//    }
//
//    public var startEditAction: ((MessengerController?) -> ())?
//    public var stopEditAction: ((MessengerController?) -> ())?
//    public var shouldChangeBottomInset: ((MessengerController?, CGFloat) -> (Bool))?
//    public var didChangeBottomInset: ((MessengerController?, CGFloat) -> ())?
//    public var didTouchSendButton: ((MessengerController?, text: String) -> ())?
//    public var didChangeText: ((MessengerController?, PlaceholderTextView?, String) -> ())?
//
//    public init(parentView: UIView, scrollView: UIScrollView) {
//        self.leftOffset = self.defaultLeftOffset
//        self.rightOffset = self.defaultRightOffset
//        self.topOffset = self.defaultTopOffset
//        self.bottomOffset = self.defaultBottomOffset
//
//        super.init()
//
//        self.parentView = parentView
//        self.scrollView = scrollView
//        self.scrollView?.panGestureRecognizer.addTarget(self, action: "panGesture:")
//
//        self.originalContentInsets = self.scrollView?.contentInset ?? UIEdgeInsetsZero
//        self.originalScrollInsets = self.scrollView?.scrollIndicatorInsets ?? UIEdgeInsetsZero
//
//        self.containerView = UIView(frame: CGRectZero)~>{
//            $0.backgroundColor = self.defaultContainerColor
//            $0.clipsToBounds = true
//
//            RACObserve($0, "bounds").subscribeNext { [weak weakSelf = self] data in
//                weakSelf?.changeInsets(weakSelf?.calculateKeyboardFrame())
//                return
//            }
//        }
//
//        self.textView = PlaceholderTextView(frame: CGRectZero)~>{
//            $0.delegate = self
//            $0.font = self.font ?? self.defaultTextViewFont
//            $0.textColor = UIColor.blackColor()
//            $0.backgroundColor = self.defaultTextViewColor
//            $0.inputAccessoryView = UIView(frame: CGRectZero)
//            $0.placeholderLabel?.text = self.defaultPlaceholder
//            $0.layoutManager.allowsNonContiguousLayout = false
//
//            RACObserve($0, "bounds").subscribeNext { [weak weakTextView = $0, weak weakSelf = self] data in
//                if weakSelf?.textViewHeight?.constant < weakSelf?.maxTextViewHeight {
//                    weakTextView?.contentOffset.y = 0
//                }
//                return
//            }
//
//            RACObserve($0, "text").distinctUntilChanged().subscribeNext { [weak weakTextView = $0, weak weakSelf = self] data in
//
//                let range = weakTextView?.selectedRange
//
//                weakTextView?.font = weakSelf?.font ?? weakSelf?.defaultTextViewFont
//                weakTextView?.textColor = weakSelf?.editedTextColor ?? weakSelf?.defaultTextColor
//
//                if let text = data as? String {
//                    weakSelf?.didChangeText?(weakSelf, weakTextView, text)
//                    weakSelf?.recalculateTextViewHeight(weakTextView, text: text)
//                }
//
//                if let textRange = range {
//                    weakTextView?.selectedRange = textRange
//                }
//                return
//            }
//
//            $0.rac_textSignal()/*.distinctUntilChanged()*/.subscribeNext { [weak weakTextView = $0, weak weakSelf = self] data in
//                if let text = data as? String {
//                    let range = weakTextView?.selectedRange
//
//                    weakTextView?.text = text
//
//                    if let textRange = range {
//                        weakTextView?.selectedRange = textRange
//                    }
//
//                    if let attributed = weakTextView?.attributedText {
//                        var mutableAttributed = NSMutableAttributedString(attributedString: attributed)
//
//                        mutableAttributed.removeAttribute(NSLinkAttributeName, range: NSRange(0..<mutableAttributed.length))
//
//                        weakTextView?.attributedText = mutableAttributed
//                    }
//
//
//                }
//                return
//            }
//        }
//
//        self.sendButton = UIButton(frame: CGRectZero)~>{
//            $0.backgroundColor = self.defaultButtonColor
//            $0.setTitle("(send_action)"~~"MessengerController", forState: .Normal)
//            $0.setTitleColor(self.defaultNormalButtonTextColor, forState: .Normal)
//            $0.setTitleColor(self.defaultHighlightedButtonTextColor, forState: .Highlighted)
//            $0.setTitleColor(self.defaultDisabledButtonTextColor, forState: .Disabled)
//
//            var buttonEnabledSignal = RACObserve(self, "sendButtonEnabled")
//            //            var textViewSignal = self.textView.rac_textSignal().map { [weak weakSelf = self] data in
//            //                var text = data as? String
//            //                return text != nil
//            //                    && text?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " ")).utf16Count > 0
//            //            }
//            var textSignal = RACObserve(self.textView, "text").map { [weak weakSelf = self] data in
//                var text = data as? String
//                return text != nil
//                && text?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " \n")).utf16Count > 0
//            }
//
//            RAC($0, "enabled") <~ RACSignal.combineLatest([buttonEnabledSignal, textSignal]).map { [weak weakSelf = self] data in
//                return ((data[0] as? Bool) ?? false) && ((data[1] as? Bool) ?? false)
//            }
//
//            $0.rac_signalForControlEvents(.TouchUpInside).subscribeNext { [weak weakSelf = self] data in
//                weakSelf?.sendButtonEnabled = false
//                ITCAsync.main(after: 0.25) { _ in
//                    weakSelf?.sendButtonEnabled = true
//                    return
//                }
//                weakSelf?.didTouchSendButton?(weakSelf, text: weakSelf?.textView.text ?? "")
//                return
//            }
//        }
//
//        self.loadingImageView = UIImageView(image: UIImage(named: self.loadingImageName))
//
//        self.separatorView = UIView(frame: CGRectZero)~>{
//            $0.backgroundColor = self.defaultSeparatorColor
//            return
//        }
//
//        self.parentView?.addSubview(self.containerView)
//        layout(self.containerView) { view in
//            self.containerBottomOffset = view.bottom == view.superview!.bottom + self.containerViewOffset - self.containerAdditionalOffset
//            view.height >= self.startTextViewHeight
//            view.left == view.superview!.left
//            view.right == view.superview!.right
//        }
//
//        self.containerView.addSubview(self.textView)
//        self.containerView.addSubview(self.sendButton)
//        layout(self.textView, self.sendButton) { textView, button in
//            button.right == button.superview!.right - 8
//            button.width >= 55
//            button.width <= 100
//            button.height >= self.startTextViewHeight
//            self.sendButtonBottomOffset = (button.bottom == button.superview!.bottom - self.bottomOffset - self.containerViewOffset - 3)
//
//            self.textViewLeftOffset = textView.left == textView.superview!.left + self.leftOffset
//            self.textViewRightOffset = textView.right == button.left - self.rightOffset
//            self.textViewTopOffset = textView.top == textView.superview!.top + self.topOffset
//            self.textViewBottomOffset = (textView.bottom == textView.superview!.bottom - self.bottomOffset - self.containerViewOffset)
//            self.textViewHeight = textView.height == self.startTextViewHeight
//        }
//
//        self.containerView.addSubview(self.loadingImageView)
//        layout(self.loadingImageView, self.sendButton) { imageView, button in
//            imageView.center == button.center
//            imageView.height == 20
//            imageView.width == 20
//        }
//
//        self.containerView.addSubview(self.separatorView)
//        layout(self.separatorView) { view in
//            view.left == view.superview!.left
//            view.right == view.superview!.right
//            view.top == view.superview!.top
//            view.height == 0.5
//        }
//
//        self.messengerListener = Listener(name: "messenger-Listener")
//        self.messengerListener[UIKeyboardDidShowNotification] = { [weak weakSelf = self] data in
//            weakSelf?.keyboardView = weakSelf?.textView.inputAccessoryView?.superview
//            weakSelf?.processKeyboardNotifications(data)
//            return
//        }
//        self.messengerListener[UIKeyboardDidHideNotification] = { [weak weakSelf = self] data in
//            weakSelf?.keyboardView = nil
//            weakSelf?.processKeyboardNotifications(data)
//            return
//        }
//        self.messengerListener[UIKeyboardWillChangeFrameNotification] = { [weak weakSelf = self] data in
//            weakSelf?.processKeyboardNotifications(data)
//            return
//        }
//
//        self.calculateLineHeight()
//        self.recalculateTextViewHeight(self.textView, text: "")
//        self.changeContainerOffset(0)
//
//        self.setState(.Normal)
//
//        self.textView.scrollsToTop = false
//    }
//
//    func setState(state: Int) {
//        switch state {
//        case 0:
//            self.loadingImageView.hidden = true
//            self.sendButton.hidden = false
//            self.stopAnimation()
//            break
//        case 1:
//            self.loadingImageView.hidden = false
//            self.sendButton.hidden = true
//            self.startAnimation()
//            break
//        default:
//            break
//        }
//    }
//
//    func setState(state: State) {
//        switch state {
//        case .Normal:
//            self.loadingImageView.hidden = true
//            self.sendButton.hidden = false
//            self.stopAnimation()
//            break
//        case .Waiting:
//            self.loadingImageView.hidden = false
//            self.sendButton.hidden = true
//            self.startAnimation()
//            break
//        default:
//            break
//        }
//    }
//
//    func startAnimation() {
//        if self.loadingImageView.layer
//            .animationForKey("rotationAnimation") != nil{
//                return
//            }
//
//        var rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotationAnimation.toValue = M_PI * 2.1
//        rotationAnimation.duration = 0.75
//        rotationAnimation.removedOnCompletion = false
//        rotationAnimation.cumulative = true;
//        rotationAnimation.repeatCount = HUGE;
//
//        self.loadingImageView.transform = CGAffineTransformMakeRotation(0)
//        self.loadingImageView.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
//    }
//
//    func stopAnimation() {
//        if self.loadingImageView.layer
//            .animationForKey("rotationAnimation") == nil {
//                return
//            }
//
//        self.loadingImageView.layer.removeAnimationForKey("rotationAnimation")
//    }
//
//    func calculateLineHeight() {
//        self.lineHeight = STBHelper.getStringRectFromText("",
//                                                          andFont: self.textView.font,
//                                                          andMaxWidth: 100,
//                                                          andLineBreakMode: NSLineBreakMode.ByWordWrapping).height + 2
//    }
//
//    func calculateKeyboardFrame() -> CGRect? {
//        var keyboardFrame = self.keyboardView != nil
//        ? self.parentView?.convertRect(self.keyboardView!.frame, fromView: nil)
//        : nil
//
//        if (keyboardFrame?.origin.y ?? 0) >= (self.parentView?.bounds.height ?? 0) {
//            //            self.scrollView?.panGestureRecognizer.state = UIGestureRecognizerState.Ended
//            self.scrollView?.panGestureRecognizer.enabled = false
//            self.scrollView?.panGestureRecognizer.enabled = true
//        }
//
//        return keyboardFrame
//    }
//
//    func changeContainerOffset(offset: CGFloat) {
//        self.containerBottomOffset?.constant = min(CGFloat(self.containerViewOffset), -offset + CGFloat(self.containerViewOffset) - (offset == 0 ? CGFloat(self.containerAdditionalOffset) : CGFloat(0)))
//
//        if let parentView = self.parentView {
//            if parentView.respondsToSelector(selector("setNeedsUpdateConstraints")) {
//                parentView.setNeedsUpdateConstraints()
//            }
//
//            if parentView.respondsToSelector(selector("layoutIfNeeded")) {
//                parentView.layoutIfNeeded()
//            }
//        }
//    }
//
//    func changeInsets(keyboardFrame: CGRect?) {
//        var height = keyboardFrame != nil
//        ? max(0, (self.parentView?.frame.height ?? 0) - (keyboardFrame?.origin.y ?? 0))
//        : 0
//
//        UIView.animateWithDuration(0,
//                                   delay: 0,
//                                   options: .BeginFromCurrentState | .TransitionNone,
//                                   animations: {
//                                       var newInset = self.originalContentInsets.bottom + height + (self.currentContainerHeight ?? 0)
//
//                                       if self.shouldChangeBottomInset?(self, newInset) != false {
//                                           self.scrollView?.contentInset.bottom = newInset
//                                           self.scrollView?.scrollIndicatorInsets.bottom = newInset
//
//                                           self.didChangeBottomInset?(self, newInset)
//                                       }
//
//                                       self.changeContainerOffset(height)
//
//                                       return
//                                   }, completion: nil)
//
//    }
//
//    func recalculateTextViewHeight(textView: UITextView?, text: String!) {
//        var textHeight = text.utf16Count > 0
//        ? STBHelper.getStringRectFromAttributedText(textView?.attributedText, andMaxWidth: (textView?.bounds.width ?? self.textViewWidthOffset) - self.textViewWidthOffset).height
//        : STBHelper.getStringRectFromText(text,
//                                          andFont: textView?.font ?? defaultTextViewFont,
//                                          andMaxWidth: (textView?.bounds.width ?? self.textViewWidthOffset) - self.textViewWidthOffset,
//                                          andLineBreakMode: NSLineBreakMode.ByWordWrapping).height
//
//        let height = CGFloat(ceil(textHeight)) + self.textViewHeightOffset
//
//        let maxHeight = self.maxTextViewHeight
//
//        textView?.contentSize.height = height
//
//        if height <= maxHeight {
//            self.textViewHeight?.constant = CGFloat(height)
//        }
//        else {
//            self.textViewHeight?.constant = CGFloat(maxHeight)
//        }
//
//        UIView.animateWithDuration(
//                                   0.15,
//                                   delay: 0,
//                                   options: UIViewAnimationOptions.BeginFromCurrentState | UIViewAnimationOptions.CurveLinear,
//                                   animations: { [weak weakSelf = self] in
//                                       weakSelf?.parentView?.setNeedsUpdateConstraints()
//                                       weakSelf?.parentView?.layoutIfNeeded()
//                                   }, completion: nil)
//    }
//
//    func processKeyboardNotifications(userInfo: [String : AnyObject], animate: Bool = true) {
//        var keyboardEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue();
//
//        if keyboardEndFrame == nil {
//            return
//        }
//
//
//        var keyboardFrame = self.parentView?.convertRect(keyboardEndFrame!, fromView: nil) ?? nil
//
//        if !keyboardFrame {
//            return
//        }
//
//        self.changeInsets(keyboardFrame)
//
//        if animate {
//            var animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey]?.integerValue
//            var animationOption : NSInteger = animationCurve! << 16
//            var animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
//            
//            UIView.animateWithDuration(
//                                       animationDuration!,
//                                       delay: 0,
//                                       options: UIViewAnimationOptions(rawValue: UInt(animationOption)) | UIViewAnimationOptions.BeginFromCurrentState,
//                                       animations: {
//                                           self.parentView?.setNeedsUpdateConstraints()
//                                           self.parentView?.layoutIfNeeded()
//                                       }, completion: {
//                                           completed in
//                                       })
//        }
//        else {
//            self.parentView?.setNeedsUpdateConstraints()
//            self.parentView?.layoutIfNeeded()
//        }
//    }
//    
//    func panGesture(recognizer: UIPanGestureRecognizer!) {
//        //posible change to keyboard notification did change frame
//        
//        if !self.textView.isFirstResponder()
//            || self.textViewHeight.constant == 0 {
//                return
//            }
//        
//        self.changeInsets(self.calculateKeyboardFrame())
//    }
//    
//    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        
//        if self.maxLength > 0 {
//            return checkMaxLength(textView, range, text, self.maxLength)
//        }
//        
//        return true
//    }
//    
//    public func textViewDidBeginEditing(textView: UITextView) {
//        textView.textColor = self.editedTextColor ?? self.defaultTextColor
//        
//        self.startEditAction?(self)
//    }
//    
//    public func textViewDidEndEditing(textView: UITextView) {
//        textView.textColor = self.normalTextColor ?? self.defaultTextColor
//        
//        self.stopEditAction?(self)
//    }
//    
//    deinit {
//        self.textView?.delegate = nil
//        self.scrollView?.delegate = nil
//        self.textView?.removeFromSuperview()
//        self.containerView?.removeFromSuperview()
//        
//        NSLog("deinit messenger")
//    }
//    
//}