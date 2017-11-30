;Ahmet Demirel 1321012052,  Nafi Durmu� 1411012027, Sefa Emraho�lu 1411012016
.org 0
    rjmp tanimlamalar
tanimlamalar:			;ilk ba�ta gerekli tan�mlamalar� yapt��m�z fonksiyon
    ldi r16,0xFF	    ; 0xxFF 1111 1111 -> PORTCyi output yapmak istiyoruz, o nedenle t�m bitler 1
    out DDRC,r16		; PortC nin data direction registeri DDRC ye r16 daki degeri yaziyoruz
    ldi r17,0x01		;ba�lang�c i�in ilk ledin yanmas� i�in 0000 0001 de�erini y�kl�yoruz
    ldi r19,0x00 		; 0x00=0010 0000 -> PORTB nin t�m pinlerini input yapmak istiyoruz, o nedenle 0000 0000 y�kledik 
	ldi r30,0x01		;rol de elde biti i�in kullan�yoruz
	ldi r31,0x80		;ror da elde biti i�in kullan�yoruz
    out DDRB,r19	    ; PortB nin data direction registeri DDRB ye r19 daki degeri yaziyoruz
    sbi PORTB,0			; PB0 nin pull-up direncini aktiflestiriyoruz. artik butona basilmadiginda 1, basilinca 0 okuyacagiz
    sbi PORTB,1			; PB1 nin pull-up direncini aktiflestiriyoruz. artik butona basilmadiginda 1, basilinca 0 okuyacagiz
    sbi PORTB,2         ; PB2 nin pull-up direncini aktiflestiriyoruz. artik butona basilmadiginda 1, basilinca 0 okuyacagiz

main:					; tek led yanarken tekrar 1. ledden ba�lamas� i�in 0x01 y�klemeyi tekrarlad�k
    ldi r17,0x01

tekliyavas:				;tek ledde saat y�n�nde yava� olarak ilerleyen fonksiyon
    out PORTC,r17 		;r17 deki degeri PORTC ye yaziyoruz.
	call waityavas		;yava� h�zda ilerlemesi i�in gerekli fonksiyon
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    call tekliorta		;buton bas�lm��sa gidicelecek olan fonksiyon
    lsl r17				;saat y�n�nde ledleri kayd�rmak i�in
    sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp teklitersyavas	;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikiliyapmayavas ;ledlerin ikili olarak kaymas�n� sa�layan fonksiyonu call ediyoruz
    brne tekliyavas 	;zerro biti s�f�r ise dallanacak yani tekliyavas fonksiyonu tekrar �al��acak 
    rjmp main			;zero biti s�f�r oldu�unda tekrar ba�tan ba�lamas� i�in maine s��rad�k

ikiliyapmayavas:		;Yavas h�zda ikili olarak ilerleme
	mov r24,r17			;r17 deki de�eri r24 e at�yoruz
	lsl r17				;r17yi kayd�rd�k
	or r17,r24			;r24 ile r17 nin yeni de�erini or yaparak iki ledin yanmas�n� sa�lad�k
	rjmp ikiliyavas		;ikiliyavas fonksiyonuna s��rad�k


teklitersyavas:			;saat y�n�n�n tersine ilerlemek i�in gerekli fonksiyon
    out PORTC,r17		;r17 deki degeri PORTC ye yaziyoruz.
    lsr r17				;saat y�n�n�n tersine ledleri kayd�rmak i�in
    call waityavas 		;yava� h�zda ilerlemesi i�in gerekli fonksiyon
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    call teklitersorta	;h�z kontrol butonu bas�lm��sa orta h�zl� olan fonksiyona gidiyoruz
    sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp tekliyavas		;y�n� kontrol eden buton bas�lm��sa gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ikilitersyapmayavas ;led say�s�n� kontrol eden buton bas�lm��sa 
    BRCS GERI			;carry biti 1 ise geri fonksiyonuna dallanacak
    rjmp teklitersyavas	;carry biti 0 ise fonksiyon tekrarlanacak

GERI:					;tersten tekrar ba�lamak i�in 0001 0000 y�klemesi yap�yoruz
    ldi r17,0x80
    call teklitersyavas ;y�klemeden sonra tekrar fonksiyona gidiyoruz

ikilitersyapmayavas:	;ikili olarak saat y�n�n�n tersine yavas fonksiyon
	mov r24,r17			;r17 deki de�eri r24 e at�yoruz
	lsr r17				;r17yi kayd�rd�k
	or r17,r24			;r24 ile r17 nin yeni de�erini or yaparak iki ledin yanmas�n� sa�lad�k
	rjmp ikilitersyavas ;led say�s�n� ikili yapt�k ve kayma i�lemi i�in ikilitersyavas fonksiyonuna s��r�yoruz

main2:					; tek led orta h�zda yanarken tekrar 1. ledden ba�lamas� i�in 0x01 y�klemeyi tekrarlad�k
    ldi r17,0x01

tekliorta:				;tek led orta h�zda ilerlerkenki
	out PORTC,r17 		;r17 deki degeri PORTC ye yaziyoruz.
	call waitorta		;gecikme i�in gereki fonksiyonu call ediyoruz
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    call teklihizli		;h�z butonu bas�lm��sa hizlanma fonksiyonunu call ediyoruz
    lsl r17				;orta h�zda kayma i�lemleri yap�l�yor
    sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp teklitersorta	;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir 
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ikiliyapmaorta	;led say�s� butonu bas�lm��sa ikili yapma fonksiyonuna s��r�yoruz
	brne tekliorta 		;zerro biti s�f�r ise dallanacak yani tekliorta fonksiyonu tekrar �al��acak 
    rjmp main2			;tekrar ba�tan ba�lamak i�in main2 ye s��r�yoruz

