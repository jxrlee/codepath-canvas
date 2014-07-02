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
@property (strong, nonatomic) UIImageView *tempImageView;
@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) CGFloat rotate;

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
        
        //NSLog(@"gesture begin");
        lastVal = touchPosition.y;
        //NSLog(@"lastVal: %f",lastVal);
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        //NSLog(@"%f  -> %f", lastVal, touchPosition.y);
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
        
        
        [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:2 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            if(self.trayContainerView.center.y < half) {
                
                self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, revealedTrayCenter);
                self.trayContainerView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
                
            } else {
                
                self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, hiddenTrayCenter);
                self.trayContainerView.backgroundColor = [UIColor colorWithRed:3/255.0f green:169/255.0f blue:244/255.0f alpha:1.0f];
                
            }
            
        } completion:nil
            
        ];
    }
    
}

- (void)moveTrayUp:(float)diff {
    
    //NSLog(@"Move tray up");
    
    if(self.trayContainerView.center.y > revealedTrayCenter) {
        
        if(self.trayContainerView.center.y - diff < revealedTrayCenter) {
            self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, revealedTrayCenter);
        } else {
            self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, self.trayContainerView.center.y - diff);
        }
        
    }
    
}

- (void)moveTrayDown:(float)diff {
    
    //NSLog(@"Move tray down");
    
    if(self.trayContainerView.center.y < hiddenTrayCenter) {
        if(self.trayContainerView.center.y - diff < revealedTrayCenter) {
            self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, hiddenTrayCenter);
        } else {
            self.trayContainerView.center = CGPointMake(self.trayContainerView.center.x, self.trayContainerView.center.y - diff);
        }
    }
    
}

- (IBAction)onChrome:(UIPanGestureRecognizer *)sender {
    
    // get touch location
    CGPoint touchPosition = [sender locationInView:self.view];
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        
        // create copy of image
        float posY = self.trayContainerView.frame.origin.y + self.trayView.frame.origin.y + self.chromeImageView.frame.origin.y;
        CGRect frame = CGRectMake(self.chromeImageView.frame.origin.x, posY, 44, 44);
        self.tempImageView = [[UIImageView alloc] initWithFrame:frame];
        self.tempImageView.image = self.chromeImageView.image;
        self.tempImageView.userInteractionEnabled = YES;
        
        // add gestures
        UIPanGestureRecognizer *imagePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePan:)];
        UIPinchGestureRecognizer *imagePinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePinch:)];
        UIRotationGestureRecognizer *imageRotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onImageRotation:)];
        
        imagePinch.delegate = self;
        
        [self.tempImageView addGestureRecognizer:imagePan];
        [self.tempImageView addGestureRecognizer:imagePinch];
        [self.tempImageView addGestureRecognizer:imageRotate];
        [self.view addSubview:self.tempImageView];
        
        
    } else if(sender.state == UIGestureRecognizerStateChanged) {
        
        // move image to touch location
        self.tempImageView.center = CGPointMake(touchPosition.x, touchPosition.y);
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        // remove image if not above tray area
        if(touchPosition.y > self.view.frame.size.height - self.trayContainerView.frame.size.height) {
            [self.tempImageView removeFromSuperview];
        }
        
    }
    
}

- (IBAction)onGmail:(UIPanGestureRecognizer *)sender {
    
    // get touch location
    CGPoint touchPosition = [sender locationInView:self.view];
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        
        // create copy of image
        float posY = self.trayContainerView.frame.origin.y + self.trayView.frame.origin.y + self.gmailImageView.frame.origin.y;
        CGRect frame = CGRectMake(self.gmailImageView.frame.origin.x, posY, 44, 44);
        self.tempImageView = [[UIImageView alloc] initWithFrame:frame];
        self.tempImageView.image = self.gmailImageView.image;
        self.tempImageView.userInteractionEnabled = YES;
        
        // add gestures
        UIPanGestureRecognizer *imagePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePan:)];
        UIPinchGestureRecognizer *imagePinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePinch:)];
        UIRotationGestureRecognizer *imageRotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onImageRotation:)];
        
        imagePinch.delegate = self;
        
        [self.tempImageView addGestureRecognizer:imagePan];
        [self.tempImageView addGestureRecognizer:imagePinch];
        [self.tempImageView addGestureRecognizer:imageRotate];
        [self.view addSubview:self.tempImageView];
        
        
    } else if(sender.state == UIGestureRecognizerStateChanged) {
        
        // move image to touch location
        self.tempImageView.center = CGPointMake(touchPosition.x, touchPosition.y);
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        // remove image if not above tray area
        if(touchPosition.y > self.view.frame.size.height - self.trayContainerView.frame.size.height) {
            [self.tempImageView removeFromSuperview];
        }
        
    }
    
}

