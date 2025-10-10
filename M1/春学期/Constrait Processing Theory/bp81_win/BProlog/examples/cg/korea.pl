/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw the Korean flag, by Liya
*********************************************************************/

go:-
    korea.
go.

korea:-
    korea(Os),
    cgWindow(Win,"korea"),
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgPack(Os),
    cgResize(Os,300,200),
    cgMove(Os,30,30),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

korea(Os):-
  Ss=[S0,S1,S2,S3], % positions for the diagonal rectangles
  cgRectangle(Ss),
  S0^width #=100,
  S0^height #=100,
  cgGrid([[S0,_,S1],[_,_,_],[S2,_,S3]]),

  cgRectangle(Frame),Frame^fill#=0, Frame^width #= S0^width*3, Frame^width #= Frame^height,
  cgSame([Frame,S0],location),

  Polys= [B0,B1,B2,B3],
  createBigPoly([S0,S1,S2,S3],Polys),
  
  Ps0 = [Pa,Pa1,Pa2],
  Ps1 = [Pb,Pb1,Pb2],
  Ps2 = [Pc,Pc1,Pc2],
  Ps3 = [Pd,Pd1,Pd2],

  createMulPs(Ps0,B0,2,3,1,4),
  createMulPs(Ps1,B1,1,2,4,3),
  createMulPs(Ps2,B2,2,1,3,4),
  createMulPs(Ps3,B3,3,2,4,1),
  
  getPbyP0(SP2,Pc1,9,11,20,2,1,3,4,white),
  getPbyP0(SP1a,Pb,9,11,20,1,2,4,3,white),
  getPbyP0(SP1b,Pb2,9,11,20,1,2,4,3,white),
  getPbyP0(SP3a,Pd,9,11,20,2,1,3,4,white),
  getPbyP0(SP3b,Pd1,9,11,20,2,1,3,4,white),
  getPbyP0(SP3c,Pd2,9,11,20,2,1,3,4,white),

  cgArc(Red),
  Red^color #= red,
  2*Red^width #= 3*S0^width,
  Red^height #= Red^width,
  Red^startAngle #= 0,
  Red^arcAngle #= 180,
  Red^x #= S0^rightX - S0^width/4,
  Red^y #= Red^x,

  cgArc(Blue),
  Blue^color #= blue,
  cgSame([Blue,Red],location),
  cgSame([Blue,Red],size),
  Blue^startAngle #= 180,
  Blue^arcAngle #= 180,

  cgArc(AR),
  AR^color #= red,
  AR^width #= Red^width/2,
  AR^height #= Red^height/3,
  AR^startAngle #= 180,
  AR^arcAngle #= 200,
  AR^rightX #= Red^centerX,
  AR^centerY #= Red^centerY,

  cgArc(BR),
  BR^color #= blue,
  cgSame([AR,BR],size),
  BR^startAngle #= 0,
  BR^arcAngle #= 200,
  BR^x #= Red^centerX,
  BR^y #= AR^y + AR^width/20,  


  append(Ps0,Ps1,Psa),
  append(Ps2,Ps3,Psb),
  append(Psa,Psb,Ps), 

  append([SP2],[SP1a,SP1b],Sp12),
  append(Sp12,[SP3a,SP3b,SP3c],Sps),
  append(Ps,Sps,PM),
    
  Os=[Frame,Red,Blue,AR,BR|PM].

createBigPoly([],[]).
createBigPoly([R0|Res],[B0|Bes]):-
      cgPolygon(B0),
      B0^n #= 4,
      B0^color #= black,      
      B0^xs(1) #= R0^centerX,
      B0^ys(1) #= R0^y,
      B0^xs(2) #= R0^x,
      B0^ys(2) #= R0^centerY,
      B0^xs(3) #= R0^centerX,
      B0^ys(3) #= R0^bottomY,
      B0^xs(4) #= R0^rightX,
      B0^ys(4) #= R0^centerY,
      createBigPoly(Res,Bes).

createMulPs([Pa,Pb,Pc],P,A,B,C,D):-
    getPbyP0(Pa,P,0,4,20,A,B,C,D,black),
    getPbyP0(Pb,P,6,10,20,A,B,C,D,black),
    getPbyP0(Pc,P,12,16,20,A,B,C,D,black).
    

 getPbyP0(P,P0,I1,I2,T,A,B,C,D,Color):-  
    cgPolygon(P),
    P^n #=4,
    P^color #=Color,
    P^xs(2) #= (T-I1)*P0^xs(A)//T + I1*P0^xs(B)//T,
    P^ys(2) #= (T-I1)*P0^ys(A)//T + I1*P0^ys(B)//T,
    P^xs(3) #= (T-I2)*P0^xs(A)//T + I2*P0^xs(B)//T,

    P^ys(3) #= (T-I2)*P0^ys(A)//T + I2*P0^ys(B)//T,
    P^xs(4) #= (T-I2)*P0^xs(C)//T + I2*P0^xs(D)//T,
    P^ys(4) #= (T-I2)*P0^ys(C)//T + I2*P0^ys(D)//T,
    P^xs(1) #= (T-I1)*P0^xs(C)//T + I1*P0^xs(D)//T,
    P^ys(1) #= (T-I1)*P0^ys(C)//T + I1*P0^ys(D)//T.
