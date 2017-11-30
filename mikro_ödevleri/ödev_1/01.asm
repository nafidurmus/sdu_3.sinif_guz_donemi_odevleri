;Ahmet Demirel 1321012052,  Nafi Durmuþ 1411012027, Sefa Emrahoðlu 1411012016
.org 0
    rjmp tanimlamalar
tanimlamalar:			;ilk baþta gerekli tanýmlamalarý yaptðýmýz fonksiyon
    ldi r16,0xFF	    ; 0xxFF 1111 1111 -> PORTCyi output yapmak istiyoruz, o nedenle tüm bitler 1
    out DDRC,r16		; PortC nin data direction registeri DDRC ye r16 daki degeri yaziyoruz
    ldi r17,0x01		;baþlangýc için ilk ledin yanmasý için 0000 0001 deðerini yüklüyoruz
    ldi r19,0x00 		; 0x00=0010 0000 -> PORTB nin tüm pinlerini input yapmak istiyoruz, o nedenle 0000 0000 yükledik 
	ldi r30,0x01		;rol de elde biti için kullanýyoruz
	ldi r31,0x80		;ror da elde biti için kullanýyoruz
    out DDRB,r19	    ; PortB nin data direction registeri DDRB ye r19 daki degeri yaziyoruz
    sbi PORTB,0			; PB0 nin pull-up direncini aktiflestiriyoruz. artik butona basilmadiginda 1, basilinca 0 okuyacagiz
    sbi PORTB,1			; PB1 nin pull-up direncini aktiflestiriyoruz. artik butona basilmadiginda 1, basilinca 0 okuyacagiz
    sbi PORTB,2         ; PB2 nin pull-up direncini aktiflestiriyoruz. artik butona basilmadiginda 1, basilinca 0 okuyacagiz

main:					; tek led yanarken tekrar 1. ledden baþlamasý için 0x01 yüklemeyi tekrarladýk
    ldi r17,0x01

tekliyavas:				;tek ledde saat yönünde yavaþ olarak ilerleyen fonksiyon
    out PORTC,r17 		;r17 deki degeri PORTC ye yaziyoruz.
	call waityavas		;yavaþ hýzda ilerlemesi için gerekli fonksiyon
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    call tekliorta		;buton basýlmýþsa gidicelecek olan fonksiyon
    lsl r17				;saat yönünde ledleri kaydýrmak için
    sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp teklitersyavas	;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikiliyapmayavas ;ledlerin ikili olarak kaymasýný saðlayan fonksiyonu call ediyoruz
    brne tekliyavas 	;zerro biti sýfýr ise dallanacak yani tekliyavas fonksiyonu tekrar çalýþacak 
    rjmp main			;zero biti sýfýr olduðunda tekrar baþtan baþlamasý için maine sýçradýk

ikiliyapmayavas:		;Yavas hýzda ikili olarak ilerleme
	mov r24,r17			;r17 deki deðeri r24 e atýyoruz
	lsl r17				;r17yi kaydýrdýk
	or r17,r24			;r24 ile r17 nin yeni deðerini or yaparak iki ledin yanmasýný saðladýk
	rjmp ikiliyavas		;ikiliyavas fonksiyonuna sýçradýk


teklitersyavas:			;saat yönünün tersine ilerlemek için gerekli fonksiyon
    out PORTC,r17		;r17 deki degeri PORTC ye yaziyoruz.
    lsr r17				;saat yönünün tersine ledleri kaydýrmak için
    call waityavas 		;yavaþ hýzda ilerlemesi için gerekli fonksiyon
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    call teklitersorta	;hýz kontrol butonu basýlmýþsa orta hýzlý olan fonksiyona gidiyoruz
    sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp tekliyavas		;yönü kontrol eden buton basýlmýþsa gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ikilitersyapmayavas ;led sayýsýný kontrol eden buton basýlmýþsa 
    BRCS GERI			;carry biti 1 ise geri fonksiyonuna dallanacak
    rjmp teklitersyavas	;carry biti 0 ise fonksiyon tekrarlanacak

GERI:					;tersten tekrar baþlamak için 0001 0000 yüklemesi yapýyoruz
    ldi r17,0x80
    call teklitersyavas ;yüklemeden sonra tekrar fonksiyona gidiyoruz

ikilitersyapmayavas:	;ikili olarak saat yönünün tersine yavas fonksiyon
	mov r24,r17			;r17 deki deðeri r24 e atýyoruz
	lsr r17				;r17yi kaydýrdýk
	or r17,r24			;r24 ile r17 nin yeni deðerini or yaparak iki ledin yanmasýný saðladýk
	rjmp ikilitersyavas ;led sayýsýný ikili yaptýk ve kayma iþlemi için ikilitersyavas fonksiyonuna sýçrýyoruz

main2:					; tek led orta hýzda yanarken tekrar 1. ledden baþlamasý için 0x01 yüklemeyi tekrarladýk
    ldi r17,0x01