ikiliyapmaorta:			;Yavas h�zda ikili olarak ilerleme
	mov r24,r17			;r17 deki de�eri r24 e at�yoruz
	lsl r17				;r17yi kayd�rd�k
	or r17,r24			;r24 ile r17 nin yeni de�erini or yaparak iki ledin yanmas�n� sa�lad�k
	rjmp ikiliorta		;ikiliorta fonksiyonuna s��rad�k

teklitersorta:			;orta h�zda tekled yanarak saat y�n�n�n tersine giden fonksiyon
    out PORTC,r17		;r17 deki degeri PORTC ye yaziyoruz.
    lsr r17				;ledleri kayd�rma i�lemini yap�yoruz
    call waitorta 		;orta h�zda ilermesi i�in gerekli gecikme fonksiyonunu call ediyoruz
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    call teklitershizli ; buton bas�lm��sa h�zl� fonksiyona gidiyoruz
    sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp tekliorta		;buton bas�lm��sa saat y�n�ne gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ikilitersyapmaorta ; buton bas�lm��sa led say�s�n� art�rmak i�in gerekli fonksiyonu call ediyoruz
	BRCS GERI1			;carry biti varsa geri1 fonksiyonuna gidiyoruz
    rjmp teklitersorta	;carry yoksa fonksiyonu tekrarl�yoruz

ikilitersyapmaorta:		;orta h�zda saat y�n�n�n tersine �al��an fonksiyon
	mov r24,r17			;r17 deki de�eri r24 e at�yoruz
	lsl r17				;r17yi kayd�rd�k
	or r17,r24			;r24 ile r17 nin yeni de�erini or yaparak iki ledin yanmas�n� sa�lad�k
	rjmp ikilitersorta  ;ikilitersorta fonksiyonuna s��rad�k

GERI1:					;fonksiyon tekrar ba�tan yanmas� i�in 0001 0000 y�klemesi yap�yoruz
    ldi r17,0x80
    call teklitersorta

main3:					;fonksiyon tekrar ba�tan yanmas� i�in 0000 0001 y�klemesi yap�yoruz
	ldi r17,0x01

teklihizli:				;tek led saat y�n�nde h�zl� ilerlerken 
	out PORTC,r17		;r17 deki degeri PORTC ye yaziyoruz.
	call waithizli		;bekleme fonksiyonunu call ediyoruz
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    call tekliyavas		;buton bas�lm��sa yava�lama fonksiyonuna gidiyoruz
    lsl r17				;ledlerin kaymas� i�in kullan�yoruz
    sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp teklitershizli	;buton bas�lm��sa saat y�n�n�n tersine d�nmesini sa�layan fonksiyonu call ediyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ikiliyapmahizli ;buton bas�lm��sa led say�s�n� artt�ran fonksiyona gidiyoruz
	brne teklihizli 	;zero biti s�f�r ise dallanacak yani teklihizl fonksiyonu tekrar �al��acak
    rjmp main3			;zero biti s�f�r de�ilse ledler tekrardan yanmas� i�in kullan�yoruz

ikiliyapmahizli:		;saat y�n�nde h�zl� olarak led say�s�n� artt�rr�yoruz
	mov r24,r17			;r17 deki de�eri r24 e at�yoruz
	lsl r17				;r17yi kayd�rd�k
	or r17,r24			;r24 ile r17 nin yeni de�erini or yaparak iki ledin yanmas�n� sa�lad�k
	rjmp ikilihizli		;ikilihizli fonksiyonuna s��rad�k

teklitershizli:			;tek led ile saat y�n�n�n tersine ilerlemek i�in
    out PORTC,r17		;r17 deki degeri PORTC ye yaziyoruz.
    lsr r17				;ledleri kayd�rma i�lemini yap�yoruz
    call waithizli 		;gecikme fonksiyonunu call ediyoruz
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    call teklitersyavas ;buton bas�lm��sa yavaslamak i�in gerekli fonksiyona gidiyoruz
    sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp teklihizli		;buton bas�lm��sa saat y�n�ne gitmek i�in kulland���m�z fonksiyona s��r�yoruz
    BRCS GERI2			;carry biti varsa geri2 fonksiyonuna gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ikilitersyapmahizli ;buton bas�lm��sa ikilitersyapmahizli fonksiyonuna s��r�yoruz
    rjmp teklitershizli ;buton kontrollerinden sonra tekrar fonksiyona s��r�yoruz

GERI2:					;tersten tekrar devam etmesi i�in 0001 0000 y�klemesi yap�yoruz
    ldi r17,0x80
    call teklitershizli	

ikilitersyapmahizli:	;saat y�n�n�n tersine gitmek i�in kulland���m�z fonksiyon
	mov r24,r17			;r17 deki de�eri r24 e at�yoruz
	lsl r17				;r17yi kayd�rd�k
	or r17,r24			;r24 ile r17 nin yeni de�erini or yaparak iki ledin yanmas�n� sa�lad�k
	rjmp ikilitershizli ;ikilitershizli fonksiyonuna s��rad�k




