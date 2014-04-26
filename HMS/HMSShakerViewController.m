//
//  HMSShakerViewController.m
//  HMS
//
//  Created by flav on 28/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSShakerViewController.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "JPSThumbnail.h"
#import "JPSThumbnailAnnotation.h"
#import "HMSAppDelegate.h"

#import "HMSTabBarController.h"
#import "HMSHotel.h"

@interface HMSShakerViewController ()
{
    MDRadialProgressView *radialView;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    HMSAppDelegate *appDelegate;
    
}
@end

@implementation HMSShakerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //enleve la transparence car il faut deplacer le contenu avec le edge = none bar noire
    self.title = @"Shaker";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Shake" style:UIBarButtonItemStylePlain target:self action:@selector(enableShaker)];
;

    appDelegate = [[UIApplication sharedApplication] delegate];

    self.mapView.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    
    if (currentLocation != nil)
        [self.mapView setCenterCoordinate:currentLocation.coordinate animated:YES];
    [locationManager stopUpdatingLocation];

}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (motion == UIEventSubtypeMotionShake && !self.navigationItem.rightBarButtonItem.isEnabled)
    {

        if (radialView.progressCounter + 4 > 15)
        {
            radialView.progressCounter = 15;
            for (UIView *view in [self.view subviews])
            {
                if (view == radialView)
                    [UIView animateWithDuration:0.2
                                     animations:^{view.alpha = 0.0;}
                                     completion:^(BOOL finished){
                                         
                                         [view removeFromSuperview];
                                           self.navigationItem.rightBarButtonItem.enabled = YES;
                                         
                                         [self displayHotels];
                                         
                                     }];
            }
            
        }
        else
            radialView.progressCounter += 4;
        

        CGFloat t = 7.0;
        CGAffineTransform translateRight = CGAffineTransformTranslate(CGAffineTransformIdentity, t, -t);
        CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, t);
        
        self.view.transform = translateLeft;
        
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^
         {
             [UIView setAnimationRepeatCount:1.0];
             self.view.transform = translateRight;
         } completion:^(BOOL finished)
         
         {
             if (finished)
             {
                 [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
                  {
                      self.view.transform = CGAffineTransformIdentity;
                  }
                                  completion:NULL];
             }
            }];
        
         }
}


-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void) enableShaker
{
    int x = self.view.center.x - 40;
	int y = self.view.center.y / 6;
    
	CGRect frame = CGRectMake(x, y, 80, 80);
    
    radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
    
	radialView.progressTotal = 15;
    radialView.progressCounter = 0;
	radialView.clockwise = YES;
	radialView.theme.completedColor = [UIColor colorWithRed:90/255.0 green:200/255.0 blue:251/255.0 alpha:1.0];
	radialView.theme.incompletedColor = [UIColor colorWithRed:82/255.0 green:237/255.0 blue:199/255.0 alpha:1.0];
    radialView.theme.thickness = 30;
    radialView.theme.sliceDividerHidden = NO;
    radialView.theme.sliceDividerColor = [UIColor whiteColor];
    radialView.theme.sliceDividerThickness = 2;
	radialView.label.hidden = NO;
    
    
    [self.view addSubview:radialView];

    self.navigationItem.rightBarButtonItem.enabled = NO;
    
//    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    
    for (JPSThumbnailAnnotation *annotation in self.mapView.annotations)
    {
        MKAnnotationView * annotationView = [self mapView:self.mapView viewForAnnotation:annotation];

        [UIView animateWithDuration:0.2 animations:^(void){
            annotationView.alpha = 0.0;
        }
                         completion:^(BOOL finished){
                             [self.mapView removeAnnotation:annotation];
                         }];
    }
    
    
    
    
    

}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:aV] options: UIViewAnimationOptionCurveLinear animations:^{
            
            aV.frame = endFrame;
            
            // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            aV.transform = CGAffineTransformIdentity;
                        }];
                    }
                }];
            }
        }];
    }
}


- (NSArray *) locateHotels
{
    return appDelegate.sharedHotels;
}

- (void) displayHotels
{
    
    NSArray * hotelsLocated = [self locateHotels];
    NSString *path = @"";
    JPSThumbnail *thumbnail;
    
    for (HMSHotel * h in hotelsLocated)
    {
        if (h.photos.count > 0)
            path = [NSString stringWithFormat:@"%@.jpeg", h.photos[0]];
        else
            path = @"";
        
        thumbnail = [[JPSThumbnail alloc] init];
        thumbnail.image = [UIImage imageNamed:path];
        thumbnail.title = h.name;
        thumbnail.subtitle = h.description;
        
        thumbnail.coordinate = CLLocationCoordinate2DMake(h.latitude, h.longitude);
        
        thumbnail.disclosureBlock = ^(void){
            
            HMSTabBarController * tabcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
            
            tabcontroller.item = h;
            [self.navigationController pushViewController:tabcontroller animated:YES];
            
        };
        
        
        MKAnnotationView * annotationView = [self mapView:self.mapView viewForAnnotation:[JPSThumbnailAnnotation annotationWithThumbnail:thumbnail]];

        
        annotationView.alpha = 1.0;
        
        [self.mapView addAnnotation:[JPSThumbnailAnnotation annotationWithThumbnail:thumbnail]];
        
    }
    

    [self.mapView setCenterCoordinate:currentLocation.coordinate animated:YES];
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}



@end