tekliorta:				;tek led orta hýzda ilerlerkenki
	out PORTC,r17 		;r17 deki degeri PORTC ye yaziyoruz.
	call waitorta		;gecikme için gereki fonksiyonu call ediyoruz
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    call teklihizli		;hýz butonu basýlmýþsa hizlanma fonksiyonunu call ediyoruz
    lsl r17				;orta hýzda kayma iþlemleri yapýlýyor
    sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp teklitersorta	;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir 
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ikiliyapmaorta	;led sayýsý butonu basýlmýþsa ikili yapma fonksiyonuna sýçrýyoruz
	brne tekliorta 		;zerro biti sýfýr ise dallanacak yani tekliorta fonksiyonu tekrar çalýþacak 
    rjmp main2			;tekrar baþtan baþlamak için main2 ye sýçrýyoruz

ikiliyapmaorta:			;Yavas hýzda ikili olarak ilerleme
	mov r24,r17			;r17 deki deðeri r24 e atýyoruz
	lsl r17				;r17yi kaydýrdýk
	or r17,r24			;r24 ile r17 nin yeni deðerini or yaparak iki ledin yanmasýný saðladýk
	rjmp ikiliorta		;ikiliorta fonksiyonuna sýçradýk

teklitersorta:			;orta hýzda tekled yanarak saat yönünün tersine giden fonksiyon
    out PORTC,r17		;r17 deki degeri PORTC ye yaziyoruz.
    lsr r17				;ledleri kaydýrma iþlemini yapýyoruz
    call waitorta 		;orta hýzda ilermesi için gerekli gecikme fonksiyonunu call ediyoruz
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    call teklitershizli ; buton basýlmýþsa hýzlý fonksiyona gidiyoruz
    sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp tekliorta		;buton basýlmýþsa saat yönüne gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ikilitersyapmaorta ; buton basýlmýþsa led sayýsýný artýrmak için gerekli fonksiyonu call ediyoruz
	BRCS GERI1			;carry biti varsa geri1 fonksiyonuna gidiyoruz
    rjmp teklitersorta	;carry yoksa fonksiyonu tekrarlýyoruz

ikilitersyapmaorta:		;orta hýzda saat yönünün tersine çalýþan fonksiyon
	mov r24,r17			;r17 deki deðeri r24 e atýyoruz
	lsl r17				;r17yi kaydýrdýk
	or r17,r24			;r24 ile r17 nin yeni deðerini or yaparak iki ledin yanmasýný saðladýk
	rjmp ikilitersorta  ;ikilitersorta fonksiyonuna sýçradýk

GERI1:					;fonksiyon tekrar baþtan yanmasý için 0001 0000 yüklemesi yapýyoruz
    ldi r17,0x80
    call teklitersorta

main3:					;fonksiyon tekrar baþtan yanmasý için 0000 0001 yüklemesi yapýyoruz
	ldi r17,0x01

teklihizli:				;tek led saat yönünde hýzlý ilerlerken 
	out PORTC,r17		;r17 deki degeri PORTC ye yaziyoruz.
	call waithizli		;bekleme fonksiyonunu call ediyoruz
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    call tekliyavas		;buton basýlmýþsa yavaþlama fonksiyonuna gidiyoruz
    lsl r17				;ledlerin kaymasý için kullanýyoruz
    sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp teklitershizli	;buton basýlmýþsa saat yönünün tersine dönmesini saðlayan fonksiyonu call ediyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ikiliyapmahizli ;buton basýlmýþsa led sayýsýný arttýran fonksiyona gidiyoruz
	brne teklihizli 	;zero biti sýfýr ise dallanacak yani teklihizl fonksiyonu tekrar çalýþacak
    rjmp main3			;zero biti sýfýr deðilse ledler tekrardan yanmasý için kullanýyoruz

ikiliyapmahizli:		;saat yönünde hýzlý olarak led sayýsýný arttýrrýyoruz
	mov r24,r17			;r17 deki deðeri r24 e atýyoruz
	lsl r17				;r17yi kaydýrdýk
	or r17,r24			;r24 ile r17 nin yeni deðerini or yaparak iki ledin yanmasýný saðladýk
	rjmp ikilihizli		;ikilihizli fonksiyonuna sýçradýk

teklitershizli:			;tek led ile saat yönünün tersine ilerlemek için
    out PORTC,r17		;r17 deki degeri PORTC ye yaziyoruz.
    lsr r17				;ledleri kaydýrma iþlemini yapýyoruz
    call waithizli 		;gecikme fonksiyonunu call ediyoruz
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    call teklitersyavas ;buton basýlmýþsa yavaslamak için gerekli fonksiyona gidiyoruz
    sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp teklihizli		;buton basýlmýþsa saat yönüne gitmek için kullandýðýmýz fonksiyona sýçrýyoruz
    BRCS GERI2			;carry biti varsa geri2 fonksiyonuna gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ikilitersyapmahizli ;buton basýlmýþsa ikilitersyapmahizli fonksiyonuna sýçrýyoruz
    rjmp teklitershizli ;buton kontrollerinden sonra tekrar fonksiyona sýçrýyoruz

GERI2:					;tersten tekrar devam etmesi için 0001 0000 yüklemesi yapýyoruz
    ldi r17,0x80
    call teklitershizli	