ikiliyavas:				 ;iki led yanarken yavas h�zda saat y�n�nde ilerleyen fonksiyon
	out PORTC,r17 		 ;r17 deki degeri PORTB ye yaziyoruz.
	call waityavas		 ;yava� i�in gerekli fonksiyonu call ediyoruz
    sbis PINB,0			 ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikiliorta       ;butona bas�lm��sa h�z� bir kademe artt�ran fonksiyona gider
    rol r17              ;ledleri kayd�rmak i�in
	sbis PINB,1		     ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ikilitersyavas	 ;buton bas�lm��sa saat y�n�n�n tersine d�nmesini sa�layan fonksiyonu call ediyoruz
	brcs toplaikiliyavas ;carry biti varsa toplaikiliyavas fonksiyonuna gidiyoruz
	sbis PINB,2          ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ucluyapmayavas  ;buton bas�lm��sa ucluyapmayavas fonksiyonuna s��r�yoruz
    brne ikiliyavas 	 ;Zero biti 0 ise ikiliyavas fonksiyonuna gidiyoruz
    
toplaikiliyavas:         ;sondan ba�a ikili ge�mek i�in.
	or r17,r30           ;lojik veya i�lemi yapt�k
	clc                  ;carry bitini temizliyoruz
	rjmp ikiliyavas      ;ikiliyavas fonksiyonuna atl�yoruz

ucluyapmayavas:         ;uclu yapma
	mov r24,r17         ;r17 de ki de�eri r24 e atad�k
	lsl r17             ;ledlerde kayd�rma yapt�k 
	or r17,r24          ;lojik veya i�lemi yapt�k
	rjmp ucluyavas      ;ucluyavas fonksiyonuna atlad�k


ikilitersyavas:              ;iki led yanarken yavas h�zda saat y�n�n�n tersine ilerleyen fonksiyon
	out PORTC,r17 	         ; r17 deki degeri PORTB ye yaziyoruz.
	call waityavas           ;yava� i�in gerekli fonksiyonu call ediyoruz
    sbis PINB,0              ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikilitersorta       ;butona bas�lm��sa h�z� bir kademe artt�ran fonksiyona gider
    ror r17                  ;ledleri kayd�rmak i�in
	sbis PINB,1		         ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ikiliyavas          ;buton bas�lm��sa saat y�n�ne d�nmesini sa�layan fonksiyonu call ediyoruz
	brcs toplatersikiliyavas ;carry biti varsa toplaikiliyavas fonksiyonuna gidiyoruz
	sbis PINB,2              ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp uclutersyapmayavas  ;buton bas�lm��sa uclutersyapmayavas fonksiyonuna s��r�yoruz
    brne ikilitersyavas      ;Zero biti 0 ise ikilitersyavas fonksiyonuna gidiyoruz

toplatersikiliyavas:       ;ba�tan sona ikili ge�mek i�in.
	or r17,r31             ;lojik veya i�lemi yapt�k
	clc                    ;carry bitini temizliyoruz
	rjmp ikilitersyavas    ;ikilitersyavas fonksiyonuna atl�yoruz

uclutersyapmayavas:      ;uclu yapma
	mov r24,r17          ;r17 de ki de�eri r24 e atad�k
	lsl r17              ;ledlerde kayd�rma yapt�k 
	or r17,r24           ;lojik veya i�lemi yapt�k
	rjmp uclutersyavas   ;uclutersyavas fonksiyonuna atlad�k

ikiliorta:               ;iki led yanarken orta h�zda saat y�n�nde ilerleyen fonksiyon
	out PORTC,r17 	     ;r17 deki degeri PORTB ye yaziyoruz.
	call waitorta        ;orta h�z i�in gerekli fonksiyonu call ediyoruz
    sbis PINB,0          ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikilihizli      ;butona bas�lm��sa h�z� bir kademe artt�ran fonksiyona gider
    rol r17              ;ledleri kayd�rmak i�in
	sbis PINB,1		     ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ikilitersorta	 ;buton bas�lm��sa saat y�n�n�ntersine d�nmesini sa�layan fonksiyonu call ediyoruz
	brcs toplaikiliorta  ;carry biti varsa toplaikiliorta fonksiyonuna gidiyoruz
	sbis PINB,2          ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ucluyapmaorta   ;buton bas�lm��sa ucluyapmaorta fonksiyonuna s��r�yoruz
    brne ikiliorta 	     ;Zero biti 0 ise ikiliorta fonksiyonuna gidiyoruz
    
toplaikiliorta:          ;sondan ba�a ikili ge�mek i�in.
	or r17,r30           ;lojik veya i�lemi yapt�k
	clc                  ;carry bitini temizliyoruz
	rjmp ikiliorta       ;ikiliorta fonksiyonuna atl�yoruz

ucluyapmaorta:           ;uclu yapma
	mov r24,r17          ;r17 de ki de�eri r24 e atad�k
	lsl r17              ;ledlerde kayd�rma yapt�k 
	or r17,r24           ;lojik veya i�lemi yapt�k
	rjmp ucluorta        ;ucluorta fonksiyonuna atlad�k


ikilitersorta:           ;iki led yanarken orta h�zda saat y�n�n�n tersine ilerleyen fonksiyon
	out PORTC,r17 	     ;r17 deki degeri PORTB ye yaziyoruz.
	call waitorta        ;orta h�z i�in gerekli fonksiyonu call ediyoruz
    sbis PINB,0          ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikilitershizli  ;butona bas�lm��sa h�z� bir kademe artt�ran fonksiyona gider
    ror r17              ;ledleri kayd�rmak i�in
	sbis PINB,1		     ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ikiliorta       ;buton bas�lm��sa saat y�n�ne d�nmesini sa�layan fonksiyonu call ediyoruz
	brcs toplatersikiliorta ;carry biti varsa toplatersikiliorta fonksiyonuna gidiyoruz
	sbis PINB,2          ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ucluyapmatersorta ;buton bas�lm��sa ucluyapmatersorta fonksiyonuna s��r�yoruz
    brne ikilitersorta  ;Zero biti 0 ise ikiliorta fonksiyonuna gidiyoruz  

