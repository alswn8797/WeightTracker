//
//  CameraViewController.m
//  BodyTracker
//
//  Created by MInju on 14/10/18.
//  Copyright © 2018 MInju. All rights reserved.
//

#import "CameraViewController.h"
#import "GalleryViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        pickerController.allowsEditing = YES;
        [self presentViewController:pickerController animated:YES completion:nil];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Camera Error" message:@"Your device does not have a camera!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [self.tabBarController setSelectedIndex:2];
    [picker dismissViewControllerAnimated:NO completion:nil];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    GalleryViewController *galleryViewController;
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    galleryViewController.galleryImage.image = image;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
