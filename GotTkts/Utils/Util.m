//
//  Util.m
//  NorgesVPN
//
//  Created by IOS7 on 7/22/14.
//  Copyright (c) 2014 com.bruno.norgesVPN. All rights reserved.
//

#import "Util.h"
#import "SCLAlertView.h"

@implementation Util

static CustomIOS7AlertView *customAlertView;


/***************************************************************/
/***************************************************************/
/* Indicator Management *****************************************/
/***************************************************************/
/***************************************************************/

+ (NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&*()_+=|\{}[]:',./?><;";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", (unichar) [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

+ (void) setBoolValue:(NSString *) key value:(BOOL) val{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:val forKey:key];
    [defaults synchronize];
}

+ (BOOL) getBoolValue:(NSString *) key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL val = [defaults boolForKey:key];
    return val;
}


+ (void) setCircleView:(UIView*) view {
    [view layoutIfNeeded];
    view.layer.cornerRadius = view.frame.size.height/2;
    view.layer.masksToBounds = YES;
}

+ (void) setCornerView:(UIView*) view {
    view.layer.cornerRadius = 7;
    view.layer.masksToBounds = YES;
}

+ (void) setBorderView:(UIView *)view color:(UIColor*)color width:(CGFloat)width {
    view.layer.borderColor = [color CGColor];
    view.layer.borderWidth = width;
}

+ (void) setCornerCollection:(NSArray*) collection {
    for (UIView *view in collection) {
        [Util setCornerView:view];
    }
}

+ (void) setBorderCollection:(NSArray*) collection color:(UIColor*)color {
    for (UIView *view in collection) {
        [Util setBorderView:view color:color width:1.f];
    }
}

+ (void)_rotateImageView:(UIImageView *)imgVRotationView
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [imgVRotationView setTransform:CGAffineTransformRotate(imgVRotationView.transform, 1)];
    }completion:^(BOOL finished){
        if (finished) {
            [Util _rotateImageView:imgVRotationView];
        }
    }];
}
        

+ (void)showAlertTitle:(UIViewController *)vc title:(NSString *)title message:(NSString *)message
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.shouldDismissOnTapOutside = YES;
    alert.showAnimationType = SCLAlertViewShowAnimationSimplyAppear;
    [alert alertIsDismissed:^{
    }];
    alert.customViewColor = MAIN_COLOR;
    
    [alert showInfo:vc title:title subTitle:message closeButtonTitle:@"OK" duration:0.0f];
}

+ (void)showAlertTitle:(UIViewController *)vc title:(NSString *)title message:(NSString *)message finish:(void (^)(void))finish
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.shouldDismissOnTapOutside = YES;
    alert.showAnimationType = SCLAlertViewShowAnimationSimplyAppear;
    [alert alertIsDismissed:^{
        if (finish) {
            finish ();
        }
    }];
    [alert setForceHideBlock:^{
        if (finish) {
            finish ();
        }
    }];
    alert.customViewColor = MAIN_COLOR;
    
    [alert showInfo:vc title:title subTitle:message closeButtonTitle:@"OK" duration:0.0f];
}

+ (void)showAlertTitle:(UIViewController *)vc title:(NSString *)title message:(NSString *)message info:(BOOL)info
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.shouldDismissOnTapOutside = YES;
    alert.showAnimationType = SCLAlertViewShowAnimationSimplyAppear;
    [alert alertIsDismissed:^{
    }];
    alert.customViewColor = MAIN_COLOR;
    
    if (info)
        [alert showInfo:vc title:title subTitle:message closeButtonTitle:@"OK" duration:0.0f];
    else
        [alert showQuestion:vc title:title subTitle:message closeButtonTitle:@"OK" duration:0.0f];
}

+ (CustomIOS7AlertView *) showCustomAlertView:(UIView *) parentView view:(UIView *) view buttonTitleList:(NSMutableArray *)buttonTitleList completionBlock: (void (^)(int buttonIndex))completionBlock
{
    if (customAlertView == nil) {
        customAlertView =  [[CustomIOS7AlertView alloc] init];
    } else {
        for (UIView *view in customAlertView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    // Add some custom content to the alert view
    [customAlertView setContainerView:view];
    
    // Modify the parameters
    [customAlertView setButtonTitles:buttonTitleList];
    
    // You may use a Block, rather than a delegate.
    [customAlertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %ld.", buttonIndex, (long)[alertView tag]);
        [alertView close];
        completionBlock (buttonIndex);
    }];
    
    customAlertView.parentView = parentView;
    [customAlertView show];
    [customAlertView setUseMotionEffects:true];
    
    return customAlertView;
}

+ (void) hideCustomAlertView {
    if (customAlertView != nil) {
        [customAlertView close];
    }
}

+ (void) setLoginUserName:(NSString*) userName password:(NSString*) password {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"userName"];
    [defaults setObject:password forKey:@"password"];
    [defaults synchronize];
    
    // Installation
    if (userName.length > 0 && password.length > 0) {
        
    } else {
        
    }
}

