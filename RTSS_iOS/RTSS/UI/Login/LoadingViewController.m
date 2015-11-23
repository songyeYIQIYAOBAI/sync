//
//  LoadingViewController.m
//  RTSS
//
//  Created by shengyp on 14/11/15.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "LoadingViewController.h"
#import "AppDelegate.h"
#import "PortraitImageView.h"
#import "WaitingView.h"

#import "ImageUtils.h"
#import "Settings.h"

#import "MappActor.h"
#import "MappClient.h"

#import "User.h"
#import "Session.h"
#import "Cache.h"
#import "MManager.h"

#define LoadingMaxHandShake         5

@interface LoadingImageView () <UIDynamicAnimatorDelegate>

@property(nonatomic, retain) UIDynamicAnimator*         dynamicAnimator;

@end

@implementation LoadingImageView
@synthesize imageView, promptView,versionLabel, dynamicAnimator, delegate;

- (void)dealloc
{
    [imageView release];
    [promptView release];
    
    [dynamicAnimator release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView
{
    // ===
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [ImageUtils imageNamed:@"loading_bg" ofType:@"png"];
    imageView.center = CGPointMake(self.bounds.size.width/2, 0);
    [self addSubview:imageView];
    
    // ===
    CGRect promptRect = CGRectMake(0, self.bounds.size.height-90, self.bounds.size.width, self.bounds.size.height);
    promptView = [[UIView alloc] initWithFrame:promptRect];
    promptView.backgroundColor = [UIColor clearColor];
    promptView.alpha = 0.0;
    [self addSubview:promptView];
    
    UILabel* welcomeLabel = [CommonUtils labelWithFrame:CGRectMake(0, 0, CGRectGetWidth(promptRect), 30)
                                                   text:NSLocalizedString(@"LoadingView_Welcome_Major_Text", nil)
                                              textColor:[UIColor whiteColor]
                                               textFont:[RTSSAppStyle getRTSSFontWithSize:18.0]
                                                    tag:10];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    [promptView addSubview:welcomeLabel];
    
    UILabel* copyRightLabel = [CommonUtils labelWithFrame:CGRectMake(0,CGRectGetMaxY(welcomeLabel.frame),CGRectGetWidth(promptRect),30)
                                                     text:NSLocalizedString(@"LoadingView_Welcome_Sub_Text", nil)
                                                textColor:[UIColor whiteColor]
                                                 textFont:[RTSSAppStyle getRTSSFontWithSize:13.0]
                                                      tag:11];
    [promptView addSubview:copyRightLabel];
    
    NSString* versionValue = [NSString stringWithFormat:NSLocalizedString(@"AboutView_App_Version_Text", nil),APPLICATION_VERSION_TEXT];
    NSString* versionText = [NSString stringWithFormat:@"%@%@", versionValue, @""];
    versionLabel = [CommonUtils labelWithFrame:CGRectMake(0, CGRectGetMaxY(copyRightLabel.frame), CGRectGetWidth(promptRect), 30)
                                          text:versionText
                                     textColor:[UIColor whiteColor]
                                      textFont:[RTSSAppStyle getRTSSFontWithSize:11.0]
                                           tag:12];
    versionLabel.hidden = YES;
    [promptView addSubview:versionLabel];
    
    // ==
    self.dynamicAnimator = [[[UIDynamicAnimator alloc] initWithReferenceView:self] autorelease];
    self.dynamicAnimator.delegate = self;
}

- (void)startBounceAnimation
{
    [self stopBounceAnimation];
    
    NSArray* items = [NSArray arrayWithObjects:imageView, nil];
    // 重力
    UIGravityBehavior* gravityBehavior = [[UIGravityBehavior alloc] initWithItems:items];
    gravityBehavior.magnitude = 1.5;
    [self.dynamicAnimator addBehavior:gravityBehavior];
    [gravityBehavior release];
    
    // 碰撞
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:items];
    [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-(self.bounds.size.height*3/2+20), -20, 0, -20)];
    [self.dynamicAnimator addBehavior:collisionBehavior];
    [collisionBehavior release];
    
    // 阻尼/摩擦/弹性
    UIDynamicItemBehavior* itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:items];
    itemBehavior.elasticity = 0.6;
    itemBehavior.resistance = 0.3;
    itemBehavior.friction = 0.5;
    [self.dynamicAnimator addBehavior:itemBehavior];
    [itemBehavior release];
}

