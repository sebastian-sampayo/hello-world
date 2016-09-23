
% Jugando con los valores de N0, se puede ver que el sistema detector
% funciona correctamente, solo cuando la potencia del ruido es lo
% suficientemente baja, esto es aproximadamente l�mite en 1e-7.
% Como se puede ver, en este caso la relaci�n se�al/ruido es 1.
% Nota: la regla de decisi�n es mala, ya que la medici�n permite
% una amplia diferencia ala salida del filtro entre un caso en el que
% hubo se�al y un caso en que no. Sin embargo, el umbral se encuentra
% demasiado cerca del valor que se obtiene cuando hubo se�al.

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


% Para encontrar el m�ximo del m�dulo del vector r (que est� compuesto por
% la observaci�n luego de pasar por cada uno de los filtros adaptados)
% lo que se hizo fue multiplicar la observaci�n R por el filtro adaptado
% y para obtener las diferentes integrales para cada 'u', se convolucion�
% con un escal�n de tama�o T. Luego el u para el cual se de el m�ximo de
% este vector resultante ser� el instante inicial de la cosenoide recibida.
% 
% En futuras implementaciones podr�a mejorarse el algoritmo evitando el uso
% de la convoluci�n y solucionando el problema de maximizar la funci�n
% con otro m�todo m�s r�pido. Ejemplo FFT.
% 
% Luego de implementar y simular reiteradas veces el filtro con el factor
% de escala sugerido en la especificaci�n del trabajo (sqrt(2/T)),
% se descubri� que el umbral de decisi�n se encontraba demasiado cerca
% del valor que daba el m�ximo a la salida del filtro cuando efectivamente
% se enviaba una se�al. Por el contrario cuando no se enviaba una se�al,
% la diferencia entre el valor de la observaci�n filtrada y el umbral de
% decisi�n era mucho m�s amplia. Por esta raz�n, la funci�n solo detectaba
% correctamente cuando la relaci�n se�al/ruido era muy grande. 
% En base a estos hechos, se concluy� que un umbral menor detectar�a mejor.
% Entonces se analiz� cada uno de los par�metros que influ�an en dicha regla
% y se opt� por independizar de la frecuencia utilizada, la potencia de la
% se�al y por lo tanto la relaci�n se�al/ruido y a su vez el umbral de 
% decisi�n.
% En concreto lo que se ten�a era:
% h1 = sqrt(2/T) * cos(2*pi*fc*t)
% h2 = sqrt(2/T) * sin(2*pi*fc*t)
% obteniendo as� al pasar la se�al por el filtro:
% se�al: R(t) = (ecuaci�n (19))
% R1 = R(t)*h1(t)|t=tau0 = (ecuacion (22))
% Como se puede ver, la varianza de esto depender� claramente
% de la frecuencia utilizada:
% s1 = (T/2)*(alpha*sigma)^2
% Si en cambi� se opta por elegir un factor de escala para h1 y h2
% de forma tal que dicha dependencia se anule, se obtiene:
% h1 = (2/T) * cos(2*pi*fc*t)
% h2 = (2/T) * sin(2*pi*fc*t)
% R1 = R(t)*h1(t)|t=tau0 = (ecuacion (22) modificada)
% s1 = (alpha*sigma)^2
% La mejor�a en el algoritmo detector fue comprobada satisfactoriamente
% con los resultados de las simulaciones que se detallan a continuaci�n.