ikilitersyapmahizli:	;saat yönünün tersine gitmek için kullandýðýmýz fonksiyon
	mov r24,r17			;r17 deki deðeri r24 e atýyoruz
	lsl r17				;r17yi kaydýrdýk
	or r17,r24			;r24 ile r17 nin yeni deðerini or yaparak iki ledin yanmasýný saðladýk
	rjmp ikilitershizli ;ikilitershizli fonksiyonuna sýçradýk




ikiliyavas:				 ;iki led yanarken yavas hýzda saat yönünde ilerleyen fonksiyon
	out PORTC,r17 		 ;r17 deki degeri PORTB ye yaziyoruz.
	call waityavas		 ;yavaþ için gerekli fonksiyonu call ediyoruz
    sbis PINB,0			 ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikiliorta       ;butona basýlmýþsa hýzý bir kademe arttýran fonksiyona gider
    rol r17              ;ledleri kaydýrmak için
	sbis PINB,1		     ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ikilitersyavas	 ;buton basýlmýþsa saat yönünün tersine dönmesini saðlayan fonksiyonu call ediyoruz
	brcs toplaikiliyavas ;carry biti varsa toplaikiliyavas fonksiyonuna gidiyoruz
	sbis PINB,2          ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ucluyapmayavas  ;buton basýlmýþsa ucluyapmayavas fonksiyonuna sýçrýyoruz
    brne ikiliyavas 	 ;Zero biti 0 ise ikiliyavas fonksiyonuna gidiyoruz
    
toplaikiliyavas:         ;sondan baþa ikili geçmek için.
	or r17,r30           ;lojik veya iþlemi yaptýk
	clc                  ;carry bitini temizliyoruz
	rjmp ikiliyavas      ;ikiliyavas fonksiyonuna atlýyoruz

ucluyapmayavas:         ;uclu yapma
	mov r24,r17         ;r17 de ki deðeri r24 e atadýk
	lsl r17             ;ledlerde kaydýrma yaptýk 
	or r17,r24          ;lojik veya iþlemi yaptýk
	rjmp ucluyavas      ;ucluyavas fonksiyonuna atladýk


ikilitersyavas:              ;iki led yanarken yavas hýzda saat yönünün tersine ilerleyen fonksiyon
	out PORTC,r17 	         ; r17 deki degeri PORTB ye yaziyoruz.
	call waityavas           ;yavaþ için gerekli fonksiyonu call ediyoruz
    sbis PINB,0              ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikilitersorta       ;butona basýlmýþsa hýzý bir kademe arttýran fonksiyona gider
    ror r17                  ;ledleri kaydýrmak için
	sbis PINB,1		         ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ikiliyavas          ;buton basýlmýþsa saat yönüne dönmesini saðlayan fonksiyonu call ediyoruz
	brcs toplatersikiliyavas ;carry biti varsa toplaikiliyavas fonksiyonuna gidiyoruz
	sbis PINB,2              ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp uclutersyapmayavas  ;buton basýlmýþsa uclutersyapmayavas fonksiyonuna sýçrýyoruz
    brne ikilitersyavas      ;Zero biti 0 ise ikilitersyavas fonksiyonuna gidiyoruz

toplatersikiliyavas:       ;baþtan sona ikili geçmek için.
	or r17,r31             ;lojik veya iþlemi yaptýk
	clc                    ;carry bitini temizliyoruz
	rjmp ikilitersyavas    ;ikilitersyavas fonksiyonuna atlýyoruz

uclutersyapmayavas:      ;uclu yapma
	mov r24,r17          ;r17 de ki deðeri r24 e atadýk
	lsl r17              ;ledlerde kaydýrma yaptýk 
	or r17,r24           ;lojik veya iþlemi yaptýk
	rjmp uclutersyavas   ;uclutersyavas fonksiyonuna atladýk

ikiliorta:               ;iki led yanarken orta hýzda saat yönünde ilerleyen fonksiyon
	out PORTC,r17 	     ;r17 deki degeri PORTB ye yaziyoruz.
	call waitorta        ;orta hýz için gerekli fonksiyonu call ediyoruz
    sbis PINB,0          ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikilihizli      ;butona basýlmýþsa hýzý bir kademe arttýran fonksiyona gider
    rol r17              ;ledleri kaydýrmak için
	sbis PINB,1		     ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ikilitersorta	 ;buton basýlmýþsa saat yönününtersine dönmesini saðlayan fonksiyonu call ediyoruz
	brcs toplaikiliorta  ;carry biti varsa toplaikiliorta fonksiyonuna gidiyoruz
	sbis PINB,2          ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ucluyapmaorta   ;buton basýlmýþsa ucluyapmaorta fonksiyonuna sýçrýyoruz
    brne ikiliorta 	     ;Zero biti 0 ise ikiliorta fonksiyonuna gidiyoruz
    
toplaikiliorta:          ;sondan baþa ikili geçmek için.
	or r17,r30           ;lojik veya iþlemi yaptýk
	clc                  ;carry bitini temizliyoruz
	rjmp ikiliorta       ;ikiliorta fonksiyonuna atlýyoruz