- (void)stopBounceAnimation
{
    [self.dynamicAnimator removeAllBehaviors];
}

- (void)dissolveAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        promptView.alpha = 1.0;
        imageView.alpha = 0.8;
    } completion:^(BOOL finished) {
        if(nil != delegate && [delegate respondsToSelector:@selector(dissolveAnimationCompletion)]){
            [delegate dissolveAnimationCompletion];
        }
    }];
}

#pragma mark UIDynamicAnimatorDelegate
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator
{
    if(NO == animator.running){
        [animator removeAllBehaviors];
        
        if(nil != delegate && [delegate respondsToSelector:@selector(bounceAnimationCompletion)]){
            [delegate bounceAnimationCompletion];
        }
    }
}

@end

@interface LoadingBallView()

@property(nonatomic, retain) UIDynamicAnimator*         dynamicAnimator;
@property(nonatomic, retain) UIGravityBehavior*         gravityBehavior;
@property(nonatomic, retain) UICollisionBehavior*       collisionBehavior;
@property(nonatomic, retain) UIAttachmentBehavior*      suspendBehavior;
@property(nonatomic, retain) UIAttachmentBehavior*      touchBehavior;
@property(nonatomic, retain) UIDynamicItemBehavior*     itemBehavior;

@property(nonatomic, retain) UIImageView*               logoView;

@property(nonatomic, assign) CGPoint                    portraitPoint;

@end

@implementation LoadingBallView
@synthesize dynamicAnimator, gravityBehavior, collisionBehavior, suspendBehavior, touchBehavior, itemBehavior;
@synthesize logoView, logoButton, portraitView, portraitPoint, delegate;

- (void)dealloc
{
    [dynamicAnimator release];
    [gravityBehavior release];
    [collisionBehavior release];
    [suspendBehavior release];
    [touchBehavior release];
    [itemBehavior release];
    
    [logoView release];
    [logoButton release];
    [portraitView release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView
{
    self.dynamicAnimator = [[[UIDynamicAnimator alloc] initWithReferenceView:self] autorelease];
    
    // ==
    CGRect logoRect = CGRectMake((self.bounds.size.width-80)/2, 67, 80, 80);
    CGRect portraitRect = CGRectMake(self.bounds.size.width-22-75, self.bounds.size.height-200, 75, 75);
    if(PHONE_UISCREEN_IPHONE6){
        logoRect.origin.y += 30;
        portraitRect.origin.y -= 30;
    }
    self.logoView = [[[UIImageView alloc] initWithFrame:logoRect] autorelease];
    self.logoView.image = [UIImage imageNamed:@"common_rtss_launch_logo.png"];
    self.logoView.alpha = 0.0;
    self.logoView.userInteractionEnabled = YES;
    [self addSubview:self.logoView];
    
    self.logoButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, logoRect.size.width, logoRect.size.height)] autorelease];
    self.logoButton.backgroundColor = [UIColor clearColor];
    [self.logoView addSubview:self.logoButton];
    
    // ==
    self.portraitView = [[[PortraitImageView alloc] initWithFrame:portraitRect image:nil borderColor:[RTSSAppStyle currentAppStyle].portraitBorderColor borderWidth:1.0] autorelease];
    self.portraitView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    self.portraitView.userInteractionEnabled = YES;
    self.portraitView.portraitImage = [[Cache standardCache] getLargePortraitImageWithUrl:[Session sharedSession].mMyUser.mPortrait completion:^(UIImage *image) {
        self.portraitView.portraitImage = image;
    }];
    self.portraitView.alpha = 0.0;
    [self.portraitView.actionButton addTarget:self action:@selector(portraitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.portraitView];
    self.portraitPoint = self.portraitView.center;
    
    // ==
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedGesture:)];
    [self.portraitView addGestureRecognizer:panGesture];
    [panGesture release];
    
    // ==
    CGPoint anchor = CGPointMake(self.portraitView.center.x-5, self.portraitView.center.y - 15);
    self.suspendBehavior = [[[UIAttachmentBehavior alloc] initWithItem:self.portraitView attachedToAnchor:anchor] autorelease];
    self.suspendBehavior.length = 10;
    self.suspendBehavior.damping = 1;
    self.suspendBehavior.frequency = 1.2;
    
    // ==
    self.itemBehavior = [[[UIDynamicItemBehavior alloc] initWithItems:@[self.portraitView]] autorelease];
    self.itemBehavior.elasticity = 0.3;
    self.itemBehavior.friction = 1.0;
    self.itemBehavior.resistance = 5;
    self.itemBehavior.density = 5;
    self.itemBehavior.allowsRotation = NO;
    
    // ==
    self.gravityBehavior = [[[UIGravityBehavior alloc] initWithItems:@[self.portraitView]] autorelease];
    self.gravityBehavior.gravityDirection = CGVectorMake(0, 1);
    
    // ==
    self.collisionBehavior = [[[UICollisionBehavior alloc] initWithItems:@[self.portraitView]] autorelease];
    [self.collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-100, -100, -100, -100)];
}

