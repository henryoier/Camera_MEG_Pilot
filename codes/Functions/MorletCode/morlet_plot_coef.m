function morlet_plot_coef(Coef,t,f)
% function morlet_plot_coef(P,t,f)
%
% Plots a 2D map of wavelet coefficients. It shows the real, imaginary,
% absolute, and angle of the complex coefficients
%
% Inputs:
%   P: a matrix (nfreqs x ntimes) of the time-frequency power decomposition
%   t: a vector (ntimes x 1) of times
%   f: a vector (nfreqs x 1) to frequencies
%
% Author: Dimitrios Pantazis, December 2008, USC

%if Coef is power (coefficients squared)
if isreal(Coef)
    figure; set(gcf,'color','white')
    imagesc(t,f,Coef);
    title('Real')
    return
end
    
%if Coef is Morlet coefficients
figure; set(gcf,'color','white')
subplot(2,2,1);
imagesc(t,f,real(Coef));
title('Real')

subplot(2,2,2);
imagesc(t,f,imag(Coef))
title('Imaginary')

subplot(2,2,3);
imagesc(t,f,abs(Coef));
title('Absolute')
xlabel('Time');
ylabel('Frequency')

subplot(2,2,4);
imagesc(t,f,angle(Coef));
title('Angle')