toplatersikiliorta:    ;ba�tan sona 2 li ge�me.
	or r17,r31         ;lojik veya i�lemi yapt�k
	clc                ;carry bitini temizliyoruz
	rjmp ikilitersorta ;ikilitersorta fonksiyonuna atl�yoruz

ucluyapmatersorta:    ;uclu yapma
	mov r24,r17       ;r17 de ki de�eri r24 e atad�k
	lsl r17           ;ledlerde kayd�rma yapt�k 
	or r17,r24        ;lojik veya i�lemi yapt�k
	rjmp uclutersorta ;uclutersorta fonksiyonuna atlad�k

ikilihizli:              ;iki led yanarken hizli saat y�n�nde ilerleyen fonksiyon
	out PORTC,r17 	     ;r17 deki degeri PORTB ye yaziyoruz.
	call waithizli       ;hizli h�z i�in gerekli fonksiyonu call ediyoruz
    sbis PINB,0          ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikiliyavas      ;butona bas�lm��sa h�z� en yava� yapan fonksiyona gider
    rol r17              ;ledleri kayd�rmak i�in
	sbis PINB,1		     ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ikilitershizli	 ;buton bas�lm��sa saat y�n�n�n tersine d�nmesini sa�layan fonksiyonu call ediyoruz
	brcs toplaikilihizli ;carry biti varsa toplaikilihizli fonksiyonuna gidiyoruz
	sbis PINB,2          ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ucluyapmahizli  ;buton bas�lm��sa ucluyapmahizli fonksiyonuna s��r�yoruz
    brne ikilihizli 	 ;Zero biti 0 ise ikiliorta fonksiyonuna gidiyoruz 
    
toplaikilihizli:     ;sondan ba�a ikili ge�mek i�in.
	or r17,r30       ;lojik veya i�lemi yapt�k
	clc              ;carry bitini temizliyoruz
	rjmp ikilihizli  ;ikilihizli fonksiyonuna atl�yoruz

ucluyapmahizli:      ;uclu yapma
	mov r24,r17      ;r17 de ki de�eri r24 e atad�k
	lsl r17          ;ledlerde kayd�rma yapt�k 
	or r17,r24       ;lojik veya i�lemi yapt�k
	rjmp ucluhizli   ;ucluhizli fonksiyonuna atlad�k

ikilitershizli:          ;iki led yanarken hizli saat y�n�n�n tersine ilerleyen fonksiyon
	out PORTC,r17 	     ; r17 deki degeri PORTB ye yaziyoruz.
	call waithizli       ;hizli h�z i�in gerekli fonksiyonu call ediyoruz
    sbis PINB,0          ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikilitersyavas  ;butona bas�lm��sa h�z� en yava� yapan fonksiyona gider
    ror r17              ;ledleri kayd�rmak i�in
	sbis PINB,1	         ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ikilihizli      ;buton bas�lm��sa saat y�n�n�n tersine d�nmesini sa�layan fonksiyonu call ediyoruz
	brcs toplatersikilihizli ;carry biti varsa toplaikilihizli fonksiyonuna gidiyoruz
	sbis PINB,2              ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ucluyapmatershizli  ;buton bas�lm��sa ucluyapmatershizli fonksiyonuna s��r�yoruz
    brne ikilitershizli      ;Zero biti 0 ise ikilitershizli fonksiyonuna gidiyoruz 

toplatersikilihizli:    ;ba�tan sona 2 li ge�me.
	or r17,r31          ;lojik veya i�lemi yapt�k
	clc                 ;carry bitini temizliyoruz
	rjmp ikilitershizli ;ikilitershizli fonksiyonuna atl�yoruz

ucluyapmatershizli:     ;uclu yapma
	mov r24,r17         ;r17 de ki de�eri r24 e atad�k
	lsl r17             ;ledlerde kayd�rma yapt�k 
	or r17,r24          ;lojik veya i�lemi yapt�k
	rjmp uclutershizli  ;uclutershizli fonksiyonuna atlad�k



ucluyavas:				; �cl� olarak ilerleryen fonksiyon
	out PORTC,r17		; r17 deki degeri PORTB ye yaziyoruz.
	call waityavas		;yavas h�z i�in gerekli fonksiyonu call ediyoruz
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ucluorta		;buton bas�lm��sa h�z� artt�r�yoruz
    rol r17				;ledleri kayd�rmak i�in
	sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp uclutersyavas	;PB6 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplaucluyavas ;carry biti 1 ise toplaucluyavas fonksiyonuna gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp dortluyapmayavas ; buton bas�lm��sa led say�s�n� 4l� yapmak i�in s��rama yap�yoruz
    brne ucluyavas 		;zero bitimiz s�f�r oldu�unda tekrar ba�tan ba�lamas� i�in ucluyavas fonksiyonuan gidiyoruz

toplaucluyavas:			;sondan ba�a �cl� ge�mek i�in.
	or r17,r30			;lojik veya i�lemi yapt�k
	clc					;carry bitini temizliyoruz
	rjmp ucluyavas		;uclu yavas fonkisyonuna s��r�yoruz

dortluyapmayavas:		;led say�s�n� 4 yapmak i�in kullan��m�z fonksiyon
	mov r24,r17			;r17 de ki de�eri r24 e atad�k
	lsl r17				;ledlerde kayd�rma yapt�k 
	or r17,r24			;lojik veya i�lemi yapt�k
	rjmp dortluyavas	;dortluyavas fonksiyonuna s��rama yap�yoruz