ucluyapmaorta:           ;uclu yapma
	mov r24,r17          ;r17 de ki deðeri r24 e atadýk
	lsl r17              ;ledlerde kaydýrma yaptýk 
	or r17,r24           ;lojik veya iþlemi yaptýk
	rjmp ucluorta        ;ucluorta fonksiyonuna atladýk


ikilitersorta:           ;iki led yanarken orta hýzda saat yönünün tersine ilerleyen fonksiyon
	out PORTC,r17 	     ;r17 deki degeri PORTB ye yaziyoruz.
	call waitorta        ;orta hýz için gerekli fonksiyonu call ediyoruz
    sbis PINB,0          ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikilitershizli  ;butona basýlmýþsa hýzý bir kademe arttýran fonksiyona gider
    ror r17              ;ledleri kaydýrmak için
	sbis PINB,1		     ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ikiliorta       ;buton basýlmýþsa saat yönüne dönmesini saðlayan fonksiyonu call ediyoruz
	brcs toplatersikiliorta ;carry biti varsa toplatersikiliorta fonksiyonuna gidiyoruz
	sbis PINB,2          ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ucluyapmatersorta ;buton basýlmýþsa ucluyapmatersorta fonksiyonuna sýçrýyoruz
    brne ikilitersorta  ;Zero biti 0 ise ikiliorta fonksiyonuna gidiyoruz  

toplatersikiliorta:    ;baþtan sona 2 li geçme.
	or r17,r31         ;lojik veya iþlemi yaptýk
	clc                ;carry bitini temizliyoruz
	rjmp ikilitersorta ;ikilitersorta fonksiyonuna atlýyoruz

ucluyapmatersorta:    ;uclu yapma
	mov r24,r17       ;r17 de ki deðeri r24 e atadýk
	lsl r17           ;ledlerde kaydýrma yaptýk 
	or r17,r24        ;lojik veya iþlemi yaptýk
	rjmp uclutersorta ;uclutersorta fonksiyonuna atladýk

ikilihizli:              ;iki led yanarken hizli saat yönünde ilerleyen fonksiyon
	out PORTC,r17 	     ;r17 deki degeri PORTB ye yaziyoruz.
	call waithizli       ;hizli hýz için gerekli fonksiyonu call ediyoruz
    sbis PINB,0          ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikiliyavas      ;butona basýlmýþsa hýzý en yavaþ yapan fonksiyona gider
    rol r17              ;ledleri kaydýrmak için
	sbis PINB,1		     ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ikilitershizli	 ;buton basýlmýþsa saat yönünün tersine dönmesini saðlayan fonksiyonu call ediyoruz
	brcs toplaikilihizli ;carry biti varsa toplaikilihizli fonksiyonuna gidiyoruz
	sbis PINB,2          ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ucluyapmahizli  ;buton basýlmýþsa ucluyapmahizli fonksiyonuna sýçrýyoruz
    brne ikilihizli 	 ;Zero biti 0 ise ikiliorta fonksiyonuna gidiyoruz 
    
toplaikilihizli:     ;sondan baþa ikili geçmek için.
	or r17,r30       ;lojik veya iþlemi yaptýk
	clc              ;carry bitini temizliyoruz
	rjmp ikilihizli  ;ikilihizli fonksiyonuna atlýyoruz

ucluyapmahizli:      ;uclu yapma
	mov r24,r17      ;r17 de ki deðeri r24 e atadýk
	lsl r17          ;ledlerde kaydýrma yaptýk 
	or r17,r24       ;lojik veya iþlemi yaptýk
	rjmp ucluhizli   ;ucluhizli fonksiyonuna atladýk

ikilitershizli:          ;iki led yanarken hizli saat yönünün tersine ilerleyen fonksiyon
	out PORTC,r17 	     ; r17 deki degeri PORTB ye yaziyoruz.
	call waithizli       ;hizli hýz için gerekli fonksiyonu call ediyoruz
    sbis PINB,0          ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ikilitersyavas  ;butona basýlmýþsa hýzý en yavaþ yapan fonksiyona gider
    ror r17              ;ledleri kaydýrmak için
	sbis PINB,1	         ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ikilihizli      ;buton basýlmýþsa saat yönünün tersine dönmesini saðlayan fonksiyonu call ediyoruz
	brcs toplatersikilihizli ;carry biti varsa toplaikilihizli fonksiyonuna gidiyoruz
	sbis PINB,2              ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp ucluyapmatershizli  ;buton basýlmýþsa ucluyapmatershizli fonksiyonuna sýçrýyoruz
    brne ikilitershizli      ;Zero biti 0 ise ikilitershizli fonksiyonuna gidiyoruz 

toplatersikilihizli:    ;baþtan sona 2 li geçme.
	or r17,r31          ;lojik veya iþlemi yaptýk
	clc                 ;carry bitini temizliyoruz
	rjmp ikilitershizli ;ikilitershizli fonksiyonuna atlýyoruz

ucluyapmatershizli:     ;uclu yapma
	mov r24,r17         ;r17 de ki deðeri r24 e atadýk
	lsl r17             ;ledlerde kaydýrma yaptýk 
	or r17,r24          ;lojik veya iþlemi yaptýk
	rjmp uclutershizli  ;uclutershizli fonksiyonuna atladýk



