//
//  NHPhotoMessengerController.h
//  Pods
//
//  Created by Naithar on 30.04.15.
//
//

#import "NHMessengerController.h"

@interface NHPhotoMessengerController : NHMessengerController

@property (nonatomic, readonly, strong) UIButton *attachmentButton;


- (void)addImageToCollection:(UIImage*)image;

@end
