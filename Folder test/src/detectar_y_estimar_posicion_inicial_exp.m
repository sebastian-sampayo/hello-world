%-------------------------------------------------------------------
% Detector y estimador. Detector modificado. Distribuciones exponenciales
%-------------------------------------------------------------------
%
% [D, d0_est] = detectar_y_estimar_posicion_inicial_exp(R, alpha, fc, k, kf, sigma, N0, p)
% p: Probabilidad de que exista un blanco
% D: 1 si se detecta un blanco, 0 de lo contrario.
% d0_est: estimación de la distancia si D=1.

function [D, d0_est, varargout] = detectar_y_estimar_posicion_inicial_exp(R, alpha, fc, k, kf, sigma, N0, p)
    c = 3e8;
    M = length(R);
    T = k/fc;
    Tf = kf/fc;
    Ts = Tf/M;
    nT = ceil(T/Ts);
    t = linspace(0, Tf, M);
    % Filtros Adaptados
    k = 2/T;
    h1 = k * cos(2*pi*fc*t); % Modifiqué la constante
    h2 = k * sin(2*pi*fc*t); % del filtro. Era sqrt(2/T)
    % Potencia de ruido y señal+ruido
    s0 = (k^2*T/4)*N0;
    s1 = (k^2*T/4)*(T*(alpha*sigma)^2+N0);
%     s0 = N0/2;
%     s1 = (alpha*sigma)^2 + s0;
    lambda0 = 1/(2*s0);
    lambda1 = 1/(2*s1);
    gama = (1-p)/p;
    
    uT = [ones(1, nT) zeros(1, M-nT)]; % Escalón de largo T.
    Rcos = R .* h1 * Ts;
    Rsin = R .* h2 * Ts;
    r1 = conv(uT, Rcos);
    r1 = r1(nT:end-nT);
    r2 = conv(uT, Rsin);
    r2 = r2(nT:end-nT);
    
    r_abs = r1.^2 + r2.^2;
    u = find(r_abs==max(r_abs)); % muestra.
    tau = u*Ts; % tiempo
    
%     D = (max(r_abs) > (2*s0*s1*(log(gama)-2*log(sqrt(s0/s1)))/(s1-s0)));
    A = log(gama*lambda0/lambda1)/(lambda0-lambda1);
    D = (max(r_abs) > A);
%     (s1/2+s0/2)/2
    if D==1
        d0_est = c*tau/2; % distancia
    else
        d0_est = -1;
    end
    
    % Umbral
    varargout{1} = (2*s0*s1*(log(gama)-2*log(sqrt(s0/s1)))/(s1-s0));
    varargout{3} = A;
    % ||r||^2
    varargout{2} = max(r_abs);
end