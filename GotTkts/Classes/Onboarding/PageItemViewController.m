//
//  PageItemViewController.m
//  Eye On
//
//  Created by developer on 03/04/17.
//  Copyright © 2017 Vitaly. All rights reserved.
//

#import "PageItemViewController.h"

@interface PageItemViewController ()
{
    IBOutlet UITextView *txtDesc;
    IBOutlet UIImageView *image;
}
@end

@implementation PageItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    txtDesc.text = _desctiptionText;
    image.image = [UIImage imageNamed:_imageFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
