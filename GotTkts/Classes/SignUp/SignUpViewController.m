//
//  SignUpViewController.m
//  GotTkts
//
//  Created by Jorge on 7/3/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "SignUpViewController.h"
#import "JVFloatLabeledTextField.h"
#import "MainViewController.h"
#import "SideMenuViewController.h"
#import "UpdateProfile.h"
#import "IQDropDownTextField.h"

@interface SignUpViewController ()<CircleImageAddDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet JVFloatLabeledTextField *txtFirstname;
    IBOutlet JVFloatLabeledTextField *txtLastname;
    IBOutlet JVFloatLabeledTextField *txtEmail;
    IBOutlet JVFloatLabeledTextField *txtPassword;
    
    IBOutlet CircleImageView *imgAvatar;
    BOOL hadPhoto;
    BOOL isPhotoOpen;
    BOOL isCameraOpen;

    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnSignUp;
    IBOutlet JVFloatLabeledTextField *txtPhoneNumber;
    IBOutlet JVFloatLabeledTextField *txtRePassword;
    IBOutlet IQDropDownTextField *txtGender;
    IBOutlet JVFloatLabeledTextField *txtCity;
    IBOutlet JVFloatLabeledTextField *txtState;
    
    NSMutableArray *genderLabels;
    __weak IBOutlet UIView *viewPassword;
    IBOutlet UIView *viewRepass;
}
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Util setBorderView:imgAvatar color:[UIColor lightGrayColor] width:1.0f];
    imgAvatar.delegate = self;
    genderLabels = [NSMutableArray arrayWithObjects:@"Male", @"Female", nil];
    txtGender.itemList = genderLabels;
    
    if (self.isEdit){
        lblTitle.text = @"Edit Profile";
        [btnSignUp setTitle:@"Save" forState:UIControlStateNormal];
        
        txtEmail.enabled = NO;
        
        [self initData];
    }
    
}

- (void) initData {
    UserModel *me = [UserModel currentUser];
    if (me.avatar){
        [imgAvatar hnk_setImageFromURL:[NSURL URLWithString:me.avatar]];
    }
    txtFirstname.text = me.firstname;
    txtLastname.text = me.lastname;
    txtEmail.text = me.email;
    txtPassword.text = [Util getLoginUserPassword];
    [txtGender setSelectedRow:me.gender];
    [txtGender setSelectedItem:[genderLabels objectAtIndex:me.gender]];
    txtCity.text = me.city;
    txtState.text = me.state;
    
    viewPassword.hidden = YES;
    viewRepass.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onSignup {
    UIAlertController *actionsheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"Guest" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self registerUser:USER_TYPE_CUSTOMER];
    }]];
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"SubPromoter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self registerUser:USER_TYPE_SUB_PROMOTER];
    }]];
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"Promoter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self registerUser:USER_TYPE_PROMOTER];
    }]];
    [actionsheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }]];
    [self presentViewController:actionsheet animated:YES completion:nil];
}