uclutersyavas:			;�Cl� saat y�n�n�n tersine giden fonksiyon
	out PORTC,r17 		;r17 deki degeri PORTB ye yaziyoruz.
	call waityavas		;yavas h�zda ilermek i�in gerekli fonksiyonu call ediyoruz
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call uclutersorta	;buton bas�lm��sa h�z� artt�ran fonksiyona gidiyoruz
    ror r17				;ledleri kayd�rmak i�in
	sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ucluyavas		;PB6 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplatersucluyavas ; carry biti 1 ise toplatersucluyavas fonksiyonuna gidiyoru
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp dortluyapmatersyavas ;buton bas�lm��sa dortluyapmatersyavas fonksiyonu ile led say�s�n� artt�r�yoruz
    brne uclutersyavas	;zero biti 1 ise fonksiyon tekrar kendini ba�tan ba�lat�yor

toplatersucluyavas:		;sondan ba�a ters �cl� ge�mek i�in.
	or r17,r31			;lojik veya i�lemi yapt�k
	clc					;carry bitini temizliyoruz
	rjmp uclutersyavas  ;uclu ters yavas fonkisyonuna s��r�yoruz

dortluyapmatersyavas:	;led say�s�n� 4 yapmak i�in kullan��m�z fonksiyon
	mov r24,r17			;r17 de ki de�eri r24 e atad�k
	lsl r17				;ledlerde kayd�rma yapt�k 
	or r17,r24			;lojik veya i�lemi yapt�k
	rjmp dortlutersyavas ;dortlutersyavas fonksiyonuna s��rama yap�yoruz



ucluorta:				;saat y�n�nde 3 led orta h�zda d�nen fonksiyon
	out PORTC,r17		;r17 deki degeri PORTB ye yaziyoruz.
	call waitorta		;orta h�zda ilerlemek i�in gerekli fonksiyonu call ediyoruz
    sbis PINB,0			; PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ucluhizli		;buton bas�lm��sa h�z� artt�racak olan fonksiyona gitmemize yar�yor
    rol r17				;ledleri kayd�rmak i�in
	sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp uclutersorta	;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplaucluorta  ;carry biti 1 ise topla uclu orta fonksiyonuna gidilecek
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp dortluyapmaorta ;PB2 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
    brne ucluorta 		; zero biti 1 ise foksiyonumuzu tekrarlamak i�in kulland���m�z komut

toplaucluorta:			;sondan ba�a �cl� ge�mek i�in.
	or r17,r30			;lojik veya i�lemi yapt�k
	clc					;carry bitini temizliyoruz
	rjmp ucluorta		;ucluorta fonksiyonuna s��rama yap�yoruz

dortluyapmaorta:		;led say�s�n� 4lemek i�in kullan�yoruz
	mov r24,r17			;r17 de ki de�eri r24 e atad�k
	lsl r17				;ledlerde kayd�rma yapt�k 
	or r17,r24			;lojik veya i�lemi yapt�k
	rjmp dortluyavas	;dortluyavas fonksiyonuna s��rama yap�yoruz

uclutersorta:			;saat y�n�n�n tersine 3 led orta h�zda d�nen fonksiyon
	out PORTC,r17		; r17 deki degeri PORTB ye yaziyoruz.
	call waitorta		;orta h�zda ilerlemek i�in gerekli fonksiyon call ediliyor
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call uclutershizli  ;buton bas�lm��sa h�z�m�z� art�ran fonksiyona call ediyoruz
    ror r17				;ledleri kayd�rmak i�in
	sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ucluorta		;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplatersucluorta ;carry biti 1 ise saat y�n�n�n tersine ilerleyen fonksiyona gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp dortluyapmatersorta ;buton bas�lm��sa led say�s�n� art�ran fonksiyona gidiyoruz
    brne uclutersorta	;zero biti 1 ise fonksiyonu tekrarlamak i�in

toplatersucluorta:		;sondan ba�a �cl� ge�mek i�in.
	or r17,r31			;lojik veya i�lemi yapt�k
	clc					;carry bitini temizliyoruz
	rjmp uclutersorta	;uclutersorta fonksiyonuna s��rama yap�yoruz

dortluyapmatersorta:	;led say�s�n� ters olarak 4lemek i�in kullan�yoruz
	mov r24,r17			;r17 de ki de�eri r24 e atad�k
	lsl r17				;ledlerde kayd�rma yapt�k 
	or r17,r24			;lojik veya i�lemi yapt�k
	rjmp dortlutersyavas ;dortlutersyavas fonksiyonuna s��rama yap�yoruz

ucluhizli:				;�c led saat y�n�nde h�zl� olarak ilerleyen fonksiyon 
	out PORTC,r17 		;r17 deki degeri PORTB ye yaziyoruz.
	call waithizli		;h�zl� olarak �al��mas� i�in gerekli h�z fonksiyonunu call ediyoruz
    sbis PINB,0			;PB pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ucluyavas		;buton bas�lm��sa yavas fonksiyonunu call ediyoruz
    rol r17				;ledleri kayd�rmak i�in
	sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp uclutershizli	;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplaucluhizli ;carry biti 1 ise toplaucluhizli fonksiyonuna gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp dortluyapmahizli ; buton bas�lm��sa led say�s�n� artt�ran fonksiyona cap�r�yoruz
    brne ucluhizli 		;zero biti 1 ise fonksiyonu tekrarlamak i�in