ucluyavas:				; üclü olarak ilerleryen fonksiyon
	out PORTC,r17		; r17 deki degeri PORTB ye yaziyoruz.
	call waityavas		;yavas hýz için gerekli fonksiyonu call ediyoruz
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ucluorta		;buton basýlmýþsa hýzý arttýrýyoruz
    rol r17				;ledleri kaydýrmak için
	sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp uclutersyavas	;PB6 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplaucluyavas ;carry biti 1 ise toplaucluyavas fonksiyonuna gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp dortluyapmayavas ; buton basýlmýþsa led sayýsýný 4lü yapmak için sýçrama yapýyoruz
    brne ucluyavas 		;zero bitimiz sýfýr olduðunda tekrar baþtan baþlamasý için ucluyavas fonksiyonuan gidiyoruz

toplaucluyavas:			;sondan baþa üclü geçmek için.
	or r17,r30			;lojik veya iþlemi yaptýk
	clc					;carry bitini temizliyoruz
	rjmp ucluyavas		;uclu yavas fonkisyonuna sýçrýyoruz

dortluyapmayavas:		;led sayýsýný 4 yapmak için kullanðýmýz fonksiyon
	mov r24,r17			;r17 de ki deðeri r24 e atadýk
	lsl r17				;ledlerde kaydýrma yaptýk 
	or r17,r24			;lojik veya iþlemi yaptýk
	rjmp dortluyavas	;dortluyavas fonksiyonuna sýçrama yapýyoruz

uclutersyavas:			;ÜClü saat yönünün tersine giden fonksiyon
	out PORTC,r17 		;r17 deki degeri PORTB ye yaziyoruz.
	call waityavas		;yavas hýzda ilermek için gerekli fonksiyonu call ediyoruz
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call uclutersorta	;buton basýlmýþsa hýzý arttýran fonksiyona gidiyoruz
    ror r17				;ledleri kaydýrmak için
	sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ucluyavas		;PB6 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplatersucluyavas ; carry biti 1 ise toplatersucluyavas fonksiyonuna gidiyoru
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp dortluyapmatersyavas ;buton basýlmýþsa dortluyapmatersyavas fonksiyonu ile led sayýsýný arttýrýyoruz
    brne uclutersyavas	;zero biti 1 ise fonksiyon tekrar kendini baþtan baþlatýyor

toplatersucluyavas:		;sondan baþa ters üclü geçmek için.
	or r17,r31			;lojik veya iþlemi yaptýk
	clc					;carry bitini temizliyoruz
	rjmp uclutersyavas  ;uclu ters yavas fonkisyonuna sýçrýyoruz

dortluyapmatersyavas:	;led sayýsýný 4 yapmak için kullanðýmýz fonksiyon
	mov r24,r17			;r17 de ki deðeri r24 e atadýk
	lsl r17				;ledlerde kaydýrma yaptýk 
	or r17,r24			;lojik veya iþlemi yaptýk
	rjmp dortlutersyavas ;dortlutersyavas fonksiyonuna sýçrama yapýyoruz



ucluorta:				;saat yönünde 3 led orta hýzda dönen fonksiyon
	out PORTC,r17		;r17 deki degeri PORTB ye yaziyoruz.
	call waitorta		;orta hýzda ilerlemek için gerekli fonksiyonu call ediyoruz
    sbis PINB,0			; PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ucluhizli		;buton basýlmýþsa hýzý arttýracak olan fonksiyona gitmemize yarýyor
    rol r17				;ledleri kaydýrmak için
	sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp uclutersorta	;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplaucluorta  ;carry biti 1 ise topla uclu orta fonksiyonuna gidilecek
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp dortluyapmaorta ;PB2 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
    brne ucluorta 		; zero biti 1 ise foksiyonumuzu tekrarlamak için kullandýðýmýz komut

toplaucluorta:			;sondan baþa üclü geçmek için.
	or r17,r30			;lojik veya iþlemi yaptýk
	clc					;carry bitini temizliyoruz
	rjmp ucluorta		;ucluorta fonksiyonuna sýçrama yapýyoruz

dortluyapmaorta:		;led sayýsýný 4lemek için kullanýyoruz
	mov r24,r17			;r17 de ki deðeri r24 e atadýk
	lsl r17				;ledlerde kaydýrma yaptýk 
	or r17,r24			;lojik veya iþlemi yaptýk
	rjmp dortluyavas	;dortluyavas fonksiyonuna sýçrama yapýyoruz

uclutersorta:			;saat yönünün tersine 3 led orta hýzda dönen fonksiyon
	out PORTC,r17		; r17 deki degeri PORTB ye yaziyoruz.
	call waitorta		;orta hýzda ilerlemek için gerekli fonksiyon call ediliyor
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call uclutershizli  ;buton basýlmýþsa hýzýmýzý artýran fonksiyona call ediyoruz
    ror r17				;ledleri kaydýrmak için
	sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ucluorta		;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplatersucluorta ;carry biti 1 ise saat yönünün tersine ilerleyen fonksiyona gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp dortluyapmatersorta ;buton basýlmýþsa led sayýsýný artýran fonksiyona gidiyoruz
    brne uclutersorta	;zero biti 1 ise fonksiyonu tekrarlamak için

