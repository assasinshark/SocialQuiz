//
//  VWPregunta.h
//  SocialQuiz
//
//  Created by Jair Serrano on 07/04/14.
//  Copyright (c) 2014 Jair Serrano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface VWPregunta : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic) long idPartida;
@property (nonatomic) long idTurno;
@property (nonatomic) NSInteger nturno;
@property (strong, nonatomic) NSString *idJug;
@property (strong, nonatomic) NSString *idJugCont;
@property (strong, nonatomic) NSString *urlserv;

@property (strong, nonatomic) NSString *pistaPas;
@property (strong, nonatomic) NSString *respPas;

@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UITextView *textPista;
@property (strong, nonatomic) IBOutlet UITextField *textRespuesta;

@property BOOL newMedia;
@property BOOL img_1;
@property BOOL img_2;

- (IBAction)clic_btn_galeria:(id)sender;
- (IBAction)clic_btn_foto:(id)sender;
- (IBAction)btn_clic_enviar:(id)sender;
@end