toplaucluhizli:			;sondan ba�a �cl� ge�mek i�in.
	or r17,r30			;lojik veya i�lemi yapt�k
	clc					;carry bitini temizliyoruz
	rjmp ucluhizli		;ucluhizli fonksiyonuna s��rama yap�yoruz

dortluyapmahizli:		; d�rtl� yapmak i�in kulland���m�z fonksiyon
	mov r24,r17			;r17 de ki de�eri r24 e atad�k
	lsl r17				;ledlerde kayd�rma yapt�k 
	or r17,r24			;lojik veya i�lemi yapt�k
	rjmp dortluhizli	;dortluhizli fonksiyonuna s��rama yap�yoruz

uclutershizli:			;�c led saat y�n�n�n tersine ilerleyen fonksiyon
	out PORTC,r17 		;r17 deki degeri PORTB ye yaziyoruz.
	call waithizli		;h�zl� olarak �al�cak olan fonksiyon call ediliyor
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call uclutersyavas	;buton bas�lm��sa saat yonunun tersine giden fonksiyon
    ror r17				;ledleri kayd�rmak i�in
	sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ucluhizli		;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplatersucluhizli ;carry biti 1 ise toplatersucluhizli fonksiyonuna gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp dortluyapmatershizli ;buton bas�lm��sa led say�s�n� art�ran fonksiyona gidiyoruz
    brne uclutershizli	;zero biti 1 ise fonksiyonu tekrarlamak i�in

toplatersucluhizli:		;sondan ba�a �cl� ge�mek i�in.
	or r17,r31			;lojik veya i�lemi yapt�k
	clc					;carry bitini temizliyoruz
	rjmp uclutershizli  ;uclutershizli fonksiyonuna s��rama yap�yoruz

dortluyapmatershizli:	; d�rtl� ters yapmak i�in kulland���m�z fonksiyon
	mov r24,r17			;r17 de ki de�eri r24 e atad�k
	lsl r17				;ledlerde kayd�rma yapt�k 
	or r17,r24			;lojik veya i�lemi yapt�k
	rjmp dortlutershizli ;dortlutershizli fonksiyonuna s��rama yap�yoruz




dortluyavas:                ;d�rt led saat y�n�nde ilerleyen fonksiyon
	out PORTC,r17 	        ; r17 deki degeri PORTB ye yaziyoruz.
	call waityavas          ;yavas olarak �al�cak olan fonksiyon call ediliyor
    sbis PINB,0		        ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call dortluorta         ;buton bas�lm��sa saat yonunde giden fonksiyon
    rol r17                 ;ledleri kayd�rmak i�in
	sbis PINB,1	            ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp dortlutersyavas    ;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs topladortluyavas   ;carry biti 1 ise topladortluyavas fonksiyonuna gidiyoruz
	sbis PINB,2               ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp tekyavasaindirme    ;buton bas�lm��sa led say�s�n� azaltan fonksiyona gidiyoruz
    brne dortluyavas 	     ;zero biti 1 ise fonksiyonu tekrarlamak i�in

topladortluyavas:      ;sondan ba�a dortlu ge�mek i�in.
	or r17,r30         ;lojik veya i�lemi yapt�k
	clc                ;carry bitini temizliyoruz
	rjmp dortluyavas  ;dortluyavas fonksiyonuna s��rama yap�yoruz

tekyavasaindirme:    ;tek yavas fonksiyonu i�in kulland���m�z fonksiyon
    mov r25,r17     ;r17 deki de�eri r25 e atamak i�in
	lsl r17         ;ledleri kayd�r�p 1 lede d���rmek i�in
	lsl r17         ;ledleri kayd�r�p 1 lede d���rmek i�in
	lsl r17         ;ledleri kayd�r�p 1 lede d���rmek i�in
	and r17,r25     ;tek led'e d���rmek i�in lojik ve i�lemi yap�yoruz
	lsr r17         ;ledler kald��� yerden devam etmesi i�in
	rjmp tekliyavas ;tekli yava� fonksiyonunu �a��r�yoruz

dortlutersyavas:	           ;d�rt led saat y�n�n�n tersine ilerleyen fonksiyon
	out PORTC,r17 	           ; r17 deki degeri PORTB ye yaziyoruz.
	call waityavas	           ;yavas olarak cal��mas� i�in gerekli olan fonksiyonu call ediyoruz
    sbis PINB,0		           ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call dortlutersorta        ;buton bas�lm��sa saat yonunun tersine giden fonksiyon
    ror r17                    ;ledleri kayd�rmak i�in
	sbis PINB,1	               ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp dortluyavas           ;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplatersdortluyavas  ;carry biti 1 ise toplatersdortluyavas fonksiyonuna gidiyoruz
	sbis PINB,2                ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp tektersyavasaindirme  ;buton bas�lm��sa led say�s�n� azaltan fonksiyona gidiyoruz
    brne dortlutersyavas  	   ;zero biti 1 ise fonksiyonu tekrarlamak i�in

toplatersdortluyavas:     ; ba�tan sona dortlu li ge�me.
	or r17,r31            ;lojik veya i�lemi yapt�k
	clc                   ;carry bitini temizliyoruz
	rjmp dortlutersyavas  ;dortlutersyavas fonksiyonuna s��rama yap�yoruz

