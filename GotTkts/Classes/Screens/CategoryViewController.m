//
//  CategoryViewController.m
//  GotTkts
//
//  Created by Jorge on 7/4/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "CategoryViewController.h"
#import "MainViewController.h"

@interface CategoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    IBOutlet UIView *viewContent;
    IBOutlet UICollectionView *collectionview;
    
}
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMenu:(id)sender {
    [[MainViewController getInstance] toggleMenu];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellCategory" forIndexPath:indexPath];
    UIImageView *imgCategory = (UIImageView *)[cell viewWithTag:1];
    UILabel *lblCategory = (UILabel *)[cell viewWithTag:2];
    lblCategory.text = [CATEGORY_ARRAY objectAtIndex:indexPath.row];
    imgCategory.image = [UIImage imageNamed:[CATEGORY_ICON_ARRAY objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSInteger ) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return CATEGORY_ARRAY.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = viewContent.frame.size.width / 4.0;
    CGFloat height = width * 4 / 3;
    return CGSizeMake(width, height);
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
