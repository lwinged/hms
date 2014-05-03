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
#import "HMSMathHelper.h"

@interface HMSShakerViewController ()
{
    MDRadialProgressView *radialView;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    HMSAppDelegate *appDelegate;
    NSArray * _hotelsLocated;
}
@end

static double RAYON_KM = 10000;
static CLLocationDistance DISTANCE_M_UPDATE = 10;

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
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Shake" style:UIBarButtonItemStylePlain target:self action:@selector(enableShaker)];
;
    
    
    // Initialize the UIButton
    UIImage *btn = [UIImage imageNamed:@"shaker32.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:btn forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, btn.size.width, btn.size.height);
    
    // Initialize the UIBarButtonItem
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    
    // Set the Target and Action for aButton
    [aButton addTarget:self action:@selector(enableShaker) forControlEvents:UIControlEventTouchUpInside];
    
    // Then you can add the aBarButtonItem to the UINavigationBar
    self.navigationItem.rightBarButtonItem = aBarButtonItem;
    
    // Release buttonImage
   //[btn release];
    

    appDelegate = [[UIApplication sharedApplication] delegate];

    self.mapView.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = DISTANCE_M_UPDATE;
    
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
    
    if (currentLocation != nil)
        [self.mapView setCenterCoordinate:currentLocation.coordinate animated:YES];
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (motion == UIEventSubtypeMotionShake && !self.navigationItem.rightBarButtonItem.isEnabled)
    {

        
        if (radialView.progressCounter + 4 > 15)
        {
            radialView.progressCounter = 15;
            if (_hotelsLocated)
            {
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
                --radialView.progressCounter;
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
    _hotelsLocated = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _hotelsLocated = [self locateHotels];
    
    });
    
    
    int x = self.view.center.x - 40;
    int y = self.view.center.y / 6;
    
    CGRect frame = CGRectMake(x, y, 80, 80);
    
    radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
    
    radialView.progressTotal = 15;
    radialView.progressCounter = 0;
    radialView.clockwise = YES;
    radialView.theme.completedColor = [UIColor colorWithRed:109/255.0 green:7/255.0 blue:26/255.0 alpha:1.0];
    radialView.theme.incompletedColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    radialView.theme.thickness = 30;
    radialView.theme.sliceDividerHidden = NO;
    radialView.theme.sliceDividerColor = [UIColor whiteColor];
    radialView.theme.sliceDividerThickness = 2;
    radialView.label.hidden = NO;
    
    
    [self.view addSubview:radialView];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
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
    NSMutableArray *locatedHotels = [[NSMutableArray alloc] init];
    NSArray *hotel_array = appDelegate.sharedHotels;
    
//    NSLog(@"user location ----> %@", currentLocation);

    for (HMSHotel * h in hotel_array)
    {
        if ([HMSMathHelper distanceFromAToB:currentLocation.coordinate.latitude :currentLocation.coordinate.longitude :h.latitude :h.longitude] <= RAYON_KM)
        {
            [locatedHotels addObject:h];
        }
    }
    
    return locatedHotels;
}

- (void) displayHotels
{
    
    NSArray * hotelsLocated = _hotelsLocated;
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
