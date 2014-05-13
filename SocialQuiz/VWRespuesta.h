//
//  VWRespuesta.h
//  SocialQuiz
//
//  Created by Jair Serrano on 07/04/14.
//  Copyright (c) 2014 Jair Serrano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VWRespuesta : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *idJug;

@property (nonatomic) long idpartida;
@property (nonatomic) long idturno;
@property (nonatomic) long fecha;
@property (nonatomic) NSInteger puntos;
@property (nonatomic) NSInteger nturno;
@property (strong, nonatomic) NSString * resp;
@property (strong, nonatomic) NSString * pistas;
@property (strong, nonatomic) UIImage * imgvar1;
@property (strong, nonatomic) UIImage * imgvar2;
@property (strong, nonatomic) NSString *urlserv;


@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UILabel *lblletras;
@property (strong, nonatomic) IBOutlet UITextView *txtpistas;
@property (strong, nonatomic) IBOutlet UITextField *txtrespuesta;


@end
