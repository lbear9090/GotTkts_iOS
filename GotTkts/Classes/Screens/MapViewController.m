//
//  MapViewController.m
//  GotTkts
//
//  Created by Jorge on 10/21/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import "Event.h"

@interface MapViewController ()
{
    IBOutlet GMSMapView *mapView;
    NSMutableArray *markers;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = YES;
//    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error){
//        if (!error){
//            [mapView animateToCameraPosition:[GMSCameraPosition
//                                              cameraWithLatitude:geoPoint.latitude
//                                              longitude:geoPoint.longitude
//                                              zoom:10]];
//
//        }
//    }];
    markers = [[NSMutableArray alloc] init];
    [self drawMarkers];
}
- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) drawMarkers {
    for (Event *event in self.dataArray){
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(event.event_latitude, event.event_longitude);
        marker.title = event.event_name;
        marker.map = mapView;
        marker.icon = [self image:[UIImage imageNamed:@"app_logo.png"] scaledToSize:CGSizeMake(25, 25)];
        [markers addObject:marker];
    }
    [self fitBounds];
}

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size)) {
        return originalImage;
    }
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //return image
    return image;
}

- (void)fitBounds {
    if ([self.dataArray count] == 0)
        return;
    CLLocationCoordinate2D firstPos = ((GMSMarker *)markers.firstObject).position;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:firstPos coordinate:firstPos];
    for (GMSMarker *marker in markers) {
        bounds = [bounds includingCoordinate:marker.position];
    }
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
    [mapView moveCamera:update];
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