- (void)initAnimation
{
    [self.dynamicAnimator addBehavior:self.suspendBehavior];
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
}

- (void)ballDissolveAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        self.logoView.alpha = 1.0;
        self.portraitView.alpha = 1.0;
    } completion:^(BOOL finished) {
        if(nil != delegate && [delegate respondsToSelector:@selector(ballDissolveAnimationCompletion)]){
            [delegate ballDissolveAnimationCompletion];
        }
    }];
}

- (void)jumpToLogoAnimation{
    [UIView animateWithDuration:0.8 animations:^{
        self.portraitView.center = self.logoView.center;
    } completion:^(BOOL finished) {
        self.portraitView.userInteractionEnabled = NO;
        if(nil != delegate && [delegate respondsToSelector:@selector(jumpToLogoAnimationCompletion)]){
            [delegate jumpToLogoAnimationCompletion];
        }
    }];
}

- (void)ballResetAnimation{
    [UIView animateWithDuration:0.8 animations:^{
        self.portraitView.center = self.portraitPoint;
    } completion:^(BOOL finished) {
        self.portraitView.userInteractionEnabled = YES;
        [self initAnimation];
    }];
}

- (void)portraitAction:(UIButton*)button
{
    [self.dynamicAnimator removeAllBehaviors];
    [self jumpToLogoAnimation];
}

- (void)pannedGesture:(UIPanGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            
            [self.dynamicAnimator removeBehavior:self.itemBehavior];
            [self.dynamicAnimator removeBehavior:self.suspendBehavior];
            
            self.touchBehavior = nil;
            self.touchBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.portraitView attachedToAnchor:self.portraitView.center];
            self.touchBehavior.damping = 0.3;
            self.touchBehavior.frequency = 1.0;
            [self.dynamicAnimator addBehavior:self.touchBehavior];
            
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if(nil != self.touchBehavior){
                self.touchBehavior.anchorPoint = location;
            }
            break;
        }
        case UIGestureRecognizerStateEnded :
        case UIGestureRecognizerStateCancelled:{
            if(nil != self.touchBehavior){
                [self.dynamicAnimator removeBehavior:self.touchBehavior];
            }
            
            if(CGRectContainsPoint(self.logoView.frame, location)){
                [self portraitAction:self.portraitView.actionButton];
            }else{
                [self performSelector:@selector(startItemBehavior) withObject:nil afterDelay:0.4];
                [self performSelector:@selector(startSuspendBehavior) withObject:nil afterDelay:0.8];
            }
    
            break;
        }
            
        default:
            break;
    }
}

- (void)startItemBehavior{
    [self.itemBehavior addLinearVelocity:self.portraitPoint forItem:self.portraitView];
    [self.dynamicAnimator addBehavior:self.itemBehavior];
}

- (void)startSuspendBehavior{
    [self.dynamicAnimator addBehavior:self.suspendBehavior];
}

@end


@interface LoadingViewController ()<LoadingImageViewDelegate,MappActorDelegate>

@property(nonatomic, retain)User*                loadingUser;
@property(nonatomic, assign)NSUInteger           handshakeFailCount;

@property(nonatomic, retain)LoadingImageView*    loadingImageView;
@property(nonatomic, retain)LoadingBallView*     loadingBallView;
@property(nonatomic, retain)WaitingView*         waitingView;

@end

@implementation LoadingViewController
@synthesize loadingUser, handshakeFailCount, loadingImageView, loadingBallView, waitingView;

