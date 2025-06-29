LeggiDati_out = fileread('dati_out.txt');
Dati_outPulito = strip(LeggiDati_out);

SovrascriviDati_out = fopen('dati_out.txt', 'w');
fprintf(SovrascriviDati_out, '%s', Dati_outPulito);
fclose(SovrascriviDati_out);

LeggiDati_ref = fileread('dati_ref.txt');
Dati_refPulito = strip(LeggiDati_ref);

SovrascriviDati_ref = fopen('dati_ref.txt', 'w');
fprintf(SovrascriviDati_ref, '%s', Dati_refPulito);
fclose(SovrascriviDati_ref);

LEGGI_DATI_IN = fopen('dati.txt', 'r');
DATI_IN = readmatrix("dati.txt", 'OutputType','char');
fclose(LEGGI_DATI_IN);

LEGGI_DATI_REF = fopen('dati_ref.txt', 'r');
DATI_REF = readmatrix("dati_ref.txt", 'OutputType','char');
fclose(LEGGI_DATI_REF);

LEGGI_DATI_CIRCUITO = fopen('dati_out.txt', 'r');
DATI_OUT = readmatrix("dati_out.txt", 'OutputType','char');
fclose(LEGGI_DATI_CIRCUITO);

DATI_IN_NUM = zeros(1024,1);
DATI_OUT_NUM = zeros(1024,1);
DATI_REF_NUM = zeros(1024,1);

CORRETTO = 0;
FLAG = 0;

for i = 1:1024 
    DATI_IN_NUM(i) = bin2dec(DATI_IN{i});
    DATI_OUT_NUM(i) = bin2dec(DATI_OUT{i});
    DATI_REF_NUM(i) = bin2dec(DATI_REF{i});

    if DATI_REF{i} == DATI_OUT{i}
        CORRETTO = CORRETTO + 1;
    end
end
FLAG = 1024 - CORRETTO

if FLAG == 0
    fprintf("Okay")
end 