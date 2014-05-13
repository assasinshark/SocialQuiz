//
//  VWListaJuego.h
//  SocialQuiz
//
//  Created by Jair Serrano on 07/04/14.
//  Copyright (c) 2014 Jair Serrano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CeldaJugador.h"
#import "VWAgreAmigo.h"
#import "VWPregunta.h"
#import "VWRespuesta.h"
#import "VWPregunta.h"

@interface VWListaJuego : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tbljuegos;
@property (strong, nonatomic) NSMutableArray *idspartidas;
@property (strong, nonatomic) NSMutableArray *nombrescont;
@property (strong, nonatomic) NSMutableArray *segues;
@property (strong, nonatomic) NSString *idJug;
@property (strong, nonatomic) NSString *urlserv;

@end