- (void)dealloc{
    [loadingUser release];
    [loadingImageView release];
    [loadingBallView release];
    [waitingView release];

    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.handshakeFailCount = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutLoadingView{
    [[Session sharedSession] load];
    
    self.waitingView = [[[WaitingView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT)] autorelease];
    self.waitingView.backgroundColor = [UIColor clearColor];
    self.waitingView.alpha = 1.0;
    
    self.loadingImageView = [[[LoadingImageView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT)] autorelease];
    self.loadingImageView.backgroundColor = [UIColor clearColor];
    self.loadingImageView.delegate = self;
    [self.view addSubview:self.loadingImageView];
    
    self.loadingBallView = [[[LoadingBallView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT)] autorelease];
    self.loadingBallView.backgroundColor = [UIColor clearColor];
    self.loadingBallView.delegate = self;
    [self.view addSubview:self.loadingBallView];
    
    [self.loadingBallView.logoButton addTarget:self action:@selector(logoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadView{
    [super loadView];
    
    [self layoutLoadingView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loadingImageView startBounceAnimation];
    
    AlertController * al = [[AlertController alloc] initWithTitle:@"title" message:@"message" delegate:nil tag:0 cancelButtonTitle:@"quxiao" otherButtonTitles:@"确定",@"halou",nil];
    [al showInViewController:self];
    [al release];

}

- (void)startWaitingIndicator{
    if(nil == [self.waitingView superview]){
        [self.view addSubview:self.waitingView];
        [self.waitingView startWaiting];
    }
}

- (void)stopWaitingIndicator{
    if(nil != [self.waitingView superview]){
        [self.waitingView stopWaiting];
        [self.waitingView removeFromSuperview];
    }
}

- (void)loadingData{

#ifdef APPLICATION_BUILDING_RELEASE
//    [self startWaitingIndicator];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        [[MappClient sharedMappClient] prepare:__MAPP_SERVER_ADDRESS__ callback:^(int status) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if(MappActorFinishStatusOK == status){
//                    [self stopWaitingIndicator];
//                    [self.loadingBallView ballDissolveAnimation];
////                    [[AppDelegate shareAppDelegate] appVersionUpdate:NO alert:YES];
//                }else{
//                    self.handshakeFailCount += 1;
//                    
//                    if(self.handshakeFailCount >= LoadingMaxHandShake){
//                        self.handshakeFailCount = 0;
//                        [self stopWaitingIndicator];
//                        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Common_Network_Server_Busy", nil)];
//                    }else {
//                        [self loadingData];
//                    }
//                }
//            });
//
//        }];
//    });
    [self startWaitingIndicator];
    
    MManager *mManager = [MManager sharedMManager];
    NSDictionary *config = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"124.207.3.44",__MAPP_SERVICE_IPADDRESS__,
                            [NSNumber numberWithInt:443],__MAPP_SERVICE_PORT__,
                            @"/MappBase2.5/servlet/Service",__MAPP_SERVICE_BASEURL__,
                            @"__push_service_ipaddress",__PUSH_SERVICE_IPADDRESS__,
                            [NSNumber numberWithInt:80],__PUSH_SERVICE_PORT__,
                            @"__mdk_auth_appid",__MDK_AUTH_APPID__,
                            nil];
    int status = [mManager init:config];
    if(MappActorFinishStatusOK == status){
        [self stopWaitingIndicator];
        [self.loadingBallView ballDissolveAnimation];
        //                    [[AppDelegate shareAppDelegate] appVersionUpdate:NO alert:YES];
    }else{
        self.handshakeFailCount += 1;
        
        if(self.handshakeFailCount >= LoadingMaxHandShake){
            self.handshakeFailCount = 0;
            [self stopWaitingIndicator];
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Common_Network_Server_Busy", nil)];
        }else {
            [self loadingData];
        }
    }
#else
    [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeLogin];
#endif
    
}


- (void)logoButtonAction:(UIButton*)button
{
    self.loadingImageView.versionLabel.hidden = NO;
}

#pragma mark LoadingImageViewDelegate
- (void)bounceAnimationCompletion{
    [self.loadingImageView dissolveAnimation];
}

- (void)dissolveAnimationCompletion{
    [self loadingData];
}

- (void)ballDissolveAnimationCompletion{
    [self.loadingBallView initAnimation];
}

- (void)jumpToLogoAnimationCompletion{
    if([[Settings standardSettings] getAutoLoginSwith]){
        [[Session sharedSession].mMyUser login:self];
    }else{
        [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeLogin];
    }
}

#pragma mark MappActorDelegate
- (void)loginFinished:(NSInteger)status customer:(NSObject*)customer{
    if(MappActorFinishStatusOK == status){
        [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeHome];
    }else{
        [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeLogin];
    }
}

-(void)resetBallAnimation{
    
    [self.loadingBallView ballResetAnimation];
}

@end