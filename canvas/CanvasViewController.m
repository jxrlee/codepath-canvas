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
@property (weak, nonatomic) IBOutlet UIView *trayView;
@property (weak, nonatomic) IBOutlet UIImageView *chromeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gmailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *spotifyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImageView;
@property (nonatomic) UIImageView *tempImageView;

- (IBAction)onChrome:(UIPanGestureRecognizer *)sender;
- (IBAction)onGmail:(UIPanGestureRecognizer *)sender;
- (IBAction)onSpotify:(UIPanGestureRecognizer *)sender;
- (IBAction)onTwitter:(UIPanGestureRecognizer *)sender;

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

- (IBAction)onChrome:(UIPanGestureRecognizer *)sender {
}

- (IBAction)onGmail:(UIPanGestureRecognizer *)sender {
}

- (IBAction)onSpotify:(UIPanGestureRecognizer *)sender {
}

- (IBAction)onTwitter:(UIPanGestureRecognizer *)sender {
    
    // get touch location
    CGPoint touchPosition = [sender locationInView:self.view];
    
    //NSLog(@"%f",touchPosition.y);
    
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        
        //NSLog(@"twitter begin");
        //lastVal = touchPosition.y;
        //NSLog(@"lastVal: %f",lastVal);
        
        // create copy of image
        float posY = self.trayContainerView.frame.origin.y + self.trayView.frame.origin.y + self.twitterImageView.frame.origin.y;
        CGRect frame = CGRectMake(self.twitterImageView.frame.origin.x, posY, 44, 44);
        self.tempImageView = [[UIImageView alloc] initWithFrame:frame];
        self.tempImageView.image = self.twitterImageView.image;
        self.tempImageView.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *imagePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePan:)];
        
        [self.tempImageView addGestureRecognizer:imagePan];
        [self.view addSubview:self.tempImageView];
        
        
    } else if(sender.state == UIGestureRecognizerStateChanged) {
        
        // move image to touch location
        self.tempImageView.center = CGPointMake(touchPosition.x, touchPosition.y);
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        // remove image if not above tray area
        
    }
    
}


- (void)onImagePan:(UIPanGestureRecognizer *)pan {
    NSLog(@"panning");
    
    CGPoint translation = [pan translationInView:self.view];
    
    if(pan.state == UIGestureRecognizerStateChanged) {
        //NSLog(@"Location (%f,%f) Translation (%f, %f)", location.x, location.y, translation.x, translation.y);
        
        pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
        [pan setTranslation:CGPointMake(0, 0) inView:self.view];
        
    } if (pan.state == UIGestureRecognizerStateEnded) {
        //UIImageView *view;
        
    }
}

@end