+ (NSString*) getLoginUserName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"userName"];
    return userName;
}

+ (NSString*) getLoginUserPassword {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [defaults objectForKey:@"password"];
    return password;
}


+ (UIViewController*) getUIViewControllerFromStoryBoard:(NSString*) storyboardIdentifier {
    UIStoryboard *mainSB =  nil;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        mainSB =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    } else {
        mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    UIViewController *vc = [mainSB instantiateViewControllerWithIdentifier:storyboardIdentifier];
    return vc;
}

+ (UIViewController *) getNewViewControllerFromStoryBoard:(NSString *) storyboardIdentifier
{
    UIStoryboard *mainSB =  nil;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        mainSB =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    } else {
        mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    if ([APP_THEME isEqualToString:@"customer"]){
        storyboardIdentifier = [NSString stringWithFormat:@"%@%@", storyboardIdentifier,@"_cs"];
    } else if ([APP_THEME isEqualToString:@"business"]){
        storyboardIdentifier = [NSString stringWithFormat:@"%@%@", storyboardIdentifier,@"_bs"];
    }
    UIViewController *vc = [mainSB instantiateViewControllerWithIdentifier:storyboardIdentifier];
    return vc;
}

+ (UITextField *)getTextFieldFromSearchBar:(UISearchBar *)searchBar
{
    UITextField *searchBarTextField = nil;
    NSArray *views = ([self getOSVersion] < 7.0f) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *subView in views) {
        if ([subView isKindOfClass:[UITextField class]]) {
            searchBarTextField = (UITextField *)subView;
            break;
        }
    }
    return searchBarTextField;
}


+ (CGFloat)getOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSDate*) convertString2HourTime:(NSString*) dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    
    return dateFromString;
}

+ (NSString *) convertDate2String:(NSDate*) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (void) drawBorderLine:(UIView *) view upper: (BOOL)isUpper bottom:(BOOL) isBottom bottomDiff:(CGFloat) bottomDiff borderColor:(UIColor*) borderColor {
    if (view == nil) {
        return;
    }
    CGFloat height = 2.0f;
    
    if (isUpper) {
        UIView *upperBorder = [[UIView alloc] init];;
        upperBorder.backgroundColor = borderColor;
        upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), height);
        [view addSubview:upperBorder];
    }
    
    if (isBottom) {
        if (bottomDiff == 0.f) {
            bottomDiff = -height;
        }
        CGFloat pos_y = view.frame.size.height + bottomDiff - 0.5f;
        UIView *bottomBorder = [[UIView alloc] init];;
        bottomBorder.backgroundColor = borderColor;
        bottomBorder.frame = CGRectMake(0,  pos_y, CGRectGetWidth(view.frame), height);
        [view addSubview:bottomBorder];
    }
}

+ (void) removeBorderLine:(UIView*) view removeColor:(UIColor*) removeColor {
    NSArray *subViewList = view.subviews;
    for(int i = 0 ; i < subViewList.count ; i++) {
        UIView *subView = [subViewList objectAtIndex:i];
        UIColor *orgColor = subView.backgroundColor;
        if ([self isEqualToColor:orgColor otherColor:removeColor]) {
            [subView removeFromSuperview];
        }
    }
}

+ (BOOL)isEqualToColor:(UIColor*)orgColor otherColor:(UIColor *)otherColor {
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color) {
        if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            CGColorRef colorRef = CGColorCreate( colorSpaceRGB, components );
            
            UIColor *color = [UIColor colorWithCGColor:colorRef];
            CGColorRelease(colorRef);
            return color;
        } else
            return color;
    };
    
    UIColor *selfColor = convertColorToRGBSpace(orgColor);
    otherColor = convertColorToRGBSpace(otherColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:otherColor];
}

