//
//  CanvasViewController.m
//  canvas
//
//  Created by Joseph Lee on 6/29/14.
//  Copyright (c) 2014 mn8. All rights reserved.
//

#import "CanvasViewController.h"

@interface CanvasViewController ()

@property (weak, nonatomic) IBOutlet UIView *trayContainerView;

@end

@implementation CanvasViewController

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


    // move tray down
    float trayPosY = self.trayContainerView.frame.origin.y;
    
    NSLog(@"%f", trayPosY);
    
    self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, trayPosY + 92);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
