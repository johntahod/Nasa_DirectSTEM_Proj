Observed=[16,98,96,49,81];%Randomly Selected Values
True=SWE(Observed);
b = 1;% position counter
k=1;% counter
for a = 1:Latitude;% 1-121, index for loop
n = find(ismember(Observed, a) == 1); %is member compares two vectors finds shared value
if isempty(n)==1
true_latitude(b) = Latitude(a);
true_longitude(b) = Longitude(a);
true_SWE(b) = SWE(a);
true_elevation(b) = Elevation(a);
b = b+1;
else
obs_lat(k) = Latitude(a);
obs_long(k) = Longitude(a);
obs_swe(k) = SWE(a);
obs_elev(k) = Elevation(a);
k = k+1;
end
end
%% Determine Min and Max for Latitude and Longitude
MinLatitude= min(Latitude);%min latitude
MaxLatitude= max(Latitude);%max latitude
MinLongitude= min(Longitude);%min longitude
MaxLongitude= max(Longitude);%max longitude
%% Scattered Interpolant Method at 0.5
F1 = scatteredInterpolant(true_longitude.',true_latitude.',true_SWE.','linear');%XYV Linear
F2 = scatteredInterpolant(true_longitude.',true_latitude.',true_SWE.','natural');%XYV Natural
F3 = scatteredInterpolant(true_longitude.',true_latitude.',true_SWE.','nearest');%XYV Nearest
[Xq,Yq] = meshgrid(MinLongitude:0.5:MaxLongitude,MinLatitude:0.5:MaxLatitude);%
Vq1 =F1(Xq,Yq);%Linear
Vq2 =F2(Xq,Yq);%Natural
Vq3 =F3(Xq,Yq);%Nearest
Nonexistent1=find(Vq1<0); %Linear
Nonexistent2=find(Vq2<0);%Natural
Nonexistent3=find(Vq3<0);%Nearest
Vq1(Nonexistent1)=NaN;%Make nonexistent number NaN
Vq2(Nonexistent2)=NaN;%Make nonexistent number NaN
Vq3(Nonexistent3)=NaN;%Make nonexistent number NaN
%%
Z = peaks;
[Xq,Yq] = size(Z);
subplot(2,2,1);%plotted grapped
imagesc(MinLongitude:.5:MaxLongitude,MinLatitude:.5:MaxLatitude,Vq1);%Turn Meshgrid into image
C=colorbar;%Colorbar
C.Label.String = 'SWE [in^2]';%Title for String
xlabel('Longitude','fontsize',16);%xlabel
ylabel('Latitude','fontsize',16);%ylabel
set(gca,'fontsize',12,'ydir','normal');
title('Linear Interpolation Method [in^2]','fontsize',12);%Title
datacursormode on%Turns on Datacursormode
%%
subplot(2,2,2);%plotted grapped
imagesc(MinLongitude:.5:MaxLongitude,MinLatitude:.5:MaxLatitude,Vq2);%Turn Meshgrid into image
C=colorbar;%Colorbar
C.Label.String = 'SWE [in^2]';%Title for String
xlabel('Longitude','fontsize',16);%xlabel
ylabel('Latitude','fontsize',16);%ylabel
set(gca,'fontsize',12,'ydir','normal');
title('Natural Interpolation Method [in^2]','fontsize',12);%Title
datacursormode on%Turns on Datacursormode
%%
subplot(2,2,3);%plotted grapped
imagesc(MinLongitude:.5:MaxLongitude,MinLatitude:.5:MaxLatitude,Vq3);%Turn Meshgrid into image
C=colorbar;%Colorbar
C.Label.String = 'SWE [in^2]';%Legend Title
xlabel('Longitude','fontsize',16);%xlabel
ylabel('Latitude','fontsize',16);%ylabel
set(gca,'fontsize',12,'ydir','normal');%Title for Values
title('Nearest Interpolation Method [in^2]','fontsize',12);%Title
datacursormode on%Turns on Datacursormode
ObservedValues=[10.80,15.70,14.40,13.60,10.80];%True Values of Observed SWE
SimLinear=[1.082,25.35,32.69,9.703,21.34];%Simulated Linear Values
SimNatural=[1.08,21.41,28.55,9.969,19.49];%Simulated Natural Values
SimNearest=[0.7,27.1,6.7,13.8,20.8];%Simulated Interpolation Values
%% Comparing Observed SWE Measurement and Simulated Measurements [Linear]
A1=(ObservedValues - SimLinear);%Errors Linear
A1=(ObservedValues - SimLinear).^2;%Squared Error
A1=nanmean(ObservedValues - SimLinear).^2;%Mean Squared Error
RMSE_Linear=sqrt(nanmean(ObservedValues - SimLinear).^2);%Root Mean Squared
R=corrcoef(ObservedValues,SimLinear);%Pearson's correlation shows that the values are positive
R2_Linear=R(2,1)^2;%Pearson's Correlation
BIAS_Linear= abs(sum(ObservedValues-SimLinear)/5)*100;%Mean Squared Error multiplied by 100
%% Comparing Observed SWE Measurement and Simulated Measurements [Natural]
A2=(ObservedValues - SimNatural);%Errors Natural
A2=(ObservedValues - SimNatural).^2;%Squared Error
A2=nanmean(ObservedValues - SimNatural).^2;%Mean Squared Error
RMSE_Natural= sqrt(nanmean(ObservedValues - SimNatural).^2);%Root Mean Squared Error
R=corrcoef(ObservedValues,SimNatural);%Pearson's correlation shows that the values are positive
R2_Natural=R(2,1)^2;%Pearson's Correlation
BIAS_Natural= abs(sum(ObservedValues-SimNatural)/5)*100;%Mean Squared Error multiplied by 100
%% Comparing Observed SWE Measurement and Simulated Measurements [Nearest]
A3=(ObservedValues - SimNearest);%Errors Interpolation
A3=(ObservedValues - SimNearest).^2;%Squared Error
A3=nanmean(ObservedValues - SimNearest).^2;%Mean Squared Error
RMSE_Nearest= sqrt(nanmean(ObservedValues - SimNearest).^2);%Root Mean Squared Error
R=corrcoef(ObservedValues,SimNearest);%Pearson's correlation shows that the values are positive
R2_Nearest=R(2,1)^2;%Pearson's Correlation
BIAS_Nearest=abs(sum(ObservedValues-SimNearest)/5)*100;%Mean Squared Error multiplied by 100
%% Table
Interp={'Linear';'Natural';'Nearest'};%
RMSE=[RMSE_Linear;RMSE_Natural;RMSE_Nearest];%Rootmean Squared Error Column
R2=[R2_Linear;R2_Natural;R2_Nearest];%Pearson's Correlation Column
BIAS=[BIAS_Linear;BIAS_Natural;BIAS_Nearest];%Bias Column
T=table(RMSE,R2,BIAS,'RowNames',Interp)% creating a table