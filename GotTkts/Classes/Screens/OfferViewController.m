//
//  OfferViewController.m
//  GotTkts
//
//  Created by Jorge on 7/25/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "OfferViewController.h"

@interface OfferViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray *dataArray;
    IBOutlet UICollectionView *collectionview;
    IBOutlet UILabel *lblNodata;
    IBOutlet UIButton *btnOffer;
    IBOutlet UIPlaceHolderTextView *txtDescription;
    NSInteger currentCategory;
}
@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Util setBorderView:lblNodata color:[UIColor whiteColor] width:1.0f];
    [Util setCornerView:lblNodata];
    
    [Util setBorderView:txtDescription color:[UIColor whiteColor] width:1.0f];
    [Util setCornerView:txtDescription];
    
    txtDescription.placeholder = @"Please enter description.";
    
    dataArray = [[NSMutableArray alloc] init];
    currentCategory = -1;
    [self refreshItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshItems {
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline."];
        return;
    }
    

}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellItem" forIndexPath:indexPath];
    
    UIImageView *imgPhoto = [cell viewWithTag:1];
    UILabel *lblTitle = [cell viewWithTag:2];
    
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    currentCategory = indexPath.row;
    
    // clear bounds
    for (NSInteger i=0;i<dataArray.count;i++){
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        UIImageView *imgPhoto = (UIImageView *)[cell viewWithTag:1];
        [Util setBorderView:imgPhoto color:[UIColor clearColor] width:3];
    }
    // draw bound
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imgPhoto = (UIImageView *)[cell viewWithTag:1];
    [Util setBorderView:imgPhoto color:[UIColor yellowColor] width:3];
}

- (IBAction)onSubmit:(id)sender {
    if (![self isValid]){
        return;
    }
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline."];
        return;
    }
    
}

- (BOOL) isValid {
    txtDescription.text = [Util trim:txtDescription.text];
    if (currentCategory == -1){
        [Util showAlertTitle:self title:@"Error" message:@"Please choose your item for trade."];
        return NO;
    }
    if (txtDescription.text.length == 0){
        [Util showAlertTitle:self title:@"Error" message:@"Please enter your description." finish:^(void){
            [txtDescription becomeFirstResponder];
        }];
        return NO;
    }
    return YES;
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
