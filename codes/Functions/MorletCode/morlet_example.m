
close all;
clear all;
clc;

%Morlet design (select temporal/spectral resolution by changing FWHM_tc)
fc = 1; %central frequency, never change this
FWHM_tc = 3; %temporal resolution at central frequency
% morlet_design(fc,FWHM_tc) %function return resolutions at different frequencies


%example
t = 0:.01:1;
f = 5:0.2:20;
x = sin(2*pi*10*t);  
squared = 'n';
Coeff = morlet_transform(x,t,f,fc,FWHM_tc,squared);
squared = 'y';
P = morlet_transform(x,t,f,fc,FWHM_tc,squared);

%plot results
morlet_plot_coef(Coeff,t,f)

morlet_plot_coef(P,t,f)


%------------------------------------------

%frequency bands
% ? (4-7Hz), 
% ? low (8-10Hz), 
% ? high (11-14Hz), 
% ? low (14-19Hz), 
% ? high (20-30Hz), 
% ? (30-50Hz)

%example compute alpha frequency band for all channels

% f = linspace(8,10,4); %sample band with 4 points
% t = 0:0.001:1;
% x = rand(306,1001); %nChannels x nTimes
% P = morlet_transform(x,t,f,fc,FWHM_tc,squared);
% Palpha = squeeze(mean(P,2));