toplatersucluorta:		;sondan baþa üclü geçmek için.
	or r17,r31			;lojik veya iþlemi yaptýk
	clc					;carry bitini temizliyoruz
	rjmp uclutersorta	;uclutersorta fonksiyonuna sýçrama yapýyoruz

dortluyapmatersorta:	;led sayýsýný ters olarak 4lemek için kullanýyoruz
	mov r24,r17			;r17 de ki deðeri r24 e atadýk
	lsl r17				;ledlerde kaydýrma yaptýk 
	or r17,r24			;lojik veya iþlemi yaptýk
	rjmp dortlutersyavas ;dortlutersyavas fonksiyonuna sýçrama yapýyoruz

ucluhizli:				;üc led saat yönünde hýzlý olarak ilerleyen fonksiyon 
	out PORTC,r17 		;r17 deki degeri PORTB ye yaziyoruz.
	call waithizli		;hýzlý olarak çalýþmasý için gerekli hýz fonksiyonunu call ediyoruz
    sbis PINB,0			;PB pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call ucluyavas		;buton basýlmýþsa yavas fonksiyonunu call ediyoruz
    rol r17				;ledleri kaydýrmak için
	sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp uclutershizli	;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplaucluhizli ;carry biti 1 ise toplaucluhizli fonksiyonuna gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp dortluyapmahizli ; buton basýlmýþsa led sayýsýný arttýran fonksiyona capýrýyoruz
    brne ucluhizli 		;zero biti 1 ise fonksiyonu tekrarlamak için

toplaucluhizli:			;sondan baþa üclü geçmek için.
	or r17,r30			;lojik veya iþlemi yaptýk
	clc					;carry bitini temizliyoruz
	rjmp ucluhizli		;ucluhizli fonksiyonuna sýçrama yapýyoruz

dortluyapmahizli:		; dörtlü yapmak için kullandýðýmýz fonksiyon
	mov r24,r17			;r17 de ki deðeri r24 e atadýk
	lsl r17				;ledlerde kaydýrma yaptýk 
	or r17,r24			;lojik veya iþlemi yaptýk
	rjmp dortluhizli	;dortluhizli fonksiyonuna sýçrama yapýyoruz

uclutershizli:			;üc led saat yönünün tersine ilerleyen fonksiyon
	out PORTC,r17 		;r17 deki degeri PORTB ye yaziyoruz.
	call waithizli		;hýzlý olarak çalýcak olan fonksiyon call ediliyor
    sbis PINB,0			;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call uclutersyavas	;buton basýlmýþsa saat yonunun tersine giden fonksiyon
    ror r17				;ledleri kaydýrmak için
	sbis PINB,1			;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp ucluhizli		;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplatersucluhizli ;carry biti 1 ise toplatersucluhizli fonksiyonuna gidiyoruz
	sbis PINB,2			;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp dortluyapmatershizli ;buton basýlmýþsa led sayýsýný artýran fonksiyona gidiyoruz
    brne uclutershizli	;zero biti 1 ise fonksiyonu tekrarlamak için

toplatersucluhizli:		;sondan baþa üclü geçmek için.
	or r17,r31			;lojik veya iþlemi yaptýk
	clc					;carry bitini temizliyoruz
	rjmp uclutershizli  ;uclutershizli fonksiyonuna sýçrama yapýyoruz

dortluyapmatershizli:	; dörtlü ters yapmak için kullandýðýmýz fonksiyon
	mov r24,r17			;r17 de ki deðeri r24 e atadýk
	lsl r17				;ledlerde kaydýrma yaptýk 
	or r17,r24			;lojik veya iþlemi yaptýk
	rjmp dortlutershizli ;dortlutershizli fonksiyonuna sýçrama yapýyoruz




dortluyavas:                ;dört led saat yönünde ilerleyen fonksiyon
	out PORTC,r17 	        ; r17 deki degeri PORTB ye yaziyoruz.
	call waityavas          ;yavas olarak çalýcak olan fonksiyon call ediliyor
    sbis PINB,0		        ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call dortluorta         ;buton basýlmýþsa saat yonunde giden fonksiyon
    rol r17                 ;ledleri kaydýrmak için
	sbis PINB,1	            ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp dortlutersyavas    ;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs topladortluyavas   ;carry biti 1 ise topladortluyavas fonksiyonuna gidiyoruz
	sbis PINB,2               ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp tekyavasaindirme    ;buton basýlmýþsa led sayýsýný azaltan fonksiyona gidiyoruz
    brne dortluyavas 	     ;zero biti 1 ise fonksiyonu tekrarlamak için

topladortluyavas:      ;sondan baþa dortlu geçmek için.
	or r17,r30         ;lojik veya iþlemi yaptýk
	clc                ;carry bitini temizliyoruz
	rjmp dortluyavas  ;dortluyavas fonksiyonuna sýçrama yapýyoruz