- (IBAction)onSpotify:(UIPanGestureRecognizer *)sender {
    
    // get touch location
    CGPoint touchPosition = [sender locationInView:self.view];
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        
        // create copy of image
        float posY = self.trayContainerView.frame.origin.y + self.trayView.frame.origin.y + self.spotifyImageView.frame.origin.y;
        CGRect frame = CGRectMake(self.spotifyImageView.frame.origin.x, posY, 44, 44);
        self.tempImageView = [[UIImageView alloc] initWithFrame:frame];
        self.tempImageView.image = self.spotifyImageView.image;
        self.tempImageView.userInteractionEnabled = YES;
        
        // add gestures
        UIPanGestureRecognizer *imagePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePan:)];
        UIPinchGestureRecognizer *imagePinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePinch:)];
        UIRotationGestureRecognizer *imageRotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onImageRotation:)];
        
        imagePinch.delegate = self;
        
        [self.tempImageView addGestureRecognizer:imagePan];
        [self.tempImageView addGestureRecognizer:imagePinch];
        [self.tempImageView addGestureRecognizer:imageRotate];
        [self.view addSubview:self.tempImageView];
        
        
    } else if(sender.state == UIGestureRecognizerStateChanged) {
        
        // move image to touch location
        self.tempImageView.center = CGPointMake(touchPosition.x, touchPosition.y);
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        // remove image if not above tray area
        if(touchPosition.y > self.view.frame.size.height - self.trayContainerView.frame.size.height) {
            [self.tempImageView removeFromSuperview];
        }
        
    }
    
}

- (IBAction)onTwitter:(UIPanGestureRecognizer *)sender {
    
    // get touch location
    CGPoint touchPosition = [sender locationInView:self.view];
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        
        // create copy of image
        float posY = self.trayContainerView.frame.origin.y + self.trayView.frame.origin.y + self.twitterImageView.frame.origin.y;
        CGRect frame = CGRectMake(self.twitterImageView.frame.origin.x, posY, 44, 44);
        self.tempImageView = [[UIImageView alloc] initWithFrame:frame];
        self.tempImageView.image = self.twitterImageView.image;
        self.tempImageView.userInteractionEnabled = YES;
        
        // add gestures
        UIPanGestureRecognizer *imagePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePan:)];
        UIPinchGestureRecognizer *imagePinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePinch:)];
        UIRotationGestureRecognizer *imageRotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onImageRotation:)];
        
        imagePinch.delegate = self;
        
        [self.tempImageView addGestureRecognizer:imagePan];
        [self.tempImageView addGestureRecognizer:imagePinch];
        [self.tempImageView addGestureRecognizer:imageRotate];
        [self.view addSubview:self.tempImageView];
        
        
    } else if(sender.state == UIGestureRecognizerStateChanged) {
        
        // move image to touch location
        self.tempImageView.center = CGPointMake(touchPosition.x, touchPosition.y);
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        // remove image if not above tray area
        if(touchPosition.y > self.view.frame.size.height - self.trayContainerView.frame.size.height) {
            [self.tempImageView removeFromSuperview];
        }
        
    }
    
}


- (void)onImagePan:(UIPanGestureRecognizer *)sender {
    NSLog(@"panning");
    
    CGPoint translation = [sender translationInView:self.view];
    
    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
}

- (void)onImagePinch:(UIPinchGestureRecognizer *)sender {
    NSLog(@"pinching");
    
    // new scale
    CGFloat scale = sender.scale;
    self.scale = scale;
    
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(self.rotate);
    sender.view.transform = CGAffineTransformScale(rotateTransform, scale, scale);
}

- (void)onImageRotation:(UIRotationGestureRecognizer *)sender {
    NSLog(@"rotating");
    
    // new rotation
    CGFloat rotation = sender.rotation;
    self.rotate = rotation;
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(self.scale, self.scale);
    sender.view.transform = CGAffineTransformRotate(scaleTransform, rotation);
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
