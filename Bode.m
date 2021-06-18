
fprintf(2,'Für das Bodediagramm wird folgendes Benötigt:');
disp(' ');
n = 1;
%while n<2
n=input('Die Anzahl n der gegebenen Frequenzgänge (mind 2):');
%end
disp(['Die eingegebene Zahl war n = ',num2str(n)]);

fprintf(2,'Es gilt: ');
disp(' ');
disp('1 == const (fe=0)');
disp('2 == j*f/fe');
disp('3 == 1+j*f/fe');
disp('4 == 1/(1+j*f/fe)');
disp('Angeben der Form [1-4 fe]');
k=0;

while k<n
    k=k+1;
    disp(['Nr: ',num2str(k)]);
    Matrix(k,:)=input('Gib den Frequenzgang an: ');
    Y(k,:)=BodeWerte(Matrix(k,1),Matrix(k,2),0);
    Y2(k,:)=BodeWerte(Matrix(k,1),Matrix(k,2),1);
    X=logspace(-1,7,400);   
    Label(k,:)=(['Eingabe ',num2str(k)]);
    Markierung(k)=Matrix(k,2); 
end

Label(n+1,:)=['Addiert  '];
Label(n+2,:)=['Original '];
[fig2,axe2]=Diagramm(1);
[fig1,axe1]=Diagramm(0);
plot1=plot(axe1,X,Y,'LineWidth',1);
Yges=sum(Y);

if n>1
plot2=plot(axe1,X,Yges);
plot2.Color = 'k';
plot2.LineWidth = 2;
end

plot3=plot(axe1,Markierung,0,'ko');




%leg1=legend(axe1);
%leg1.String = Label;


plot4=plot(axe2,X,Y2,'LineWidth',1);
Y2ges=sum(Y2);
if n>1
plot5=plot(axe2,X,Y2ges);
plot5.Color = 'k';
plot5.LineWidth = 2;
end
plot6=plot(axe2,Markierung,0,'ko');


%leg2=legend(axe2);
%leg2.String = Label;

%Original Plot
k = 1;
funs = cell(4,1);
funs{1}=@(f,c) c;
funs{2}=@(f,fe) 1i*f/fe;
funs{3}=@(f,fe) 1+1i*f/fe;
funs{4}=@(f,fe) (1+1i*f/fe).^-1;

Array = cell(n,1);
f_werte = logspace(-1,7,400);
vals = 1;
ownFuns = cell(n, 1);
while (k<n+1)
   ownFuns{k} = @(f) funs{Matrix(k,1)}(f,Matrix(k,2));
   vals = vals .* ownFuns{k}(f_werte);
   k=k+1;
end
vals;
originalAmplitude = plot(axe1,f_werte, 20*log10(abs(vals)), '--k');
originalAmplitude.LineWidth = 1.5;


originalPhase = plot(axe2,f_werte, angle(vals)*180/pi, '--k');
originalPhase.LineWidth = 1.5;


clear k n Yges Y X Markierung Label;


%Create the values for each type
function [Y] = BodeWerte(Sorte,Frequenz,type)
X=logspace(-1,7,400);

switch Sorte
    case 1
    Y1=20*log10(Frequenz)+0*X;
    Y2=X*0;
    
    case 2 
    Y1=20*log10(X/Frequenz);
    Y2=90+0*X;
    
    case 3
    Y1(X>=Frequenz)=20*log10(X(X>=Frequenz)/Frequenz);
    Y2(X<10*Frequenz&X>=Frequenz/10)=+45+45*log10(X(X<10*Frequenz&X>=Frequenz/10)/Frequenz);Y2(X>=10*Frequenz)=90+X(X>=10*Frequenz)*0;Y2(X<Frequenz/10)=X(X<Frequenz/10)*0;
    
    case 4
    Y1(X>=Frequenz)=-20*log10(X(X>=Frequenz)/Frequenz);
    Y2(X<10*Frequenz&X>=Frequenz/10)=-45-45*log10(X(X<10*Frequenz&X>=Frequenz/10)/Frequenz);Y2(X>=10*Frequenz)=-90+X(X>=10*Frequenz)*0;Y2(X<Frequenz/10)=X(X<Frequenz/10)*0;
end
if type==0;
    Y=Y1;
else
    Y=Y2;
end
end

%Create Raw-Bode-Plot type 0 for absolute value and 1 for degree
function [fig,axe] = Diagramm(typ)
if typ==1
    fig1=figure();axe1=axes;set(fig1,'Position',[50 50 1185 547]);set(axe1,'XScale','log','XLim',[0.1 1e7],'YLim',[-180 180],'YGrid',true,'YTick',[-180 -135 -90 -45 0 45 90 135 180],'XGrid',true,'XTick',logspace(-1,7,9));hold on;
    axe1.XLabel.String=['Frequenz in Hz'];axe1.YLabel.String=['Phase in Grad'];axe1.XLabel.FontSize=13;axe1.YLabel.FontSize=13;
    fig=fig1;axe=axe1;
else
    fig2=figure();axe2=axes;set(fig2,'Position',[50 50 1185 547]);set(axe2,'XScale','log','XLim',[0.1 1e7],'YLim',[-60 20],'YGrid',true,'XGrid',true,'XTick',logspace(-1,7,9));hold on;
    axe2.XLabel.String=['Frequenz in Hz'];axe2.YLabel.String=['Betrag in dB'];axe2.XLabel.FontSize=13;axe2.YLabel.FontSize=13;
    fig=fig2;axe=axe2;
end
end
