% Función para generar variable Rayleigh de parámetro alfa
% u debe ser uniforme(0, 1)
% Utilización:
% x = va_rayleigh(u, alfa)

function x = va_rayleigh(u, alfa)
    x = sqrt(-2*alfa^2*log(1-u));
end