tekyavasaindirme:    ;tek yavas fonksiyonu için kullandýðýmýz fonksiyon
    mov r25,r17     ;r17 deki deðeri r25 e atamak için
	lsl r17         ;ledleri kaydýrýp 1 lede düþürmek için
	lsl r17         ;ledleri kaydýrýp 1 lede düþürmek için
	lsl r17         ;ledleri kaydýrýp 1 lede düþürmek için
	and r17,r25     ;tek led'e düþürmek için lojik ve iþlemi yapýyoruz
	lsr r17         ;ledler kaldýðý yerden devam etmesi için
	rjmp tekliyavas ;tekli yavaþ fonksiyonunu çaðýrýyoruz

dortlutersyavas:	           ;dört led saat yönünün tersine ilerleyen fonksiyon
	out PORTC,r17 	           ; r17 deki degeri PORTB ye yaziyoruz.
	call waityavas	           ;yavas olarak calýþmasý için gerekli olan fonksiyonu call ediyoruz
    sbis PINB,0		           ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call dortlutersorta        ;buton basýlmýþsa saat yonunun tersine giden fonksiyon
    ror r17                    ;ledleri kaydýrmak için
	sbis PINB,1	               ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp dortluyavas           ;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplatersdortluyavas  ;carry biti 1 ise toplatersdortluyavas fonksiyonuna gidiyoruz
	sbis PINB,2                ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp tektersyavasaindirme  ;buton basýlmýþsa led sayýsýný azaltan fonksiyona gidiyoruz
    brne dortlutersyavas  	   ;zero biti 1 ise fonksiyonu tekrarlamak için

toplatersdortluyavas:     ; baþtan sona dortlu li geçme.
	or r17,r31            ;lojik veya iþlemi yaptýk
	clc                   ;carry bitini temizliyoruz
	rjmp dortlutersyavas  ;dortlutersyavas fonksiyonuna sýçrama yapýyoruz

tektersyavasaindirme:   ;tek yavas fonksiyonu için kullandýðýmýz fonksiyon
    mov r25,r17         ;r17 deki deðeri r25 e atamak için
	lsr r17             ;ledleri kaydýrýp 1 lede düþürmek için
	lsr r17             ;ledleri kaydýrýp 1 lede düþürmek için
	lsr r17             ;ledleri kaydýrýp 1 lede düþürmek için
	and r17,r25         ;tek led'e düþürmek için lojik ve iþlemi yapýyoruz
	lsl r17             ;ledler kaldýðý yerden devam etmesi için
	rjmp teklitersyavas ;tekli yavaþ fonksiyonunu çaðýrýyoruz


dortluorta:                ;dört led saat yönünde ilerleyen fonksiyon
	out PORTC,r17 	       ; r17 deki degeri PORTB ye yaziyoruz.
	call waitorta          ;orta hizda calýþmasý için gerekli olan fonksiyonu call ediyoruz
    sbis PINB,0	           ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call dortluhizli       ;buton basýlmýþsa saat yonunde giden fonksiyon
    rol r17                ;ledleri kaydýrmak için
	sbis PINB,1	           ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp dortlutersorta    ;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs topladortluorta   ;carry biti 1 ise topladortluorta fonksiyonuna gidiyoruz
	sbis PINB,2            ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp tekortayaindirme  ;buton basýlmýþsa led sayýsýný azaltan fonksiyona gidiyoruz
    brne dortluorta  	   ;zero biti 1 ise fonksiyonu tekrarlamak için

topladortluorta:          ;sondan baþa dortlu geçmek için.
	or r17,r30            ;lojik veya iþlemi yaptýk
	clc                   ;carry bitini temizliyoruz
	rjmp dortluorta      ;dortluorta fonksiyonuna sýçrama yapýyoruz

tekortayaindirme:  ;tek yavas fonksiyonu için kullandýðýmýz fonksiyon
    mov r25,r17    ;r17 deki deðeri r25 e atamak için
	lsl r17        ;ledleri kaydýrýp 1 lede düþürmek için
	lsl r17        ;ledleri kaydýrýp 1 lede düþürmek için
	lsl r17        ;ledleri kaydýrýp 1 lede düþürmek için
	and r17,r25    ;tek led'e düþürmek için lojik ve iþlemi yapýyoruz
	lsr r17        ;ledler kaldýðý yerden devam etmesi için
	rjmp tekliorta ;tekli yavaþ fonksiyonunu çaðýrýyoruz


dortlutersorta:               ;dört led saat yönünün tersine ilerleyen fonksiyon
	out PORTC,r17 	          ; r17 deki degeri PORTB ye yaziyoruz.
	call waitorta             ;orta hizda calýþmasý için gerekli olan fonksiyonu call ediyoruz
    sbis PINB,0	              ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call dortlutershizli      ;buton basýlmýþsa saat yonunun tersine giden fonksiyon
    ror r17                   ;ledleri kaydýrmak için
	sbis PINB,1	              ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp dortluorta           ;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplatersdortluorta  ;carry biti 1 ise toplatersdortluorta fonksiyonuna gidiyoruz
	sbis PINB,2               ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp teklitersortayaindirme     ;buton basýlmýþsa led sayýsýný azaltan fonksiyona gidiyoruz
    brne dortlutersorta   	   ;zero biti 1 ise fonksiyonu tekrarlamak için