static inline double radians (double degrees) {return degrees * M_PI/180;}
+ (UIImage *) getSquareImage:(UIImage *)originalImage {
    CGFloat width = originalImage.size.width;
    CGFloat height = originalImage.size.height;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat square = width;
    if (width > height) {
        square = height;
    }
    
    x = abs(width - square) / 2;
    y = 0;//abs(height - square) / 2;
    
    CGRect cropRect = CGRectMake(x, y, square, square);
    
    // //////
    CGImageRef imageRef = CGImageCreateWithImageInRect([originalImage CGImage], cropRect);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    CGContextRef bitmap = CGBitmapContextCreate(NULL, cropRect.size.width, cropRect.size.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    
    if (originalImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, - cropRect.size.height);
        
    } else if (originalImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -cropRect.size.width, 0);
        
    } else if (originalImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (originalImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, cropRect.size.width, cropRect.size.height);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, cropRect.size.width, cropRect.size.height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    
    UIImage *resultImage=[UIImage imageWithCGImage:ref];
    CGImageRelease(imageRef);
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    
    NSLog(@"orgImage: %ld, newImage: %ld",originalImage.imageOrientation, resultImage.imageOrientation);
    
    return resultImage;
}

+ (UIImage *)getUploadingImageFromImage:(UIImage *)image {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    
    // dont' resize, use the original image. we can adjust this value of maxResolution like 1024, 768, 640  and more less than current value.
    CGFloat maxResolution = 320.f;
    if (image.size.width < maxResolution) {
        CGSize newSize = CGSizeMake(image.size.width, image.size.height);
        UIGraphicsBeginImageContext(newSize);
        // CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blackColor].CGColor);
        // CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, newSize.width, newSize.height));
        [image drawInRect:CGRectMake(0,
                                     0,
                                     image.size.width,
                                     image.size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        CGFloat rate = image.size.width / maxResolution;
        CGSize newSize = CGSizeMake(maxResolution, image.size.height / rate);
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
}

+ (void) downloadFile:(NSString *)url name:(NSString *) name completionBlock:(void (^)(NSURL *downloadurl, NSData *data, NSError *err))completionBlock {
    NSURL *remoteurl = [NSURL URLWithString:url];
    NSString *fileName = name;
    if (name == nil) {
        fileName = [url lastPathComponent];
    }
    NSString *filePath = [[self getDocumentDirectory] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
        NSURL *localurl = [NSURL fileURLWithPath:filePath];
        if (completionBlock)
            completionBlock(localurl, data, nil);
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:remoteurl];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Download Error:%@",error.description);
            if (completionBlock)
                completionBlock(nil, data, error);
        } else if (data) {
            [data writeToFile:filePath atomically:YES];
            NSLog(@"File is saved to %@",filePath);
            
            NSURL *localurl = [NSURL fileURLWithPath:filePath];
            if (completionBlock)
                completionBlock(localurl, data, error);
        }
    }];
}

+ (BOOL) isPhotoAvaileble {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted){
        return NO;
    } else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        }];
        return YES;
    } else {
        return YES;
    }
}

+ (BOOL) isCameraAvailable {
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
            return NO;
        }
        else if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:nil];
            return YES;
        }
        return YES;
    }
    else
        return YES;
}

+ (NSString *) downloadedURL:(NSString *)url name:(NSString *) name {
    NSString *fileName = name;
    if (name == nil) {
        fileName = [url lastPathComponent];
    }
    NSString *filePath = [[self getDocumentDirectory] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSURL *localurl = [NSURL fileURLWithPath:filePath];
        return localurl.absoluteString;
    }
    
    return nil;
}

+ (NSString *) trim:(NSString *) string {
    NSString *newString = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    return newString;
}

#pragma mark - Get the Label Width By message
+ (CGFloat) getLabelWidthByMessage :(NSString *) message fontSize:(CGFloat) fontSize {
    
    CGSize ideal_size = [message sizeWithFont:[UIFont systemFontOfSize:fontSize]];
    
    CGFloat messageWidth = ideal_size.width;
    
    return messageWidth;
}

+ (NSString *) getDocumentDirectory {    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/", [paths objectAtIndex:0]]; //create NSString object, that holds our exact path to the documents directory
    return  documentsDirectory;
}

#pragma mark appdelegate
+ (AppDelegate *) appDelegate {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate;
}

+ (void) animationExchangeView:(UIView *)parent src:(UIView *)src dst:(UIView *)dst duration:(NSTimeInterval)duration back:(BOOL)back vertical:(BOOL)vertical {
    if (dst == src)
        return;
    
    if (!src) {
        dst.hidden = NO;
        [parent bringSubviewToFront:dst];
        return;
    }
    
    CGRect rect = dst.frame;
    CGRect dstrect = rect;
    
    src.hidden = YES;
    [parent bringSubviewToFront:dst];
    dst.hidden = NO;
    if (vertical) {
        if (back)
            dstrect.origin.y -= dstrect.size.height;
        else
            dstrect.origin.y += dstrect.size.height;
    } else {
        if (back)
            dstrect.origin.x -= dstrect.size.width;
        else
            dstrect.origin.x += dstrect.size.width;
    }
    dst.frame = dstrect;
    
    // executing animation
    [UIView animateWithDuration:duration delay:0 options:(UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction) animations:^{
        // bring dst to front
        dst.frame = rect;
    } completion:^(BOOL finished) {
        // hide it after animation completes
        src.hidden = YES;
    }];
}