tektersyavasaindirme:   ;tek yavas fonksiyonu i�in kulland���m�z fonksiyon
    mov r25,r17         ;r17 deki de�eri r25 e atamak i�in
	lsr r17             ;ledleri kayd�r�p 1 lede d���rmek i�in
	lsr r17             ;ledleri kayd�r�p 1 lede d���rmek i�in
	lsr r17             ;ledleri kayd�r�p 1 lede d���rmek i�in
	and r17,r25         ;tek led'e d���rmek i�in lojik ve i�lemi yap�yoruz
	lsl r17             ;ledler kald��� yerden devam etmesi i�in
	rjmp teklitersyavas ;tekli yava� fonksiyonunu �a��r�yoruz


dortluorta:                ;d�rt led saat y�n�nde ilerleyen fonksiyon
	out PORTC,r17 	       ; r17 deki degeri PORTB ye yaziyoruz.
	call waitorta          ;orta hizda cal��mas� i�in gerekli olan fonksiyonu call ediyoruz
    sbis PINB,0	           ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call dortluhizli       ;buton bas�lm��sa saat yonunde giden fonksiyon
    rol r17                ;ledleri kayd�rmak i�in
	sbis PINB,1	           ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp dortlutersorta    ;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs topladortluorta   ;carry biti 1 ise topladortluorta fonksiyonuna gidiyoruz
	sbis PINB,2            ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp tekortayaindirme  ;buton bas�lm��sa led say�s�n� azaltan fonksiyona gidiyoruz
    brne dortluorta  	   ;zero biti 1 ise fonksiyonu tekrarlamak i�in

topladortluorta:          ;sondan ba�a dortlu ge�mek i�in.
	or r17,r30            ;lojik veya i�lemi yapt�k
	clc                   ;carry bitini temizliyoruz
	rjmp dortluorta      ;dortluorta fonksiyonuna s��rama yap�yoruz

tekortayaindirme:  ;tek yavas fonksiyonu i�in kulland���m�z fonksiyon
    mov r25,r17    ;r17 deki de�eri r25 e atamak i�in
	lsl r17        ;ledleri kayd�r�p 1 lede d���rmek i�in
	lsl r17        ;ledleri kayd�r�p 1 lede d���rmek i�in
	lsl r17        ;ledleri kayd�r�p 1 lede d���rmek i�in
	and r17,r25    ;tek led'e d���rmek i�in lojik ve i�lemi yap�yoruz
	lsr r17        ;ledler kald��� yerden devam etmesi i�in
	rjmp tekliorta ;tekli yava� fonksiyonunu �a��r�yoruz


dortlutersorta:               ;d�rt led saat y�n�n�n tersine ilerleyen fonksiyon
	out PORTC,r17 	          ; r17 deki degeri PORTB ye yaziyoruz.
	call waitorta             ;orta hizda cal��mas� i�in gerekli olan fonksiyonu call ediyoruz
    sbis PINB,0	              ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call dortlutershizli      ;buton bas�lm��sa saat yonunun tersine giden fonksiyon
    ror r17                   ;ledleri kayd�rmak i�in
	sbis PINB,1	              ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp dortluorta           ;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplatersdortluorta  ;carry biti 1 ise toplatersdortluorta fonksiyonuna gidiyoruz
	sbis PINB,2               ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp teklitersortayaindirme     ;buton bas�lm��sa led say�s�n� azaltan fonksiyona gidiyoruz
    brne dortlutersorta   	   ;zero biti 1 ise fonksiyonu tekrarlamak i�in

toplatersdortluorta:      ; ba�tan sona dortlu ge�me.
	or r17,r31            ;lojik veya i�lemi yapt�k
	clc                   ;carry bitini temizliyoruz
	rjmp dortlutersorta   ;dortlutersorta fonksiyonuna s��rama yap�yoruz

teklitersortayaindirme:;tek yavas fonksiyonu i�in kulland���m�z fonksiyon
    mov r25,r17        ;r17 deki de�eri r25 e atamak i�in
	lsr r17            ;ledleri kayd�r�p 1 lede d���rmek i�in
	lsr r17            ;ledleri kayd�r�p 1 lede d���rmek i�in
	lsr r17            ;ledleri kayd�r�p 1 lede d���rmek i�in
	and r17,r25        ;tek led'e d���rmek i�in lojik ve i�lemi yap�yoruz
	lsl r17            ;ledler kald��� yerden devam etmesi i�in
	rjmp teklitersorta ;tekli yava� fonksiyonunu �a��r�yoruz

dortluhizli:               ;d�rt led saat y�n�nde ilerleyen fonksiyon
	out PORTC,r17 	       ; r17 deki degeri PORTB ye yaziyoruz.
	call waithizli         ;hizli cal��mas� i�in gerekli olan fonksiyonu call ediyoruz
    sbis PINB,0	           ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call dortluyavas       ;buton bas�lm��sa saat yonunde yavas giden fonksiyon
    rol r17                ;ledleri kayd�rmak i�in
	sbis PINB,1	           ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp dortlutershizli   ;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs topladortluhizli  ;carry biti 1 ise topladortluhizli fonksiyonuna gidiyoruz
	sbis PINB,2            ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp teklihizliyaindirme     ;buton bas�lm��sa led say�s�n� azaltan fonksiyona gidiyoruz
    brne dortluhizli   	   ;zero biti 1 ise fonksiyonu tekrarlamak i�in

topladortluhizli:     ;sondan ba�a dortlu ge�mek i�in.
	or r17,r30        ;lojik veya i�lemi yapt�k
	clc               ;carry bitini temizliyoruz
	rjmp dortluhizli  ;dortluhizli fonksiyonuna s��rama yap�yoruz

