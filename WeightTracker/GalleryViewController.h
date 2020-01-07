//
//  GalleryViewController.h
//  BodyTracker
//
//  Created by MInju on 14/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface GalleryViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *galleryImage;

- (IBAction)takePhoto:(id)sender;

@end
