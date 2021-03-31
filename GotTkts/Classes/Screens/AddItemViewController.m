//
//  AddItemViewController.m
//  GotTkts
//
//  Created by Jorge on 7/23/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "AddItemViewController.h"
#import "IQDropDownTextField.h"

@interface AddItemViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UITextField *txtTitle;
    IBOutlet UIPlaceHolderTextView *txtDescription;
    IBOutlet IQDropDownTextField *txtCategory;
    IBOutlet UIImageView *imgView;
    
    IBOutlet UIButton *btnPhoto;
    BOOL isCamera;
    BOOL isGallery;
    BOOL hasPhoto;
}
@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Util setCornerView:txtTitle];
    [Util setBorderView:txtTitle color:[UIColor whiteColor] width:1.0f];
    [Util setCornerView:txtDescription];
    [Util setBorderView:txtDescription color:[UIColor whiteColor] width:1.0f];
    [Util setCornerView:txtCategory];
    [Util setBorderView:txtCategory color:[UIColor whiteColor] width:1.0f];
    [Util setCornerView:imgView];
    [Util setBorderView:imgView color:[UIColor whiteColor] width:1.0f];
    
    txtDescription.placeholder = @"Enter description";
    txtDescription.placeholderColor = PLACEHOLDER_COLOR;
    txtCategory.itemList = CATEGORY_ARRAY;

    if (self.isEdit){
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPost:(id)sender {
    if (![self isValid]){
        return;
    }
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline."];
        return;
    }
    
}

- (IBAction)onAddPhotot:(id)sender {
    UIAlertController *actionsheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self onTakePhoto:nil];
    }]];
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"Choose from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self onChoosePhoto:nil];
    }]];
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:actionsheet animated:YES completion:nil];
}

- (void)onChoosePhoto:(id)sender {
    if (![Util isPhotoAvaileble]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Photo"];
        return;
    }
    isGallery = YES;
    isCamera = NO;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)onTakePhoto:(id)sender {
    if (![Util isCameraAvailable]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Cameras"];
        return;
    }
    isCamera = YES;
    isGallery = NO;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (isCamera && ![Util isCameraAvailable]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Cameras"];
        return;
    }
    if (isGallery && ![Util isPhotoAvaileble]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Photo"];
        return;
    }
    UIImage *image = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
    hasPhoto = YES;
    [btnPhoto setTitle:@"" forState:UIControlStateNormal];
    [imgView setImage:image];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (isGallery && ![Util isPhotoAvaileble]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Photo"];
        return;
    }
    if (isCamera && ![Util isCameraAvailable]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Cameras"];
        return;
    }
}

- (BOOL) isValid {
    txtTitle.text = [Util trim:txtTitle.text];
    txtDescription.text = [Util trim:txtDescription.text];
    if (txtTitle.text.length == 0){
        [Util showAlertTitle:self title:@"Error" message:@"Please enter title." finish:^(void){
            [txtTitle becomeFirstResponder];
        }];
        return NO;
    }
    if (txtDescription.text.length == 0){
        [Util showAlertTitle:self title:@"Error" message:@"Please enter description." finish:^(void){
            [txtDescription becomeFirstResponder];
        }];
        return NO;
    }
    if (txtCategory.selectedRow == -1){
        [Util showAlertTitle:self title:@"Error" message:@"Please choose category." finish:^(void){
            [txtCategory becomeFirstResponder];
        }];
        return NO;
    }
    if (!hasPhoto){
        [Util showAlertTitle:self title:@"Error" message:@"Please add photo." finish:^(void){
            [self onAddPhotot:nil];
        }];

        return NO;
    }
    return YES;
}

@end
