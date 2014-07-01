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


float revealedTrayCenter;
float hiddenTrayCenter;
float lastVal;


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
    
    // get revealed center
    revealedTrayCenter = self.trayContainerView.center.y;

    // hide tray
    float trayPosY = self.trayContainerView.frame.origin.y;
    self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, trayPosY + 105);
    
    // get hidden center
    hiddenTrayCenter = self.trayContainerView.center.y;
    //NSLog(@"center y: %f", self.trayContainerView.center.y);
    // 523 - 583
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTrayContainerDrag:(UIPanGestureRecognizer *)sender {
    
    // get touch location
    CGPoint touchPosition = [sender locationInView:self.view];
    
    //NSLog(@"%f",touchPosition.y);
    
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"gesture begin");
        lastVal = touchPosition.y;
        NSLog(@"lastVal: %f",lastVal);
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        NSLog(@"%f  -> %f", lastVal, touchPosition.y);
        float diff = lastVal - touchPosition.y;
        
        // move tray up
        if(touchPosition.y < lastVal) {
            
            [self moveTrayUp:diff];
            
        } else if (touchPosition.y > lastVal) {
            
            [self moveTrayDown:diff];
            
        } else {
            
        }
        
        lastVal = touchPosition.y;
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"gesture end");
        
        // snap to revealed or hidden
        float half = (revealedTrayCenter + hiddenTrayCenter)/2;
        if(self.trayContainerView.center.y < half) {
            
            [UIView animateWithDuration:.2 animations:^{
                self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, revealedTrayCenter);
            }];
            
        } else {
            
            [UIView animateWithDuration:.2 animations:^{
                self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, hiddenTrayCenter);
            }];
            
        }
    }
    
}

- (void)moveTrayUp:(float)diff {
    
    NSLog(@"Move tray up");
    
    if(self.trayContainerView.center.y > revealedTrayCenter) {
        
        if(self.trayContainerView.center.y - diff < revealedTrayCenter) {
            self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, revealedTrayCenter);
        } else {
            self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, self.trayContainerView.center.y - diff);
        }
        
    }
    
}

- (void)moveTrayDown:(float)diff {
    
    NSLog(@"Move tray down");
    
    if(self.trayContainerView.center.y < hiddenTrayCenter) {
        if(self.trayContainerView.center.y - diff < revealedTrayCenter) {
            self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, hiddenTrayCenter);
        } else {
            self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, self.trayContainerView.center.y - diff);
        }
    }
    
}

@end