teklihizliyaindirme:;tek yavas fonksiyonu i�in kulland���m�z fonksiyon
    mov r25,r17     ;r17 deki de�eri r25 e atamak i�in
	lsl r17         ;ledleri kayd�r�p 1 lede d���rmek i�in
	lsl r17         ;ledleri kayd�r�p 1 lede d���rmek i�in
	lsl r17         ;ledleri kayd�r�p 1 lede d���rmek i�in
	and r17,r25     ;tek led'e d���rmek i�in lojik ve i�lemi yap�yoruz
	lsr r17         ;ledler kald��� yerden devam etmesi i�in
	rjmp teklihizli ;tekli yava� fonksiyonunu �a��r�yoruz
	 
dortlutershizli:            ;d�rt led saat y�n�n�n tersine ilerleyen fonksiyon
	out PORTC,r17 	        ; r17 deki degeri PORTB ye yaziyoruz.
	call waithizli          ;hizli cal��mas� i�in gerekli olan fonksiyonu call ediyoruz
    sbis PINB,0	            ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call dortlutersyavas    ;buton bas�lm��sa saat yonunun tersine yavas giden fonksiyon
    ror r17                 ;ledleri kayd�rmak i�in
	sbis PINB,1		        ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp dortluhizli        ;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplatersdortluhizli        ;carry biti 1 ise toplatersdortluhizli fonksiyonuna gidiyoruz
	sbis PINB,2                      ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp teklitershizliyaindirme     ;buton bas�lm��sa led say�s�n� azaltan fonksiyona gidiyoruz
    brne dortlutershizli    	     ;zero biti 1 ise fonksiyonu tekrarlamak i�in

toplatersdortluhizli:     ; ba�tan sona dortlu ge�me.
	or r17,r31            ;lojik veya i�lemi yapt�k
	clc                   ;carry bitini temizliyoruz
	rjmp dortlutershizli  ;dortlutershizli fonksiyonuna s��rama yap�yoruz

teklitershizliyaindirme:       ;tek yavas fonksiyonu i�in kulland���m�z fonksiyon
    mov r25,r17                ;r17 deki de�eri r25 e atamak i�in
	lsr r17                    ;ledleri kayd�r�p 1 lede d���rmek i�in
	lsr r17                    ;ledleri kayd�r�p 1 lede d���rmek i�in
	lsr r17                    ;ledleri kayd�r�p 1 lede d���rmek i�in
	and r17,r25                ;tek led'e d���rmek i�in lojik ve i�lemi yap�yoruz
	lsl r17                    ;ledler kald��� yerden devam etmesi i�in
	rjmp teklitershizli        ;tekli yava� fonksiyonunu �a��r�yoruz

waityavas:			; yavas  bekleme saglayan fonksiyonumuz
   push r16			; mainloop icerisinde kullandigimiz r16 ve r17 nin degerlerini wait icinde de kullanmak istiyoruz.
   push r17			; bu nedenle push komutunu kullanarak bu registerlarin icindeki degerleri yigina kaydediyoruz
   ldi r16,0x30 	; 0x0011 0000 kere dongu calistirilacak
   ldi r17,0x00	    ; ~12 milyon komut cycle i surecek
   ldi r18,0x01 	; 16Mhz calisma frekansi icin ~0.7s zaman gecikmesi elde edilecek
  
_w0:
   dec r18			; r18 deki degeri 1 azalt
   brne _w0			; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   dec r17			; r17 deki degeri 1 azalt
   brne _w0			; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   dec r16			; r16 daki degeri 1 azalt
   brne _w0			; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   pop r17			; fonksiyondan donmeden once en son push edilen r17 yi geri cek
   pop r16			; r16 yi geri cek
   ret				; fonksiyondan geri don

waitorta:			; orta bekleme saglayan fonksiyonumuz
    push r16		; mainloop icerisinde kullandigimiz r16 ve r17 nin degerlerini wait icinde de kullanmak istiyoruz.
   push r17			; bu nedenle push komutunu kullanarak bu registerlarin icindeki degerleri yigina kaydediyoruz
   ldi r16,0x15 	; 0x0001 0101 kere dongu calistirilacak
   ldi r17,0x00 	; ~12 milyon komut cycle i surecek
   ldi r18,0x01 	; 16Mhz calisma frekansi icin ~0.7s zaman gecikmesi elde edilecek
_w1:
   dec r18			; r18 deki degeri 1 azalt
   brne _w1			; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   dec r17			; r17 deki degeri 1 azalt
   brne _w1			; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   dec r16			; r16 daki degeri 1 azalt
   brne _w1			; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   pop r17			; fonksiyondan donmeden once en son push edilen r17 yi geri cek
   pop r16			; r16 yi geri cek
   ret				; fonksiyondan geri don


waithizli:			;h�zl� bekleme saglayan fonksiyonumuz
   push r16			; mainloop icerisinde kullandigimiz r16 ve r17 nin degerlerini wait icinde de kullanmak istiyoruz.
   push r17			; bu nedenle push komutunu kullanarak bu registerlarin icindeki degerleri yigina kaydediyoruz
   ldi r16,0x08		; 0x0000 1000 kere dongu calistirilacak
   ldi r17,0x00 	; ~12 milyon komut cycle i surecek
   ldi r18,0x01 	; 16Mhz calisma frekansi icin ~0.7s zaman gecikmesi elde edilecek
_w2:
   dec r18			; r18 deki degeri 1 azalt
   brne _w2			; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   dec r17			; r17 deki degeri 1 azalt
   brne _w2			; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   dec r16			; r16 daki degeri 1 azalt
   brne _w2			; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   pop r17			; fonksiyondan donmeden once en son push edilen r17 yi geri cek
   pop r16			; r16 yi geri cek
   ret				; fonksiyondan geri don