- (void) registerUser:(NSInteger) userType {
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline"];
        return;
    }
    NSDictionary *params = @{
                           @"email" : txtEmail.text,
                           @"password" : txtPassword.text,
                           @"firstname" : txtFirstname.text,
                           @"lastname" : txtLastname.text,
                           @"gender" : [NSNumber numberWithInteger:txtGender.selectedRow],
                           @"state": txtState.text,
                           @"city": txtCity.text,
                           @"usertype"  : [NSString stringWithFormat:@"%ld", userType]
                           };
    [SVProgressHUD showWithStatus:@"Please wait..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:REQUEST_SIGN_UP parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        Response *response = [[Response alloc] initWithDictionary:(NSDictionary *) responseObject];
        if (response.isSuccess){
            [Util showAlertTitle:self title:@"Sign Up" message:@"Congratulations! Your account is created successfuly. Please check your email." finish:^(void){
                [Util setLoginUserName:txtEmail.text password:txtPassword.text];
                [self onBack:nil];
            }];
        } else {
            [self showError:response.errMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
}

- (IBAction)onSignup:(id)sender {
    if (![self isValid]){
        return;
    }
    
    if (!self.isEdit){
        if (!hadPhoto){
            NSString *msg = @"Are you sure you want to proceed without a profile photo?";
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.customViewColor = MAIN_COLOR;
            alert.horizontalButtons = YES;
            [alert addButton:@"Yes" actionBlock:^(void) {
                [self onSignup];
            }];
            [alert addButton:@"Upload photo" actionBlock:^(void) {
                [self tapCircleImageView];
            }];
            [alert showError:@"Sign Up" subTitle:msg closeButtonTitle:nil duration:0.0f];
        } else {
            [self onSignup];
        }
    } else {
        if (![Util isConnectableInternet]){
            [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline"];
            return;
        }

        NSDictionary *params = @{
                                 @"firstname" : txtFirstname.text,
                                 @"lastname" : txtLastname.text,
                                 @"usertype" : @"0",               // promoter user
                                 @"id" : [UserModel currentUser].user_id,
                                 @"password" : txtPassword.text
                                 };
        [SVProgressHUD showWithStatus:@"Please wait..."];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
//        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [manager POST:REQUEST_UPDATE_PROFILE parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (hadPhoto){
                [formData appendPartWithFileData:UIImageJPEGRepresentation(imgAvatar.image, 0.5) name:@"profile_pic" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject){
            [SVProgressHUD dismiss];
            UpdateProfile *response = [[UpdateProfile alloc] initWithDictionary:responseObject];
            if (response.success){
                UserModel *me = [UserModel currentUser];
                if (response.profile_picture)
                    me.avatar = response.profile_picture;
                me.firstname = response.firstname;
                me.lastname = response.lastname;
            }
            [Util showAlertTitle:self title:@"Edit Profile" message:@"Your profile has been updated successfully." finish:^{
                [self onBack:nil];
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [self showError:@"Failed to update profile"];
        }];
    }
}

- (void) tapCircleImageView {
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

- (BOOL) isValid {
    txtFirstname.text = [Util trim:txtFirstname.text];
    txtLastname.text = [Util trim:txtLastname.text];
    txtEmail.text = [Util trim:txtEmail.text];
    txtPhoneNumber.text = [Util trim:txtPhoneNumber.text];
    txtState.text = [Util trim:txtState.text];
    txtCity.text = [Util trim:txtCity.text];
    
    NSString *firstName = txtFirstname.text;
    if (firstName.length == 0){
        [Util showAlertTitle:self title:@"Error" message:@"Please input your first name."];
        return NO;
    }
    NSString *lastName = txtLastname.text;
    if (lastName.length == 0){
        [Util showAlertTitle:self title:@"Error" message:@"Please input your last name."];
        return NO;
    }
    NSString *email = txtEmail.text;
    if (email.length == 0){
        [Util showAlertTitle:self title:@"Error" message:@"Please input your email adddress."];
        return NO;
    }
    if (![email isEmail]){
        [Util showAlertTitle:self title:@"Error" message:@"Please input valid email adddress."];
        return NO;
    }
    if (txtGender.selectedRow == -1){
        [Util showAlertTitle:self title:@"Error" message:@"Please choose your gender."];
        return NO;
    }
    if (txtState.text.length == 0){
        [Util showAlertTitle:self title:@"Error" message:@"Please input your state."];
        return NO;
    }
    if (txtCity.text.length == 0){
        [Util showAlertTitle:self title:@"Error" message:@"Please input your city."];
        return NO;
    }
    if (txtPassword.text.length == 0){
        [Util showAlertTitle:self title:@"Error" message:@"Please input your password."];
        return NO;
    }
    if (![txtPassword.text isEqualToString:txtRePassword.text] && !self.isEdit){
        [Util showAlertTitle:self title:@"Error" message:@"Passwords do not match."];
        return NO;
    }
    
    return YES;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (isCameraOpen &&![Util isCameraAvailable]){
        [Util showAlertTitle:self title:@"Error" message:@"Check your permissions in Settings > Privacy > Camera"];
        return;
    }
    UIImage *image = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
    hadPhoto = YES;
    [imgAvatar setImage:image];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