toplatersdortluorta:      ; baþtan sona dortlu geçme.
	or r17,r31            ;lojik veya iþlemi yaptýk
	clc                   ;carry bitini temizliyoruz
	rjmp dortlutersorta   ;dortlutersorta fonksiyonuna sýçrama yapýyoruz

teklitersortayaindirme:;tek yavas fonksiyonu için kullandýðýmýz fonksiyon
    mov r25,r17        ;r17 deki deðeri r25 e atamak için
	lsr r17            ;ledleri kaydýrýp 1 lede düþürmek için
	lsr r17            ;ledleri kaydýrýp 1 lede düþürmek için
	lsr r17            ;ledleri kaydýrýp 1 lede düþürmek için
	and r17,r25        ;tek led'e düþürmek için lojik ve iþlemi yapýyoruz
	lsl r17            ;ledler kaldýðý yerden devam etmesi için
	rjmp teklitersorta ;tekli yavaþ fonksiyonunu çaðýrýyoruz

dortluhizli:               ;dört led saat yönünde ilerleyen fonksiyon
	out PORTC,r17 	       ; r17 deki degeri PORTB ye yaziyoruz.
	call waithizli         ;hizli calýþmasý için gerekli olan fonksiyonu call ediyoruz
    sbis PINB,0	           ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call dortluyavas       ;buton basýlmýþsa saat yonunde yavas giden fonksiyon
    rol r17                ;ledleri kaydýrmak için
	sbis PINB,1	           ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp dortlutershizli   ;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs topladortluhizli  ;carry biti 1 ise topladortluhizli fonksiyonuna gidiyoruz
	sbis PINB,2            ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp teklihizliyaindirme     ;buton basýlmýþsa led sayýsýný azaltan fonksiyona gidiyoruz
    brne dortluhizli   	   ;zero biti 1 ise fonksiyonu tekrarlamak için

topladortluhizli:     ;sondan baþa dortlu geçmek için.
	or r17,r30        ;lojik veya iþlemi yaptýk
	clc               ;carry bitini temizliyoruz
	rjmp dortluhizli  ;dortluhizli fonksiyonuna sýçrama yapýyoruz

teklihizliyaindirme:;tek yavas fonksiyonu için kullandýðýmýz fonksiyon
    mov r25,r17     ;r17 deki deðeri r25 e atamak için
	lsl r17         ;ledleri kaydýrýp 1 lede düþürmek için
	lsl r17         ;ledleri kaydýrýp 1 lede düþürmek için
	lsl r17         ;ledleri kaydýrýp 1 lede düþürmek için
	and r17,r25     ;tek led'e düþürmek için lojik ve iþlemi yapýyoruz
	lsr r17         ;ledler kaldýðý yerden devam etmesi için
	rjmp teklihizli ;tekli yavaþ fonksiyonunu çaðýrýyoruz
	 
dortlutershizli:            ;dört led saat yönünün tersine ilerleyen fonksiyon
	out PORTC,r17 	        ; r17 deki degeri PORTB ye yaziyoruz.
	call waithizli          ;hizli calýþmasý için gerekli olan fonksiyonu call ediyoruz
    sbis PINB,0	            ;PB0 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	call dortlutersyavas    ;buton basýlmýþsa saat yonunun tersine yavas giden fonksiyon
    ror r17                 ;ledleri kaydýrmak için
	sbis PINB,1		        ;PB1 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
    rjmp dortluhizli        ;PB1 pini 0 ise (butona basilmissa) bu komut atlanmayacak ve isletilecektir
	brcs toplatersdortluhizli        ;carry biti 1 ise toplatersdortluhizli fonksiyonuna gidiyoruz
	sbis PINB,2                      ;PB2 pini 1 ise (butona basilmamissa) bir sonraki komutu atla
	rjmp teklitershizliyaindirme     ;buton basýlmýþsa led sayýsýný azaltan fonksiyona gidiyoruz
    brne dortlutershizli    	     ;zero biti 1 ise fonksiyonu tekrarlamak için

toplatersdortluhizli:     ; baþtan sona dortlu geçme.
	or r17,r31            ;lojik veya iþlemi yaptýk
	clc                   ;carry bitini temizliyoruz
	rjmp dortlutershizli  ;dortlutershizli fonksiyonuna sýçrama yapýyoruz

teklitershizliyaindirme:       ;tek yavas fonksiyonu için kullandýðýmýz fonksiyon
    mov r25,r17                ;r17 deki deðeri r25 e atamak için
	lsr r17                    ;ledleri kaydýrýp 1 lede düþürmek için
	lsr r17                    ;ledleri kaydýrýp 1 lede düþürmek için
	lsr r17                    ;ledleri kaydýrýp 1 lede düþürmek için
	and r17,r25                ;tek led'e düþürmek için lojik ve iþlemi yapýyoruz
	lsl r17                    ;ledler kaldýðý yerden devam etmesi için
	rjmp teklitershizli        ;tekli yavaþ fonksiyonunu çaðýrýyoruz

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


waithizli:			;hýzlý bekleme saglayan fonksiyonumuz
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