% Funci�n para generar variable Rayleigh de par�metro alfa
% u debe ser uniforme(0, 1)
% Utilizaci�n:
% x = va_rayleigh(u, alfa)

function x = va_rayleigh(u, alfa)
    x = sqrt(-2*alfa^2*log(1-u));
end