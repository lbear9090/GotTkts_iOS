//
//  CreateEventOneViewController.m
//  GotTkts
//
//  Created by Jorge on 10/23/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "CreateEventOneViewController.h"
#import "HSDatePickerViewController.h"
#import "CreateEventTwoViewController.h"
#import <GooglePlaces/GooglePlaces.h>

@interface CreateEventOneViewController ()<HSDatePickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate>
{
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtLocation;
    
    IBOutlet UITextField *txtStartDate;
    IBOutlet UITextField *txtEndDate;
    NSInteger selectedTag;
    IBOutlet UIImageView *imgEvent;
    
    BOOL hadPhoto;
    BOOL isPhotoOpen;
    BOOL isCameraOpen;
    IBOutlet UILabel *lblTitle;
    
    double latitude, longitude;
    NSString *address;
}
@end

@implementation CreateEventOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isEdit){
        txtTitle.text = self.eventData.event_name;
        txtLocation.text = self.eventData.event_address;
        txtStartDate.text = self.eventData.event_start_datetime;
        NSDate *date = [Util getDateFromString:self.eventData.event_start_datetime formatter:nil];
        txtStartDate.text = [NSDate stringFromDate:date withFormat:NSDateFormatDmy4Hm24 andTimeZone:NSDateTimeZoneUTC];
        date = [Util getDateFromString:self.eventData.event_end_datetime formatter:nil];
        txtEndDate.text = [NSDate stringFromDate:date withFormat:NSDateFormatDmy4Hm24 andTimeZone:NSDateTimeZoneUTC];
        lblTitle.text = @"Edit Event";
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//        [imgEvent hnk_setImageFromURL:[NSURL URLWithString:self.eventData.event_image]];
        [imgEvent hnk_setImageFromURL:[NSURL URLWithString:self.eventData.event_image] placeholder:[UIImage imageNamed:@"ic_add_image.png"] success:^(UIImage * image){
            [SVProgressHUD dismiss];
            imgEvent.image = image;
            hadPhoto = YES;
            self.eventData.event_old_image = self.eventData.event_image;
        } failure:^(NSError *error){
            [SVProgressHUD dismiss];
            [self showError:[error localizedDescription]];
        }];
    }
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onLocation:(id)sender {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

- (IBAction)onDatePicker:(id)sender {
    selectedTag = [sender tag];
    HSDatePickerViewController *hsdpvc = [[HSDatePickerViewController alloc] init];
    if (selectedTag == 200 && txtEndDate.text.length > 0){
        hsdpvc.date = [NSDate dateFromString:txtEndDate.text withFormat:NSDateFormatDmy4Hm24 andTimeZone:NSDateTimeZoneUTC];
    }
    hsdpvc.delegate = self;
    [self presentViewController:hsdpvc animated:YES completion:nil];
}

- (void)hsDatePickerPickedDate:(NSDate *)date {
    if (selectedTag == 100){ // start date time
        txtStartDate.text = [NSDate stringFromDate:date withFormat:NSDateFormatDmy4Hm24 andTimeZone:NSDateTimeZoneUTC];
        txtEndDate.text = [NSDate stringFromDate:date withFormat:NSDateFormatDmy4Hm24 andTimeZone:NSDateTimeZoneUTC];
    } else {
        txtEndDate.text = [NSDate stringFromDate:date withFormat:NSDateFormatDmy4Hm24 andTimeZone:NSDateTimeZoneUTC];
    }
}

- (IBAction)onNext:(id)sender {
    if (![self isValid]){
        return;
    }
    Event *event = [[Event alloc] init];
    event.event_name = txtTitle.text;
    event.event_latitude = latitude;
    event.event_longitude = longitude;
    event.event_start_datetime = txtStartDate.text;
    event.event_end_datetime = txtEndDate.text;
    event.event_location = txtLocation.text;
    event.event_address = address;
    event.image = imgEvent.image;

    if (self.isEdit){
        event.event_old_image = self.eventData.event_old_image;
        event.event_unique_id = self.eventData.event_unique_id;
        if (address.length == 0){
            event.event_address = event.event_location;
            event.event_latitude = self.eventData.event_latitude;
            event.event_longitude = self.eventData.event_longitude;
        }
    }

    CreateEventTwoViewController *vc = (CreateEventTwoViewController *)[Util getUIViewControllerFromStoryBoard:@"CreateEventTwoViewController"];
    vc.event = event;
    vc.isEdit = self.isEdit;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL) isValid {
    txtTitle.text = [Util trim:txtTitle.text];
    if (txtTitle.text.length == 0){
        [self showError:@"Please enter Event Title"];
        return NO;
    }
#ifdef DEBUG
    txtLocation.text = @"FL, Orlando";
    latitude = 0;
    longitude = 0;
    address = @"address";
#endif
    if (txtLocation.text.length == 0){
        [self showError:@"Please choose Event Location"];
        return NO;
    }
    if (txtStartDate.text.length == 0){
        [self showError:@"Please choose Event Start Date"];
        return NO;
    }
    if (txtEndDate.text.length == 0){
        [self showError:@"Please choose Event End Date."];
        return NO;
    }
    if (!hadPhoto){
        [self showError:@"Please choose Event Image."];
        return NO;
    }
    
    return YES;
}

- (IBAction)onImage:(id)sender {
    UIAlertController *actionsheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"Take a new photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self onTakePhoto:nil];
    }]];
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"Select from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
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
    isPhotoOpen = YES;
    isCameraOpen = NO;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)onTakePhoto:(id)sender {
    if (![Util isCameraAvailable]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Camera"];
        return;
    }
    isCameraOpen = YES;
    isPhotoOpen = NO;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (isCameraOpen &&![Util isCameraAvailable]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Camera"];
        return;
    }
    UIImage *image = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
    hadPhoto = YES;
    [imgEvent setImage:image];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (isPhotoOpen && ![Util isPhotoAvaileble]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Photo"];
        return;
    }
    if ( isCameraOpen &&![Util isCameraAvailable]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Camera"];
        return;
    }
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    txtLocation.text = place.name;
    address = place.formattedAddress;
    
    latitude = place.coordinate.latitude;
    longitude = place.coordinate.longitude;
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
    txtLocation.text = @"";
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    txtLocation.text = @"";
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