+ (NSString *) getParseDate:(NSDate *)date
{
    NSDate *updated = date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    if ([self isToday:date]){
        [dateFormat setDateFormat:@"h:mm a"];
    } else {
        [dateFormat setDateFormat:@"MMM d, h:mm a"];
    }
    NSString *result = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:updated]];
    return result;
}

+ (BOOL)isToday:(NSDate *)date
{
    return [[self dateStartOfDay:date] isEqualToDate:[self dateStartOfDay:[NSDate date]]];
}

+ (NSDate *)dateStartOfDay:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components =
    [gregorian               components:(NSCalendarUnitYear | NSCalendarUnitMonth |
                                         NSCalendarUnitDay) fromDate:date];
    return [gregorian dateFromComponents:components];
}

+ (NSString *) getExpireDateString:(NSDate *)date
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    return [dateFormatter stringFromDate:date];
}
+ (NSString *) convertDate2StringWithFormat:(NSDate*) date dateFormat:(NSString*) format  {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (BOOL) isConnectableInternet {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        return NO;
    } else {
        NSLog(@"There IS internet connection");
        return YES;
    }
}

+ (void) showWaitingDialog:(NSString *) text view:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.color = [UIColor whiteColor];
    hud.labelText = text;
    hud.labelColor = [UIColor blackColor];
}

//+ (void) setImage:(UIImageView *)imgView imgFile:(PFFile *)imgFile {
//    NSString *imageURL;
//
//    imageURL = [Util downloadedURL:imgFile.url name:nil];
//    if (!imageURL) {
//        imageURL = [Util urlparseCDN:imgFile.url];
//        [Util downloadFile:imageURL name:nil completionBlock:nil];
//    }
//
//    [imgView setImageWithURL:[NSURL URLWithString:imageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//}

//+ (void)setParsePictureOf:(UIImageView *)imageView file:(PFFile *)pFile default:(NSString *)name {
//
//    if (pFile) {
//        UIActivityIndicatorView *waitView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        [waitView hidesWhenStopped];
//        CGSize imageSize = imageView.frame.size;
//        CGSize aSize = waitView.frame.size;
//        [waitView setFrame:CGRectMake((imageSize.width - aSize.width) / 2.0, (imageSize.height - aSize.height) / 2.0, aSize.width, aSize.height)];
//        [imageView addSubview:waitView];
//        [waitView startAnimating];
//        [pFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//            [waitView stopAnimating];
//            [waitView removeFromSuperview];
//
//            [imageView setImage:[UIImage imageWithData:data]];
//        }];
//    } else if (name && name.length > 0) {
//        [imageView setImage:[UIImage imageNamed:name]];
//    } else {
//        [imageView setImage:[[UIImage alloc] init]];
//    }
//}

+ (void)makeCallWithNumber:(NSString *)number {
    //    NSString *phoneNumber = [[number componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    
    //    NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:phoneNumber]];
    NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:number]];
    
    //    if ([UIApplication.sharedApplication canOpenURL:phoneUrl]) {
    //        [UIApplication.sharedApplication openURL:phoneUrl];
    //    } else
    //    if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl]) {
    [UIApplication.sharedApplication openURL:phoneFallbackUrl];
    //    } else {
    //        [self showAlertTitle:self title:@"Error" message:@"You cannot call in this device."];
    //    }
}

+ (NSString *) getMonthString:(int) month {
    return [MONTH_WRDS objectAtIndex:(month - 1)];
}

+ (NSDate *) getDateFromString:(NSString *) dateString formatter:(NSString *) formatterStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    if (formatterStr.length == 0){
        formatterStr = @"yyyy-MM-dd HH:mm:ss";
    }
    [dateFormatter setDateFormat:formatterStr];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *) dateStringofEvent:(NSString *)dateString {
    NSArray *dataComps = [dateString componentsSeparatedByString:@" "];
    NSString *date = dataComps[0];
    dataComps = [date componentsSeparatedByString:@"-"];
    NSString *day = dataComps[2];
    NSString *year = dataComps[0];
    int month = [dataComps[1] intValue];
    NSString *monthStr = [MONTH_WRDS objectAtIndex:(month-1)];
    return [NSString stringWithFormat:@"%@\n%@\n%@", monthStr, day, year];
}

@end

