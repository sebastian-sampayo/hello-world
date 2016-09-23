
% Jugando con los valores de N0, se puede ver que el sistema detector
% funciona correctamente, solo cuando la potencia del ruido es lo
% suficientemente baja, esto es aproximadamente límite en 1e-7.
% Como se puede ver, en este caso la relación señal/ruido es 1.
% Nota: la regla de decisión es mala, ya que la medición permite
% una amplia diferencia ala salida del filtro entre un caso en el que
% hubo señal y un caso en que no. Sin embargo, el umbral se encuentra
% demasiado cerca del valor que se obtiene cuando hubo señal.

% M = 5000;
% alpha = 10;
% fc = 100e6; % Hertz
% k = 1;
% kf = 5;
% sigma = 1;
% v = 0; % metros por segundo
% d0 = 2 % metros
% N0 = 2;
% p = .4;


% Para encontrar el máximo del módulo del vector r (que está compuesto por
% la observación luego de pasar por cada uno de los filtros adaptados)
% lo que se hizo fue multiplicar la observación R por el filtro adaptado
% y para obtener las diferentes integrales para cada 'u', se convolucionó
% con un escalón de tamaño T. Luego el u para el cual se de el máximo de
% este vector resultante será el instante inicial de la cosenoide recibida.
% 
% En futuras implementaciones podría mejorarse el algoritmo evitando el uso
% de la convolución y solucionando el problema de maximizar la función
% con otro método más rápido. Ejemplo FFT.
% 
% Luego de implementar y simular reiteradas veces el filtro con el factor
% de escala sugerido en la especificación del trabajo (sqrt(2/T)),
% se descubrió que el umbral de decisión se encontraba demasiado cerca
% del valor que daba el máximo a la salida del filtro cuando efectivamente
% se enviaba una señal. Por el contrario cuando no se enviaba una señal,
% la diferencia entre el valor de la observación filtrada y el umbral de
% decisión era mucho más amplia. Por esta razón, la función solo detectaba
% correctamente cuando la relación señal/ruido era muy grande. 
% En base a estos hechos, se concluyó que un umbral menor detectaría mejor.
% Entonces se analizó cada uno de los parámetros que influían en dicha regla
% y se optó por independizar de la frecuencia utilizada, la potencia de la
% señal y por lo tanto la relación señal/ruido y a su vez el umbral de 
% decisión.
% En concreto lo que se tenía era:
% h1 = sqrt(2/T) * cos(2*pi*fc*t)
% h2 = sqrt(2/T) * sin(2*pi*fc*t)
% obteniendo así al pasar la señal por el filtro:
% señal: R(t) = (ecuación (19))
% R1 = R(t)*h1(t)|t=tau0 = (ecuacion (22))
% Como se puede ver, la varianza de esto dependerá claramente
% de la frecuencia utilizada:
% s1 = (T/2)*(alpha*sigma)^2
% Si en cambió se opta por elegir un factor de escala para h1 y h2
% de forma tal que dicha dependencia se anule, se obtiene:
% h1 = (2/T) * cos(2*pi*fc*t)
% h2 = (2/T) * sin(2*pi*fc*t)
% R1 = R(t)*h1(t)|t=tau0 = (ecuacion (22) modificada)
% s1 = (alpha*sigma)^2
% La mejoría en el algoritmo detector fue comprobada satisfactoriamente
% con los resultados de las simulaciones que se detallan a continuación.