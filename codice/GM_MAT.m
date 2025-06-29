clc;
clear all;
close all;

data = 1024;
DIN = zeros(data,1);
DREF = zeros(data,1);
x = 0;
byte = zeros(1,8);
VALUES = zeros(data, 1);

BYTE_CHAR_AUX = [];
DATA_IN_AUX = newline;

A = zeros(1024,1);
D = zeros(1024,1);


for n = 1:data
    for bit = 1:8

        x = rand;
        if x > 0.5 %%RANDOMIZZA I BIT PER OGNI BYTE
            byte(1,bit) = 1;
        else
            byte(1,bit) = 0;
        end

        DIN(n,bit) = byte(1,bit);

        if (bit == 1) %%CONVERTE IL VALORE DA COMPLEMENTO A 2 A DECIMALE
            VALUES(n, 1) = VALUES (n,1) + byte(1, bit)*-2^(8-bit);
        else
            VALUES(n, 1) = VALUES (n,1) + byte(1, bit)*2^(8-bit);
        end

    end

    BYTE_CHAR_AUX = append(num2str(DIN(n, 1)), num2str(DIN(n, 2)), num2str(DIN(n, 3)), num2str(DIN(n, 4)), num2str(DIN(n, 5)), ...
                    num2str(DIN(n, 6)), num2str(DIN(n, 7)), num2str(DIN(n, 8)), newline);
    %% DIN mentiene i valori binari creati in modo randomico, ma per
    % inviarli come txt li vogliamo in formato char e non double! 

    DATA_IN_AUX = append(DATA_IN_AUX, BYTE_CHAR_AUX);
    %% è il grande blocco char che viene poi scritto in 'dati.txt' sotto
    % forma di righe (separazione: newline), affinchè possano essere lette
    % singolarmente dalla nostra testbench su Modelsim
end


%% GOLDEN MODEL
for k = 1:data
    %% è importante che il nostro golden model approssimi esattamente come
    % il nostro circuito, dunque che ci sia distinzione tra valori negativi
    % e positivi. I valori positivi sono approssimati in difetto usando la 
    % funzione 'fix', per i valori negativi c'è un'ulteriore distinzione tra quelli
    % con la virgola, che dovranno avere il loro valore assoluto aumentato di +1
    % [dunque +1 per (-0.5X) e -1 per (+0.25X)] e quelli senza virgola che
    % rimangono invariati

    if VALUES(k,1) < 0
        if rem ( VALUES(k,1),2) ~= 0
            A(k,1) = -fix(VALUES (k, 1)/2)+1;
        else
            A(k,1) = -fix(VALUES (k, 1)/2);
        end

        if rem ( VALUES(k,1),4) ~= 0
            D(k,1) = fix(VALUES (k, 1)/4)-1;
        else
            D(k,1) = fix(VALUES(k, 1)/ 4);  
        end
    else
        A(k,1) = -fix(VALUES (k, 1)/2);
        D(k,1) = fix(VALUES (k, 1)/4);
    end


    if (k == 1) %% Definiamo i primi 3 output come da traccia
        DREF(1, 1) = A(1);
    elseif (k == 2)
        DREF(2, 1) = A(2) - 2*VALUES (1, 1);
    elseif (k ==3)
        DREF(3,1) = A(3) - 2*VALUES (2, 1) + 4*VALUES(1, 1);
    else
        %% funzione generica del filtro
        DREF(k, 1) = A(k,1) - 2*VALUES (k-1, 1) + 4*VALUES(k-2, 1) + D(k-3,1);
    end
    
    %% Saturazione
    if DREF(k, 1) > 127
        DREF(k, 1) = 127;
    elseif DREF(k,1) < -128
        DREF(k, 1) = -128;
    end


    %% Per il nostro Golden Model abbiamo deciso di lavorare ad alto livello
    % con i decimali, ricreando i limiti dovuti dal lavorare in binario.
    % Per mandare i valori del Golden Model su un blocco .txt, abbiamo
    % dovuto riconvertirli.

    DREF_bit(k,1:8) = dec2bin(DREF(k,1), 8);
end


%% Ci occupiamo di esportare i dati
writematrix(DATA_IN_AUX,'dati.txt','Delimiter',' ')

%% Ripuliamo i dati da tutte le newline e caratteri di spazio, in modo
% da non creare problemi quando leggiamo il file su VHDL
LeggiDati = fileread('dati.txt');
DatiPulito = strip(LeggiDati);

SovrascriviDati = fopen('dati.txt', 'w');
fprintf(SovrascriviDati, '%s', DatiPulito);
fclose(SovrascriviDati);

%% Creiamo il file dati_out.txt, nel caso in cui VHDL non lo faccia in automatico
CREAFILE = fopen('dati_out.txt', 'w');
fclose(CREAFILE);

LeggiDati_out = fileread('dati_out.txt');
Dati_outPulito = strip(LeggiDati_out);

SovrascriviDati_out = fopen('dati_out.txt', 'w');
fprintf(SovrascriviDati_out, '%s', Dati_outPulito);
fclose(SovrascriviDati_out);

%% Creiamo un .txt per il golden model
OUTPUT_REFERENCE = fopen('dati_ref.txt', 'w');
writematrix(DREF_bit,'dati_ref.txt','Delimiter',' ');
fclose(OUTPUT_REFERENCE);



%% TEST DELLA FUNZIONALITA' (RE)START (CREIAMO UN ALTRO SET DI DATI IN INPUT)

DIN2 = zeros(data,1);
x2 = 0;
byte2 = zeros(1,8);
BYTE_CHAR_AUX2 = [];
DATA_IN_AUX2 = newline;

for m2 = 1:data
    for bit2 = 1:8

        x2 = rand;
        if x2 > 0.5
            byte2(1,bit2) = 1;
        else
            byte2(1,bit2) = 0;
        end

        DIN2(m2,bit2) = byte2(1,bit2);
    end

    BYTE_CHAR_AUX2 = append(num2str(DIN2(m2, 1)), num2str(DIN2(m2, 2)), num2str(DIN2(m2, 3)), num2str(DIN2(m2, 4)), num2str(DIN2(m2, 5)), ...
                    num2str(DIN2(m2, 6)), num2str(DIN2(m2, 7)), num2str(DIN2(m2, 8)), newline);

    DATA_IN_AUX2 = append(DATA_IN_AUX2, BYTE_CHAR_AUX2);
end
writematrix(DATA_IN_AUX2,'dati2.txt','Delimiter',' ')
LeggiDati2 = fileread('dati2.txt');
DatiPulito2 = strip(LeggiDati2);

SovrascriviDati2 = fopen('dati2.txt', 'w');
fprintf(SovrascriviDati2, '%s', DatiPulito2);
fclose(SovrascriviDati2);