---
title: "İnternetin Derinliklerine: ICMP, Ping ve MTR ile Ağ Tanılamanın Anatomisi"
date: 2025-11-26T15:57:21Z
draft: false
description: "Ağ tanılama ve sorun giderme konusunda ustalaşın. SysAdmin ve DevOps için ICMP, Ping ve MTR araçlarını kullanarak internetin anatomisini anlamaya yönelik kapsamlı bir rehber."
tags: ["networking","internet","icmp","ping","mtr","ağ-tanılama","linux","sysadmin","devops","troubleshooting"]
categories: ["ağ"]
slug: "internetin-derinliklerine-icmp-ping-mtr-ag-tanilamanin-anatomisi"
series: ["internet"]
seriesPart: 1
cover:
  image: "images/internetin-derinliklerine-icmp-ping-mtr-ag-tanilamanin-anatomisi-cover.webp"
  alt: "ICMP, Ping ve MTR araçlarını gösteren ağ tanılama illüstrasyonu"
  caption: "ICMP, Ping ve MTR ile ağ tanılamaya derinlemesine bakış (Gemini 3.0 ile oluşturuldu)"
  relative: false
images:
  - "images/internetin-derinliklerine-icmp-ping-mtr-ag-tanilamanin-anatomisi-cover.webp"
---

{{< toc-accordion >}}

## Giriş

İnternet, dedikten sonra burada şöyle kullanılıyor, olmazsa olmaz demek basit gelecek kadar önemli. İnternetin arkasındaki sihir nasıl gerçekleşiyora göz atacağız. Bir web sayfasına girdiğinizde, bir mesaj gönderdiğinizde veya bir video izlediğinizde arka planda neler oluyor?

Bu rehberde, internetin temellerinden başlayarak, ağ tanılama araçlarının en önemli yapı taşlarına doğru bir yolculuğa çıkacağız. ICMP protokolünü, ping komutunu ve gelişmiş ağ tanılama aracı MTR'yi derinlemesine inceleyeceğiz. Kaputun altına bakıyoruz.

---

## İnternetin Tarihi ve Evrim

### ARPANET: Her Şeyin Başladığı Yer (1969)

İnternetin hikayesi, 1960'ların sonlarında Soğuk Savaş döneminde başlar. ABD Savunma Bakanlığı'nın Advanced Research Projects Agency (ARPA) birimi, nükleer bir saldırıya dayanıklı bir iletişim ağı geliştirmek ister.

**Temel Tasarım Felsefesi:**
- **Merkezi Olmayan Yapı:** Tek bir kontrol noktası yoktu
- **Paket Anahtarlama (Packet Switching):** Paul Baran ve Donald Davies'in devrim niteliğindeki fikri
- **Yedeklilik:** Bir bağlantı kopsa bile alternatif yollar olmalıydı

29 Ekim 1969'da, UCLA'dan Stanford Research Institute'a ilk mesaj gönderildi. İlk iletilen kelime "LOGIN" olacaktı, ancak sistem "LO" harflerinden sonra çöktü - tarihin en anlamlı sistem çökmelerinden biri :D

### TCP/IP'nin Doğuşu (1970'ler)

**1974:** Vint Cerf ve Bob Kahn, "Transmission Control Protocol" (TCP) üzerinde çalışmaya başladı.

**Temel Problem:** Farklı ağlar birbirleriyle nasıl konuşacak?
- Farklı donanımlar
- Farklı protokoller
- Farklı hata yönetimi stratejileri

**Çözüm:** Evrensel bir protokol katmanı - TCP/IP

**1983:** ARPANET, NCP protokolünden TCP/IP'ye geçti. Bu tarihe "Flag Day" (Bayrak Günü) denir ve modern internetin doğum günü olarak kabul edilir.

<!-- <HIDE_DEV_TO> -->
### İnternetin Genişlemesi (1980-1990'lar)

- **1984:** Domain Name System (DNS) devreye girdi
- **1989:** Tim Berners-Lee, World Wide Web'i (WWW) icat etti
- **1991:** İnternet halka açıldı
- **1995-2000:** Dot-com patlaması ve internetin kitleselleşmesi

<!-- </HIDE_DEV_TO> -->

---

## İnternet Nasıl Çalışır? Tavşan Deliği

### Paket Anahtarlama: İnternetin Temeli

Geleneksel telefon sistemlerinde bir "devre anahtarlama" vardı - arayan ve aranan arasında özel bir hat kurulurdu. İnternet ise farklı çalışır.

**Paket Anahtarlama Nasıl Çalışır?**

```
Orijinal Veri: "Merhaba Dünya!"
↓
Paketlere Bölünür:
[Paket 1: "Merh"] [Paket 2: "aba "] [Paket 3: "Düny"] [Paket 4: "a!"]
↓
Her paket bağımsız olarak yönlendirilir
↓
Hedefte yeniden birleştirilir
```

<!-- <HIDE_DEV_TO> -->
{{< accordion title="ASCII Diagram" >}}

```
+------------------------------------------------------------------+
|                      GÖNDERİCİ (KAYNAK)                          |
|                 Veri: "Merhaba Dünya!"                           |
+------------------------------------------------------------------+
                            |
                            v
                    1. PARÇALAMA (Segmentation)
            -------------------------------------
            |           |           |           |
         [Merh]      [aba ]      [Düny]       [a!]
        (Paket 1)   (Paket 2)   (Paket 3)   (Paket 4)
            |           |           |           |
            v           v           v           v
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ~                   İNTERNET BULUTU (AĞ)                   ~
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            |           |           |           |
        +-------+   +-------+   +-------+   +-------+
        |Router |   |Router |   |Router |   |Router |
        |   A   |   |   B   |   |   C   |   |   D   |
        +-------+   +-------+   +-------+   +-------+
            |           |           |           |
            |     (Yol Tıkalı)      |           |
            |           X           |           |
            v           |           v           v
        +-------+       -------->+-------+  +-------+
        |Router |                |Router |  |Router |
        |   E   |                |   F   |  |   G   |
        +-------+                +-------+  +-------+
            |                        |          |
            v                        v          v
         [Merh]                   [aba ]      [a!]
                                  [Düny]
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            |           |            |           |
            v           v            v           v
         (Paket 1)   (Paket 3)    (Paket 2)   (Paket 4)
            * Not: Paketler sırasız gelebilir! *
            |           |            |           |
            --------------------------------------
                            |
                            v
                 2. YENİDEN BİRLEŞTİRME (Reassembly)
         (TCP protokolü paketleri doğru sıraya dizer)
                            |
                            v
            [Merh] + [aba ] + [Düny] + [a!]
                            |
                            v
+------------------------------------------------------------------+
|                        ALICI (HEDEF)                             |
|                 Sonuç: "Merhaba Dünya!"                          |
+------------------------------------------------------------------+
```
{{< /accordion >}}
<!-- </HIDE_DEV_TO> -->

**Avantajlar:**
- Esneklik: Bir yol tıkalıysa başka yoldan gider
- Verimlilik: Bant genişliği paylaşılır
- Güvenilirlik: Tek bir arıza tüm sistemi çökertmez



{{< accordion title="⚙️ Similasyon Kod Örneği" >}}

```py
import time
import random

# --- GLOBAL DEĞİŞKENLER ---
receiver_buffer = []
MY_IP_ADDRESS = "192.168.1.10"

# --- 1. ADIM: GÖNDERİCİ (Sender) ---
def send_data(original_data, destination_address):
    print(f"\n--- [GÖNDERİCİ] Orijinal Veri: '{original_data}' ---")
    print(f"--- [GÖNDERİCİ] Veri parçalanıyor ve ağa gönderiliyor...\n")
    
    # Veriyi 4 karakterlik parçalara böl
    chunks = [original_data[i:i+4] for i in range(0, len(original_data), 4)]
    
    packet_list = []
    total_packets_count = len(chunks)
    
    for index, chunk in enumerate(chunks):
        packet = {
            "payload": chunk,              # EKRANA BASACAĞIMIZ KISIM BURASI
            "sequence_id": index,
            "total_count": total_packets_count,
            "destination": destination_address,
            "source": MY_IP_ADDRESS
        }
        packet_list.append(packet)

    # Paketlerin sırasını karıştır (İnternet simülasyonu)
    random.shuffle(packet_list)
    
    for packet in packet_list:
        route_packet(packet)


# --- 2. ADIM: AĞ YÖNLENDİRİCİSİ (Router) ---
def route_packet(packet):
    available_paths = ["Fiber_Hat_A", "Uydu_Link_B", "Bakır_Kablo_C"]
    best_path = random.choice(available_paths)
    
    # GÜNCELLEME BURADA:
    # Hem Paket ID'sini hem de içindeki Veriyi (Payload) yazdırıyoruz.
    # f-string içinde hizalama yaptık (<20 gibi) ki çıktı düzgün dursun.
    
    payload_content = f"'{packet['payload']}'"
    
    print(f" -> [ROUTER] Paket ID: {packet['sequence_id']} | "
          f"İÇERİK: {payload_content:<10} | "  # Veriyi gösterir ve hizalar
          f"YOL: {best_path}")
    
    time.sleep(0.5) # İşlemi görebilmek için yarım saniye bekle
    receive_data(packet)


# --- 3. ADIM: ALICI (Receiver) ---
def receive_data(incoming_packet):
    global receiver_buffer
    receiver_buffer.append(incoming_packet)
    
    if len(receiver_buffer) == incoming_packet['total_count']:
        print("\n--- [ALICI] Tüm parçalar ulaştı! ---")
        
        # Sıralama
        sorted_packets = sorted(receiver_buffer, key=lambda x: x['sequence_id'])
        
        # Birleştirme
        final_message = ""
        print("--- [ALICI] Paketler Sıralanıyor ve Birleştiriliyor: ---")
        
        for p in sorted_packets:
            print(f"    + Paket {p['sequence_id']} eklendi: '{p['payload']}'")
            final_message += p['payload']
            
        print(f"\nSONUÇ: Mesaj Başarıyla Alındı -> '{final_message}'")
        
        receiver_buffer = []

# --- UYGULAMAYI ÇALIŞTIR ---
if __name__ == "__main__":
    mesaj = "Merhaba Dünya! Nasılsın?"
    hedef = "10.0.0.5"
    
    send_data(mesaj, hedef)
```

{{< /accordion >}}
<!-- </HIDE_DEV_TO> -->


### TCP/IP Model: 4 Katmanlı Mimari

İnternet, katmanlı bir mimari üzerine kuruludur. Her katman, bir üst katmana hizmet sunar ve bir alt katmanın hizmetlerini kullanır.

```
┌─────────────────────────────────────┐
│   4. Uygulama Katmanı               │
│   (HTTP, FTP, SMTP, DNS)            │
├─────────────────────────────────────┤
│   3. Taşıma Katmanı                 │
│   (TCP, UDP)                        │
├─────────────────────────────────────┤
│   2. İnternet Katmanı               │
│   (IP, ICMP, IGMP)                  │
├─────────────────────────────────────┤
│   1. Ağ Arayüz Katmanı              │
│   (Ethernet, Wi-Fi)                 │
└─────────────────────────────────────┘
```

#### 1. Ağ Arayüz Katmanı (Link Layer)
- **Görev:** Fiziksel ağ üzerinden veri iletimi
- **Teknolojiler:** Ethernet, Wi-Fi, Fiber optik
- **MAC Adresi:** Fiziksel donanım adresi (örn: `00:1B:44:11:3A:B7`)

#### 2. İnternet Katmanı (Internet Layer)
- **Görev:** Paketlerin yönlendirilmesi (routing)
- **Ana Protokol:** IP (Internet Protocol)
- **ICMP:** Bu katmanda çalışır! (Kontrol ve hata mesajları)

**IP Adresi Yapısı:**
```
IPv4: 192.168.1.100 (32-bit, ~4.3 milyar adres)
      [Ağ Kısmı].[Host Kısmı]

IPv6: 2001:0db8:85a3:0000:0000:8a2e:0370:7334 (128-bit, ~340 undecillion adres)
```

#### 3. Taşıma Katmanı (Transport Layer)
- **TCP:** Güvenilir, sıralı, hatasız iletim (örn: web sayfaları, e-posta)
- **UDP:** Hızlı ama güvensiz iletim (örn: video streaming, DNS)

**TCP vs UDP:**
```
TCP: Paket kaybolursa yeniden gönder, sıralama garantili
     [SYN] → [SYN-ACK] → [ACK] (Three-way handshake)
     Yavaş ama güvenilir

UDP: Pakeyi gönder, unut. Kaybolursa kaybolsun
     Hızlı ama güvensiz
```

##### Not

- **SYN _(Synchronize)_**: İletişimi başlatmak isteyen tarafın gönderdiği "Bağlantı kuralım mı?" isteğidir.
- **ACK _(Acknowledgment)_**: Bir önceki mesajın sorunsuz alındığını doğrulayan "Tamam, aldım" onayıdır.
- **SYN-ACK**: Sunucunun "İsteğini aldım (ACK) ve ben de hazırım (SYN)" deme şeklidir.

#### 4. Uygulama Katmanı (Application Layer)
- **HTTP/HTTPS:** Web
- **SMTP/POP3/IMAP:** E-posta
- **FTP:** Dosya transferi
- **DNS:** Domain name çözümleme
- **SSH:** Güvenli uzak bağlantı

### Routing: Paketler Nasıl Yol Bulur?

Her router, bir "routing table" (yönlendirme tablosu) tutar:

```bash
$ ip route show
default via 192.168.1.1 dev eth0
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.100
```

| OS | Durum / Gerekli Paket | Karşılık Gelen |
| :--- | :--- | :--- |
| **Linux** | `iproute2` (Genelde yüklü gelir) | `ip route show` |
| **Windows** | Yerel komut (CMD / PowerShell) | `route print` |
| **macOS** | Yerel komut (veya `brew install iproute2mac`) | `netstat -rn` |

**Routing Süreci:**
1. Paket router'a gelir
2. Router, hedef IP adresine bakar
3. Routing table'dan en uygun yolu seçer
4. Paketi bir sonraki router'a (next hop) gönderir
5. Bu işlem hedefe ulaşılana kadar tekrar eder

**Örnek Yolculuk:**
```
İstanbul → Frankfurt → London → New York

İstanbuldaki bilgisayarınız:
  ↓ (Paket gönder: hedef 93.184.216.34)
İnternet Servis Sağlayıcı (ISP) Router'ı
  ↓ (En iyi yol: Frankfurt)
Frankfurt Backbone Router
  ↓ (Atlantik kablosu üzerinden)
New York Router
  ↓
Hedef Sunucu (93.184.216.34)
```

Her router, sadece bir sonraki adımı bilir - tüm yolu değil. Bu "distributed intelligence" (dağıtık zeka) yaklaşımı internetin ölçeklenebilirliğinin anahtarıdır.

{{< accordion title="Dağıtık Zeka (Distributed Intelligence) Nedir?" >}}
İnterneti yöneten tek bir "süper beyin" veya merkezi bir harita yoktur. Bunun yerine, milyonlarca küçük beyin (router) vardır ve herkes sadece kendi yakın çevresini bilir. **Kalabalık bir şehirde adres sormaya** benzetebiliriz: Birine adres sorduğunuzda size evin kapısına kadar tüm yolu tarif edemeyebilir, ama "Sen şu caddeye çık, oradan tekrar sor" der. Her router, paketi hedefe biraz daha yaklaştıracak en iyi komşusunu seçer ve sorumluluğu ona devreder. Bu sayede internet ne kadar büyürse büyüsün, tek bir merkeze yük binmediği için sistem tıkanmaz ve sonsuza kadar ölçeklenebilir.
{{< /accordion >}}

---

## ICMP Protokolü: İnternetin Sinir Sistemi

### ICMP Nedir?

**Internet Control Message Protocol (ICMP)**, IP protokolünün bir parçasıdır ancak farklı bir amaca hizmet eder:
- Veri taşımaz
- Hata bildirimlerini iletir
- Ağ tanılama mesajları gönderir

**Tarihçe:** RFC 792 (1981) tarafından tanımlandı - Jon Postel tarafından

### ICMP Neden Gerekli?

IP protokolü "best-effort" (en iyi çaba) prensibiyle çalışır:
- Paket teslimini garanti etmez
- Hata bildirimi yapmaz
- Akış kontrolü yapmaz

ICMP bu boşluğu doldurur!

### ICMP Mesaj Yapısı

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     Type      |     Code      |          Checksum             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                         Rest of Header                        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                         Data Section                          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

<!-- <HIDE_DEV_TO> -->
{{< accordion title="Tüm ICMP Mesaj Tipleri" >}}
Aşağıdaki tablo **ICMPv4 (RFC792 / IANA ICMP Parameters)** için, **tüm Type’lar** ve **atanmış Code’lar** (varsa). (Bazı Type’lar **Deprecated / Unassigned / Reserved** olduğu için pratikte kullanılmaz.) ([IANA][1])

| Type       | Code   | Mesaj Adı                                           | Açıklama ve Kullanım Senaryosu                                                                                              |
| :--------- | :----- | :-------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- |
| **0**      | 0      | **Echo Reply**                                      | **"Buradayım!"** cevabı. `ping` isteğine yanıt olarak döner. ([IANA][1])                                                    |
| **1**      | -      | **Unassigned**                                      | IANA’da atanmış bir ICMP tipi yok. Pratikte kullanılmaz. ([IANA][1])                                                        |
| **2**      | -      | **Unassigned**                                      | IANA’da atanmış bir ICMP tipi yok. Pratikte kullanılmaz. ([IANA][1])                                                        |
| **3**      | **0**  | **Network Unreachable**                             | Hedef ağa giden bir yol yok (router’da route yok / default route yok gibi). ([IANA][1])                                     |
| **3**      | **1**  | **Host Unreachable**                                | Ağ var ama hedef host’a ulaşılamıyor (ARP çözülemiyor, host kapalı, L2/L3 problem). ([IANA][1])                             |
| **3**      | **2**  | **Protocol Unreachable**                            | Hedef sistem, belirtilen üst protokolü desteklemiyor (örn. IP payload protocol alanı). ([IANA][1])                          |
| **3**      | **3**  | **Port Unreachable**                                | Hedef host açık ama ilgili UDP/TCP portu kapalı / servis dinlemiyor (özellikle UDP için tipik). ([IANA][1])                 |
| **3**      | **4**  | **Fragmentation Needed (DF set)**                   | MTU küçük, paket parçalanmalı ama **DF** set edildiği için parçalanamıyor (PMTUD senaryosu). ([IANA][1])                    |
| **3**      | **5**  | **Source Route Failed**                             | Source routing opsiyonu ile istenen rota izlenemedi / başarısız oldu. ([IANA][1])                                           |
| **3**      | **6**  | **Destination Network Unknown**                     | “Ağ bilinmiyor” şeklinde daha spesifik unreachable (RFC1122 ile tanımlı). ([IANA][1])                                       |
| **3**      | **7**  | **Destination Host Unknown**                        | “Host bilinmiyor” (RFC1122). DNS değil; routing/ulaşılabilirlik anlamında “tanımsız”. ([IANA][1])                           |
| **3**      | **8**  | **Source Host Isolated**                            | Kaynak host izole (tarihsel/legacy; günümüzde nadir). ([IANA][1])                                                           |
| **3**      | **9**  | **Network Administratively Prohibited**             | Hedef ağa erişim **idari olarak engelli** (ACL/policy). ([IANA][1])                                                         |
| **3**      | **10** | **Host Administratively Prohibited**                | Hedef host’a erişim **idari olarak engelli** (ACL/policy). ([IANA][1])                                                      |
| **3**      | **11** | **Network Unreachable for ToS**                     | Type of Service (ToS) nedeniyle hedef ağa ulaşılamıyor (legacy). ([IANA][1])                                                |
| **3**      | **12** | **Host Unreachable for ToS**                        | ToS nedeniyle hedef host’a ulaşılamıyor (legacy). ([IANA][1])                                                               |
| **3**      | **13** | **Communication Administratively Prohibited**       | Genel “policy/filtre” yüzünden iletişim engellendi (RFC1812). ([IANA][1])                                                   |
| **3**      | **14** | **Host Precedence Violation**                       | Precedence/öncelik ihlali (policy). Nadir/legacy. ([IANA][1])                                                               |
| **3**      | **15** | **Precedence Cutoff in Effect**                     | Precedence cutoff aktif; paket önceliği yetersiz (legacy). ([IANA][1])                                                      |
| **4**      | 0      | **Source Quench (Deprecated)**                      | Eski “tıkanıklık yavaşlat” mesajı. **Kullanımı önerilmez/deprecated**. ([IANA][1])                                          |
| **5**      | 0      | **Redirect (Network/Subnet)**                       | Router: **“Bu network’e benden değil, şu gateway’den git.”** (aynı LAN içinde daha iyi next-hop). ([IANA][1])               |
| **5**      | 1      | **Redirect (Host)**                                 | Router: **“Bu host’a benden değil, şu gateway’den git.”** ([IANA][1])                                                       |
| **5**      | 2      | **Redirect (ToS + Network)**                        | ToS’e göre network için redirect (legacy). ([IANA][1])                                                                      |
| **5**      | 3      | **Redirect (ToS + Host)**                           | ToS’e göre host için redirect (legacy). ([IANA][1])                                                                         |
| **6**      | 0      | **Alternate Host Address (Deprecated)**             | “Host için alternatif adres” bildirimi (tarihsel; deprecated). ([IANA][1])                                                  |
| **7**      | -      | **Unassigned**                                      | IANA’da atanmış bir ICMP tipi yok. ([IANA][1])                                                                              |
| **8**      | 0      | **Echo Request**                                    | **"Orada mısın?"** mesajı. `ping` komutunun gönderdiği istek. ([IANA][1])                                                   |
| **9**      | 0      | **Router Advertisement (Normal)**                   | Router keşfi/duyurusu (ICMP Router Discovery). Bazı ağlarda gateway discovery için. ([IANA][1])                             |
| **9**      | 16     | **Router Advertisement (Not route common traffic)** | “Genel trafiği route etme” şeklinde işaretlenmiş router duyurusu (Mobil IP bağlamı). ([IANA][1])                            |
| **10**     | 0      | **Router Solicitation**                             | İstemci: **“Router’lar kendini duyursun”** diye solicitation atar (router discovery). ([IANA][1])                           |
| **11**     | **0**  | **TTL Exceeded (Transit)**                          | **Traceroute’un kalbi.** TTL yolda bitti, router paketi düşürüp bu hatayı döndürdü. ([IANA][1])                             |
| **11**     | 1      | **Fragment Reassembly Time Exceeded**               | Parçalanmış paket parçaları zamanında gelmedi; reassembly timeout. ([IANA][1])                                              |
| **12**     | **0**  | **Parameter Problem (Pointer)**                     | IP header’da bir alan hatalı; **pointer** hatanın olduğu byte’ı gösterir (header bozuk/uygunsuz). ([IANA][1])               |
| **12**     | **1**  | **Parameter Problem (Missing Option)**              | Gerekli bir IP option eksik. (Legacy/opsiyon senaryosu.) ([IANA][1])                                                        |
| **12**     | **2**  | **Parameter Problem (Bad Length)**                  | Header uzunluğu/alan uzunluğu hatalı. (Paket format problemi.) ([IANA][1])                                                  |
| **13**     | 0      | **Timestamp**                                       | Zaman ölçümü/round-trip ve clock senkron testleri için timestamp isteği (günümüzde nadir). ([IANA][1])                      |
| **14**     | 0      | **Timestamp Reply**                                 | Timestamp isteğine yanıt. ([IANA][1])                                                                                       |
| **15**     | 0      | **Information Request (Deprecated)**                | Eski bilgi isteği; deprecated. ([IANA][1])                                                                                  |
| **16**     | 0      | **Information Reply (Deprecated)**                  | Eski bilgi yanıtı; deprecated. ([IANA][1])                                                                                  |
| **17**     | 0      | **Address Mask Request (Deprecated)**               | Subnet mask öğrenmek için istek (legacy; deprecated). ([IANA][1])                                                           |
| **18**     | 0      | **Address Mask Reply (Deprecated)**                 | Address mask isteğine yanıt (legacy; deprecated). ([IANA][1])                                                               |
| **19**     | -      | **Reserved (for Security)**                         | Güvenlik amaçlı “reserved”; kullanılmaz. ([IANA][1])                                                                        |
| **20-29**  | -      | **Reserved (Robustness Experiment)**                | Dayanıklılık/robustness deneyleri için ayrılmış aralık; pratikte kullanılmaz. ([IANA][1])                                   |
| **30**     | -      | **Traceroute (Deprecated)**                         | ICMP “Traceroute” tipi tarihsel olarak var ama **deprecated**; modern traceroute genelde Type 11/3 ile çalışır. ([IANA][1]) |
| **31**     | -      | **Datagram Conversion Error (Deprecated)**          | Datagram dönüşüm hatası; deprecated/legacy. ([IANA][1])                                                                     |
| **32**     | -      | **Mobile Host Redirect (Deprecated)**               | Mobil IP bağlamında redirect; deprecated/legacy. ([IANA][1])                                                                |
| **33**     | -      | **IPv6 Where-Are-You (Deprecated)**                 | ICMPv4 içinde tarihsel/legacy bir tip; deprecated. (ICMPv6 ile karıştırma.) ([IANA][1])                                     |
| **34**     | -      | **IPv6 I-Am-Here (Deprecated)**                     | Aynı şekilde legacy; deprecated. ([IANA][1])                                                                                |
| **35**     | -      | **Mobile Registration Request (Deprecated)**        | Mobil kayıt isteği; deprecated. ([IANA][1])                                                                                 |
| **36**     | -      | **Mobile Registration Reply (Deprecated)**          | Mobil kayıt yanıtı; deprecated. ([IANA][1])                                                                                 |
| **37**     | -      | **Domain Name Request (Deprecated)**                | ICMP üzerinden domain name sorgusu (legacy/deprecated). ([IANA][1])                                                         |
| **38**     | -      | **Domain Name Reply (Deprecated)**                  | Domain name sorgusuna yanıt (legacy/deprecated). ([IANA][1])                                                                |
| **39**     | -      | **SKIP (Deprecated)**                               | SKIP anahtar yönetimiyle ilgili tarihsel tip; deprecated. ([IANA][1])                                                       |
| **40**     | 0      | **Photuris: Bad SPI**                               | Photuris/IPsec anahtar yönetimi hata bildirimi: **SPI hatalı**. ([IANA][1])                                                 |
| **40**     | 1      | **Photuris: Authentication Failed**                 | Photuris doğrulama başarısız. ([IANA][1])                                                                                   |
| **40**     | 2      | **Photuris: Decompression Failed**                  | Photuris sıkıştırma açma başarısız. ([IANA][1])                                                                             |
| **40**     | 3      | **Photuris: Decryption Failed**                     | Photuris şifre çözme başarısız. ([IANA][1])                                                                                 |
| **40**     | 4      | **Photuris: Need Authentication**                   | Photuris: Authentication gerekli. ([IANA][1])                                                                               |
| **40**     | 5      | **Photuris: Need Authorization**                    | Photuris: Authorization gerekli. ([IANA][1])                                                                                |
| **41**     | -      | **Experimental Mobility (Seamoby vb.)**             | Deneysel mobilite protokollerinin kullandığı ICMP tipi; code kaydı yok. ([IANA][1])                                         |
| **42**     | 0      | **Extended Echo Request**                           | RFC8335 “PROBE”: Klasik ping’in genişletilmiş hali; arayüz/proxy üzerinden teşhis amaçlı sorgu. ([IANA][1])                 |
| **42**     | 1-255  | **Extended Echo Request (Unassigned)**              | Bu code aralığı atanmadı. ([IANA][1])                                                                                       |
| **43**     | 0      | **Extended Echo Reply: No Error**                   | Extended Echo isteğine “hatasız” yanıt. ([IANA][1])                                                                         |
| **43**     | 1      | **Extended Echo Reply: Malformed Query**            | Sorgu bozuk/hatalı format. ([IANA][1])                                                                                      |
| **43**     | 2      | **Extended Echo Reply: No Such Interface**          | İstenen arayüz bulunamadı. ([IANA][1])                                                                                      |
| **43**     | 3      | **Extended Echo Reply: No Such Table Entry**        | Sorgulanan tablo girdisi yok. ([IANA][1])                                                                                   |
| **43**     | 4      | **Extended Echo Reply: Multiple Interfaces Match**  | Sorguya birden fazla arayüz uyuyor (belirsiz eşleşme). ([IANA][1])                                                          |
| **43**     | 5-255  | **Extended Echo Reply (Unassigned)**                | Bu code aralığı atanmadı. ([IANA][1])                                                                                       |
| **44-252** | -      | **Unassigned**                                      | Bu type aralığı IANA’da atanmadı. ([IANA][1])                                                                               |
| **253**    | -      | **Experiment 1 (RFC3692-style)**                    | Deneysel kullanım için ayrılmış type. ([IANA][1])                                                                           |
| **254**    | -      | **Experiment 2 (RFC3692-style)**                    | Deneysel kullanım için ayrılmış type. ([IANA][1])                                                                           |
| **255**    | -      | **Reserved**                                        | Rezerve/ayrılmış; kullanılmaz. ([IANA][1])                                                                                  |

[1]: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml "Internet Control Message Protocol (ICMP) Parameters"

{{< /accordion >}}
<!-- </HIDE_DEV_TO> -->

### Önemli ICMP Mesaj Tipleri

#### Type 0/8: Echo Reply / Echo Request (PING)
```
Type 8: Echo Request (Ping atma)
Type 0: Echo Reply (Pong cevabı)

Kullanım: Host'un canlı olup olmadığını kontrol etme
```

#### Type 3: Destination Unreachable
```
Code 0: Network Unreachable (Ağa ulaşılamıyor)
Code 1: Host Unreachable (Host'a ulaşılamıyor)
Code 2: Protocol Unreachable (Protokol desteklenmiyor)
Code 3: Port Unreachable (Port kapalı)
Code 4: Fragmentation Needed (Paket çok büyük, parçalama gerekli)
```

**Örnek Senaryo:**
```bash
$ curl http://192.168.1.250:8080
# Router cevap verir:
ICMP Type 3, Code 1: Host Unreachable
# Sonuç: Host ağda yok veya kapalı
```

#### Type 11: Time Exceeded
```
Code 0: TTL Exceeded in Transit (Traceroute'un temeli!)
Code 1: Fragment Reassembly Time Exceeded
```

**TTL (Time To Live) Mekanizması:**
```
Paket gönderilir: TTL=64
Her router'dan geçerken: TTL-1
TTL=0 olduğunda: ICMP Time Exceeded döner

Bu sayede paketler sonsuza kadar dolaşmaz!
```

#### Type 5: Redirect
```
"Daha iyi bir yol var!" mesajı
Router'ın host'a yönlendirme optimizasyonu önermesi
```

#### Type 30: Traceroute
Modern traceroute implementasyonları için kullanılır.

### ICMP'nin Güvenlik Boyutu

**Potansiyel Tehditler:**

1. **ICMP Flood (Smurf Attack)**
```
Saldırgan → Broadcast IP'ye ping (sahte kaynak IP: kurban)
Ağdaki tüm hostlar → Kurban'a ping reply
Sonuç: DDoS
```

2. **ICMP Redirect Saldırıları**
Sahte redirect mesajları ile trafiği yönlendirme

3. **Ping of Death**
Aşırı büyük ICMP paketleri göndererek buffer overflow

**Koruma Yöntemleri:**
- ICMP rate limiting (oran sınırlama)
- Firewall'da gereksiz ICMP tiplerini bloke etme
- ICMP redirect mesajlarını devre dışı bırakma

```bash
# Linux'ta ICMP redirect'i devre dışı bırakma
sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
sudo sysctl -w net.ipv4.conf.all.send_redirects=0
```

---

## Ping Komutu: Ağ Tanılamanın Kalbi

### Ping Nedir?

**Ping**, ICMP Echo Request/Reply mekanizmasını kullanan bir ağ tanılama aracıdır. İsmi, denizaltı sonarının "ping" sesinden gelir - bir sinyal gönderir ve yankısını dinler.

**Geliştirici:** Mike Muuss (1983) - BBN Technologies

### Ping Nasıl Çalışır?

```
┌─────────────┐                           ┌─────────────┐
│   Kaynak    │                           │    Hedef    │
│   (Senin    │                           │  (example.  │
│ Bilgisayarın│                           │    com)     │
└──────┬──────┘                           └──────┬──────┘
       │                                         │
       │ ICMP Echo Request (Type 8)              │
       │ Seq=1, ID=12345, Payload=56 bytes       │
       │                                         │
       │────────────────────────────────────────>│
       │                                         │
       │         ICMP Echo Reply (Type 0)        │
       │         Seq=1, ID=12345                 │
       │                                         │
       │<────────────────────────────────────────│
       │                                         │
       │ ICMP Echo Request (Type 8)              │
       │ Seq=2, ID=12345                         │
       │                                         │
       │────────────────────────────────────────>│
       │                                         │
```

**Adım Adım:**
1. Ping, hedef hostname'i DNS ile IP'ye çevirir
2. ICMP Echo Request paketi oluşturur (Type 8)
3. Pakete sequence number ve timestamp ekler
4. Paketi hedefe gönderir
5. Hedef, Echo Reply (Type 0) ile cevap verir
6. Ping, round-trip time (RTT) hesaplar
7. İstatistikleri gösterir

### Temel Ping Kullanımı

#### En Basit Kullanım
```bash
$ ping google.com

PING google.com (172.217.169.46) 56(84) bytes of data.
64 bytes from sof02s42-in-f14.1e100.net (172.217.169.46): icmp_seq=1 ttl=117 time=15.2 ms
64 bytes from sof02s42-in-f14.1e100.net (172.217.169.46): icmp_seq=2 ttl=117 time=14.8 ms
64 bytes from sof02s42-in-f14.1e100.net (172.217.169.46): icmp_seq=3 ttl=117 time=15.1 ms
^C
--- google.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 14.800/15.033/15.200/0.172 ms
```

<!-- <HIDE_DEV_TO> -->
| İşletim Sistemi | Komut | Davranış ve Notlar |
| :--- | :--- | :--- |
| **Linux** | `ping google.com` | **Sonsuz çalışır.** Durdurmak için `Ctrl + C` tuşlarına basmanız gerekir. (Örnekteki çıktı bu davranışa aittir). |
| **macOS** | `ping google.com` | **Sonsuz çalışır.** Linux ile aynıdır. Durdurmak için `Ctrl + C` kullanılır. |
| **Windows** | `ping google.com` | **Sadece 4 paket gönderir** ve otomatik olarak durur. |
| **Windows (Sonsuz)**| `ping -t google.com` | Linux/Mac gibi **sürekli** göndermesi için `-t` parametresi eklenmelidir. Durdurmak için `Ctrl + C` kullanılır. |
<!-- </HIDE_DEV_TO> -->

**Çıktı Analizi:**

| Alan | Açıklama |
|------|----------|
| `64 bytes` | ICMP paket boyutu (IP başlığı hariç) |
| `icmp_seq=1` | Sıra numarası (paket kaybı tespiti için) |
| `ttl=117` | Time To Live - kaç router daha geçebilir |
| `time=15.2 ms` | Round-Trip Time (gidiş-dönüş süresi) |

{{< accordion title="Biliyor muydunuz?" >}}
Evinizdeki internet yavaşladığında `ping 8.8.8.8` yazarak Google'a ping atarsınız. Ancak sorunun modeminizde mi yoksa servis sağlayıcınızda mı olduğunu anlamak için önce `ping 192.168.1.1` (modem ağ geçidi) yapmalısınız. İlk adımda sorun varsa, problem evinizin içindedir :)
{{< /accordion >}}

<!-- <HIDE_DEV_TO> -->
**İstatistik Analizi:**
- `3 packets transmitted, 3 received`: Tüm paketler döndü = %0 kayıp
- `rtt min/avg/max/mdev`: Minimum/Ortalama/Maksimum/Standart sapma
- `mdev (mean deviation)`: Gecikme tutarlılığını gösterir

### Ping Parametreleri ve Kullanım Örnekleri

#### 1. Paket Sayısını Sınırlama (-c / --count)
```bash
# Sadece 5 paket gönder
$ ping -c 5 cloudflare.com

# Windows'ta
C:\> ping -n 5 cloudflare.com
```

#### 2. Paket Aralığını Değiştirme (-i / --interval)
```bash
# Her 2 saniyede bir ping gönder (varsayılan 1 saniye)
$ ping -i 2 google.com

# Hızlı ping (0.2 saniye) - root gerektirir
$ sudo ping -i 0.2 google.com

# Windows'ta (milisaniye)
C:\> ping -w 2000 google.com
```

**Kullanım Senaryosu:** Ağda yük oluşturmadan uzun süreli monitöring

#### 3. Paket Boyutunu Değiştirme (-s / --size)
```bash
# 1000 byte veri gönder (toplam paket: 1000 + 8 ICMP + 20 IP = 1028 byte)
$ ping -s 1000 google.com

# MTU testi için büyük paket
$ ping -s 1472 -M do google.com
# -M do: "Don't Fragment" bayrağı set eder
# Eğer paket çok büyükse "Message too long" hatası alırsınız
```

**MTU Keşfi Örneği:**
```bash
# Ethernet MTU'su genelde 1500 byte
# ICMP için maksimum veri: 1500 - 20 (IP) - 8 (ICMP) = 1472

$ ping -s 1472 -M do google.com  # Geçer
$ ping -s 1473 -M do google.com  # Fragmentation needed hatası
```

#### 4. TTL Değerini Ayarlama (-t / -ttl)
```bash
# TTL=5 ile gönder
$ ping -t 5 google.com

# Sonuç: Muhtemelen "Time to live exceeded" alırsınız
# Çünkü 5 hop yetmez
```

**Traceroute Mantığı:** TTL'yi artırarak hangi routerdan geçtiğini öğrenme
```bash
$ ping -t 1 google.com  # İlk router'dan cevap gelir
$ ping -t 2 google.com  # İkinci router'dan cevap gelir
$ ping -t 3 google.com  # Üçüncü router'dan cevap gelir
```

#### 5. Flood Ping (-f) - Dikkatli Kullanılmalı!
```bash
# Mümkün olan en hızlı şekilde ping gönder (root gerektirir)
$ sudo ping -f google.com

PING google.com (172.217.169.46) 56(84) bytes of data.
....^C
--- google.com ping statistics ---
50000 packets transmitted, 49998 received, 0.004% packet loss
```

**Uyarı:** Bu, DoS saldırısı olarak algılanabilir! Sadece test ortamlarında kullanın.

#### 6. Zaman Damgası (-D / --timestamp)
```bash
$ ping -D google.com

[1701358421.123456] 64 bytes from lhr25s34-in-f14.1e100.net: icmp_seq=1 ttl=117 time=15.2 ms
[1701358422.234567] 64 bytes from lhr25s34-in-f14.1e100.net: icmp_seq=2 ttl=117 time=14.9 ms
```

**Kullanım:** Log analizi ve zaman ilişkili sorunları tespit etme

#### 7. Kaynak Adresi Belirleme (-I / --interface)
```bash
# Belirli bir network interface'den ping gönder
$ ping -I eth0 google.com

# Veya kaynak IP belirt
$ ping -I 192.168.1.100 google.com
```

**Senaryo:** Çoklu network interface'li sistemlerde (örn: VPN + normal bağlantı)

#### 8. IPv6 Ping
```bash
# IPv6 adresi ping'le
$ ping6 google.com
# veya
$ ping -6 google.com

PING google.com(lhr25s35-in-x0e.1e100.net (2a00:1450:4009:81a::200e)) 56 data bytes
64 bytes from lhr25s35-in-x0e.1e100.net (2a00:1450:4009:81a::200e): icmp_seq=1 ttl=119 time=16.3 ms
```

#### 9. Sessiz Mod ve Verbose (-q / -v)
```bash
# Sadece özet istatistikleri göster
$ ping -c 10 -q google.com

--- google.com ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9013ms
rtt min/avg/max/mdev = 14.234/15.123/16.789/0.891 ms

# Detaylı çıktı
$ ping -v google.com
```

#### 10. Timeout Ayarlama (-W / --timeout)
```bash
# Her paket için 2 saniye bekle
$ ping -W 2 -c 3 192.168.1.99

# Eğer host cevap vermezse:
PING 192.168.1.99 (192.168.1.99) 56(84) bytes of data.

--- 192.168.1.99 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 6000ms
```
<!-- </HIDE_DEV_TO> -->


### Gerçek Dünya Ping Örnekleri ve Analiz

#### Örnek 1: Sağlıklı Bağlantı
```bash
$ ping -c 5 google.com

PING google.com (142.250.185.46) 56(84) bytes of data.
64 bytes from lhr25s35-in-f14.1e100.net: icmp_seq=1 ttl=117 time=14.2 ms
64 bytes from lhr25s35-in-f14.1e100.net: icmp_seq=2 ttl=117 time=13.9 ms
64 bytes from lhr25s35-in-f14.1e100.net: icmp_seq=3 ttl=117 time=14.1 ms
64 bytes from lhr25s35-in-f14.1e100.net: icmp_seq=4 ttl=117 time=14.3 ms
64 bytes from lhr25s35-in-f14.1e100.net: icmp_seq=5 ttl=117 time=14.0 ms

--- google.com ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4006ms
rtt min/avg/max/mdev = 13.937/14.100/14.318/0.143 ms
```

**Analiz:**
> ✅ %0 paket kaybı - Mükemmel \
    ✅ RTT tutarlı (~14ms) - Stabil bağlantı \
    ✅ Düşük mdev (0.143ms) - Çok az jitter \
    ✅ TTL=117 - Normal (başlangıç muhtemelen 128, 11 hop geçilmiş)

**Sonuç:** Sağlıklı internet bağlantısı

#### Örnek 2: Paket Kaybı Var
```bash
$ ping -c 10 instable-server.com

PING instable-server.com (203.0.113.45) 56(84) bytes of data.
64 bytes from 203.0.113.45: icmp_seq=1 ttl=54 time=45.2 ms
64 bytes from 203.0.113.45: icmp_seq=3 ttl=54 time=89.7 ms
64 bytes from 203.0.113.45: icmp_seq=5 ttl=54 time=52.3 ms
64 bytes from 203.0.113.45: icmp_seq=7 ttl=54 time=145.2 ms
64 bytes from 203.0.113.45: icmp_seq=10 ttl=54 time=67.8 ms

--- instable-server.com ping statistics ---
10 packets transmitted, 5 received, 50% packet loss, time 9145ms
rtt min/avg/max/mdev = 45.234/80.040/145.234/35.123 ms
```

**Analiz:**
> ❌ %50 paket kaybı - Ciddi sorun! \
    ❌ Yüksek RTT değişkenliği (mdev=35.123ms) - İstikrarsız bağlantı \
    ❌ Eksik sequence numaraları (2,4,6,8,9 kayıp) - Rastgele paket kaybı

**Olası Nedenler:**
- Ağ tıkanıklığı
- Düşük kaliteli ISP bağlantısı
- Kablosuz sinyal sorunları
- Router/firewall yük altında

**Çözüm Önerileri:**
1. Diğer sunuculara ping at (problem izole mi?)
2. MTR kullanarak hangi hop'ta kayıp olduğunu bul
3. ISP ile iletişime geç

<!-- <HIDE_DEV_TO> -->
{{< accordion title="🤖 Prompt Guide: AI ile Ping Çıktısını Analiz Et" >}}

Bu ping çıktısını bir AI asistanına (ChatGPT, Claude vb.) gönderirken kullanabileceğiniz prompt:

```
Aşağıdaki ping komutunun çıktısını analiz et ve şunları söyle:

1. Bağlantı durumu nedir? (Sağlıklı/Sorunlu/Kritik)
2. Paket kaybı varsa neden olabilir?
3. RTT (gecikme) değerleri normal mi?
4. Jitter (gecikme değişkenliği) problemi var mı?
5. Hangi adımları atmalıyım?

Ping çıktısı:
[Buraya ping çıktısını yapıştır]
```

**Kullanım İpuçları:**
- Ping çıktısının tamamını (istatistikler dahil) kopyalayın
- Ağ bağlantınız (WiFi/Ethernet/Mobil) hakkında bilgi ekleyin
- Sorunun ne zaman başladığını belirtin

{{< /accordion >}}


#### Örnek 3: Yüksek Gecikme (Latency)
```bash
$ ping -c 5 australia-server.com

PING australia-server.com (203.0.113.89) 56(84) bytes of data.
64 bytes from 203.0.113.89: icmp_seq=1 ttl=48 time=287.3 ms
64 bytes from 203.0.113.89: icmp_seq=2 ttl=48 time=289.1 ms
64 bytes from 203.0.113.89: icmp_seq=3 ttl=48 time=288.5 ms
64 bytes from 203.0.113.89: icmp_seq=4 ttl=48 time=287.9 ms
64 bytes from 203.0.113.89: icmp_seq=5 ttl=48 time=288.2 ms

--- australia-server.com ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4007ms
rtt min/avg/max/mdev = 287.345/288.200/289.123/0.643 ms
```

**Analiz:**
> ✅ %0 paket kaybı - İyi \
    ✅ Tutarlı gecikme (mdev=0.643ms) - Stabil \
    ⚠️ Yüksek RTT (~288ms) - Coğrafi uzaklık

**Sonuç:** Normal durum - Türkiye'den Avustralya'ya mesafe etkisi
- Işık hızı limiti: ~40.000 km'yi ışık ~133ms'de alır
- Routing overhead, işleme süreleri vs.

{{< accordion title="💡 İpucu: Coğrafi Gecikme Hesaplama" >}}

**Hızlı Hesaplama Formülü:**

```
Mesafe (km) ÷ 200,000 = Minimum Gecikme (saniye)

Örnekler:
- İstanbul → Londra: 2,500 km → ~12.5 ms (teorik)
- İstanbul → Tokyo: 9,000 km → ~45 ms (teorik)
- İstanbul → New York: 8,000 km → ~40 ms (teorik)
```

**Not:** Gerçek gecikme genelde teorik değerin 2-3 katıdır çünkü:
- Paketler düz çizgide gitmez (routing)
- Her router işleme gecikmesi ekler
- Fiber optik ışıktan %33 daha yavaştır

{{< /accordion >}}

#### Örnek 4: Host Ulaşılamıyor
```bash
$ ping 192.168.1.250

PING 192.168.1.250 (192.168.1.250) 56(84) bytes of data.
From 192.168.1.1 icmp_seq=1 Destination Host Unreachable
From 192.168.1.1 icmp_seq=2 Destination Host Unreachable
From 192.168.1.1 icmp_seq=3 Destination Host Unreachable
^C
--- 192.168.1.250 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2048ms
```

**Analiz:**
> ❌ Gateway (192.168.1.1) "Destination Host Unreachable" döndürüyor \
    ❌ %100 paket kaybı

**Olası Nedenler:**
- Host kapalı
- Yanlış IP adresi
- Host farklı bir subnet'te
- Firewall tamamen ICMP'yi bloke ediyor

#### Örnek 5: Request Timeout (Firewall)
```bash
$ ping 8.8.8.8

PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
(sessizlik... hiçbir cevap yok)
^C
--- 8.8.8.8 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4096ms
```

**Analiz:**
> ❌ Hiçbir cevap yok (ICMP mesajı bile yok) \
    ❌ %100 kayıp ama "Unreachable" mesajı da yok

**Fark:** "Unreachable" vs "Timeout"
- **Unreachable:** Router aktif olarak reddediyor
- **Timeout:** Sessizlik - muhtemelen firewall drop ediyor

**Sonuç:** Hedef veya ara bir firewall ICMP'yi sessizce drop ediyor

#### Örnek 6: Fragmentasyon Sorunu
```bash
$ ping -s 1500 -M do cloudflare.com

PING cloudflare.com (104.16.132.229) 1500(1528) bytes of data.
ping: local error: message too long, mtu=1500
ping: local error: message too long, mtu=1500
^C
```

**Analiz:**
> ❌ Paket MTU'dan büyük ve fragmentasyon yasak (-M do bayrağı)

**Çözüm:**
```bash
# MTU'ya uygun boyutta gönder
$ ping -s 1472 -M do cloudflare.com
PING cloudflare.com (104.16.132.229) 1472(1500) bytes of data.
1480 bytes from 104.16.132.229: icmp_seq=1 ttl=58 time=8.23 ms
```

<!-- </HIDE_DEV_TO> -->

### Ping ile Sorun Giderme Stratejisi

**Sistematik Yaklaşım:**

```
1. Loopback test:
   $ ping 127.0.0.1
   ✓ TCP/IP stack çalışıyor mu?

2. Yerel makine:
   $ ping $(hostname -I)
   ✓ Network interface aktif mi?

3. Gateway:
   $ ping 192.168.1.1
   ✓ Yerel ağa ulaşabiliyor muyum?

4. DNS sunucusu:
   $ ping 8.8.8.8
   ✓ İnternet bağlantım var mı?

5. Domain name:
   $ ping google.com
   ✓ DNS çözümleme çalışıyor mu?

6. Hedef sunucu:
   $ ping target-server.com
   ✓ Hedef erişilebilir mi?
```

---

## MTR: My Traceroute - Gelişmiş Ağ Tanılama Aracı

### MTR Nedir?

**MTR (My TraceRoute)**, ping ve traceroute'un güçlü bir kombinasyonudur. Matt Kimball tarafından geliştirilmiş, gerçek zamanlı olarak ağ yolunu ve her hop'taki performansı izler.

> MTR aynı zamanda "Matt's TraceRoute" olarak da bilinir.

### MTR vs Ping vs Traceroute

| Özellik | Ping | Traceroute | MTR |
|---------|------|------------|-----|
| Hedef testi | ✅ | ❌ | ✅ |
| Yol gösterimi | ❌ | ✅ | ✅ |
| Her hop istatistiği | ❌ | ❌ | ✅ |
| Gerçek zamanlı | ✅ | ❌ | ✅ |
| Paket kaybı analizi | ✅ | ❌ | ✅ |
| Interaktif | ❌ | ❌ | ✅ |

### MTR Nasıl Çalışır?

MTR, traceroute'un TTL hilesi ile ping'in sürekli izleme yeteneğini birleştirir:

```
1. TTL=1 ile ICMP/UDP paketi gönder
   → İlk router "Time Exceeded" döner
   → İlk hop belirlendi

2. TTL=2 ile paket gönder
   → İkinci router "Time Exceeded" döner
   → İkinci hop belirlendi

3. ... Bu şekilde devam eder

4. Her hop'a sürekli ping atar
   → Paket kaybı, gecikme, jitter hesaplar
   → Gerçek zamanlı istatistikler günceller
```

### MTR Kurulumu

{{< tabs titles="Debian/Ubuntu|RHEL/CentOS/Fedora|macOS|Windows" >}}

{{< tab index="0" >}}
```bash
sudo apt-get install mtr
{{< /tab >}} {{< tab index="1" >}}
sudo yum install mtr
{{< /tab >}} {{< tab index="2" >}}
brew install mtr
{{< /tab >}} {{< tab index="3" >}} WinMTR indir: https://sourceforge.net/projects/winmtr/ {{< /tab >}}

{{< /tabs >}}

### Temel MTR Kullanımı

#### Basit Kullanım
```bash
$ mtr google.com

# Veya report modu
$ mtr --report --report-cycles 10 google.com
```

**Interaktif Arayüz:**
```
                             My traceroute  [v0.95]
localhost (192.168.1.100)                          2024-11-25T10:30:45+0000
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                       Packets               Pings
 Host                                Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. _gateway (192.168.1.1)            0.0%    10    1.2   1.3   1.1   1.8   0.2
 2. 10.20.30.1                        0.0%    10    8.4   9.1   7.9  12.3   1.4
 3. 81.213.147.1                      0.0%    10   12.3  13.2  11.8  16.7   1.6
 4. 195.175.193.141                   0.0%    10   14.5  15.1  13.9  18.2   1.3
 5. 72.14.223.66                      0.0%    10   15.2  16.0  14.8  19.1   1.5
 6. 108.170.252.193                   0.0%    10   15.8  16.5  15.1  19.8   1.6
 7. 142.251.226.67                    0.0%    10   16.1  16.8  15.4  20.2   1.7
 8. lhr25s35-in-f14.1e100.net         0.0%    10   15.9  16.4  15.2  19.5   1.4
```

**Sütun Açıklamaları:**

| Sütun | Açıklama |
|-------|----------|
| **Host** | Her hop'taki router/host (IP + hostname) |
| **Loss%** | O hop'ta paket kaybı yüzdesi |
| **Snt** | Gönderilen toplam paket sayısı |
| **Last** | Son paketin round-trip time'ı |
| **Avg** | Ortalama RTT |
| **Best** | En iyi (minimum) RTT |
| **Wrst** | En kötü (maksimum) RTT |
| **StDev** | Standart sapma (jitter göstergesi) |

{{< accordion title="Daha basit raporlarma" >}}
```bash
mtr --report -n -c 50 cyclechain.io | grep -v "Start" | awk 'NR==1 {next} {printf "%-20s \t Kayıp: %-6s \t Ping: %s ms\n", $2, $3, $6}'
```

```
HEDEF (HOST)                   KAYIP      ORTALAMA(ms)
???                            100.0      0.0       
10.68.131.192                  0.0%       1.4       
138.197.249.56                 0.0%       0.6       
143.244.192.116                0.0%       0.5       
143.244.224.118                0.0%       0.7       
143.244.224.115                4.0%       0.4       
162.158.84.196                 0.0%       5.3       
162.158.84.55                  0.0%       3.4       
104.26.6.74                    0.0%       1.1
```

{{< /accordion >}}

### MTR Parametreleri

#### 1. Report Modu (-r / --report)
```bash
# 100 paket gönder ve rapor üret
$ mtr --report --report-cycles 100 google.com

Start: 2024-11-25T10:30:45+0000
HOST: localhost                   Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway                   0.0%   100    1.2   1.3   1.0   3.2   0.3
  2.|-- 10.20.30.1                 0.0%   100    8.5   9.2   7.8  15.6   1.5
  3.|-- 81.213.147.1               0.0%   100   12.4  13.3  11.7  22.1   2.1
  4.|-- 195.175.193.141            0.0%   100   14.6  15.2  13.8  24.5   2.3
  5.|-- 72.14.223.66               1.0%   100   15.3  16.1  14.7  28.9   2.8
  6.|-- 108.170.252.193            0.0%   100   15.9  16.6  15.0  26.7   2.4
  7.|-- 142.251.226.67             0.0%   100   16.2  16.9  15.3  29.3   2.9
  8.|-- lhr25s35-in-f14.1e100.net  0.0%   100   16.0  16.5  15.1  27.8   2.6
```

**Kullanım:** Scriptlerde kullanım, log analizi

#### 2. Interval Ayarlama (-i / --interval)
```bash
# Her 5 saniyede bir paket gönder (varsayılan 1 saniye)
$ mtr -i 5 google.com

# Hızlı mod: 0.1 saniye (root gerektirir)
$ sudo mtr -i 0.1 google.com
```

#### 3. Paket Boyutu (-s / --psize)
```bash
# 1000 byte'lık paketler gönder
$ mtr -s 1000 google.com
```

#### 4. IP Versiyon Seçimi (-4 / -6)
```bash
# IPv4 zorla
$ mtr -4 google.com

# IPv6 zorla
$ mtr -6 google.com
```

#### 5. TCP veya UDP Kullanımı (-T / -u)
```bash
# TCP kullan (varsayılan ICMP)
$ mtr -T -P 80 google.com
# -P: Port numarası

# UDP kullan
$ mtr -u google.com
```

**Neden TCP/UDP?**
- Bazı firewall'lar ICMP'yi bloke eder
- TCP/UDP paketleri daha gerçekçi uygulama trafiğini simüle eder

#### 6. Maksimum Hop Sayısı (-m / --max-ttl)
```bash
# Maksimum 20 hop kontrol et (varsayılan 30)
$ mtr -m 20 google.com
```

#### 7. Hostname Çözümlemeyi Devre Dışı Bırakma (-n / --no-dns)
```bash
# DNS lookup yapma, sadece IP göster (daha hızlı)
$ mtr -n google.com

HOST: localhost                   Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- 192.168.1.1                0.0%    10    1.2   1.3   1.1   1.8   0.2
  2.|-- 10.20.30.1                 0.0%    10    8.4   9.1   7.9  12.3   1.4
  3.|-- 81.213.147.1               0.0%    10   12.3  13.2  11.8  16.7   1.6
```

#### 8. AS Number Gösterme (-z / --aslookup)
```bash
# Her hop'un AS (Autonomous System) numarasını göster
$ mtr -z google.com

HOST: localhost                   Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway                   0.0%    10    1.2   1.3   1.1   1.8   0.2
  2.|-- AS15897 10.20.30.1         0.0%    10    8.4   9.1   7.9  12.3   1.4
  3.|-- AS15897 81.213.147.1       0.0%    10   12.3  13.2  11.8  16.7   1.6
  4.|-- AS15169 195.175.193.141    0.0%    10   14.5  15.1  13.9  18.2   1.3
```

**AS Number:** Her ISP/organizasyonun unique internet routing numarası

#### 9. CSV/JSON/XML Çıktı
```bash
# CSV formatında
$ mtr --csv --report -c 10 google.com

# JSON formatında
$ mtr --json --report -c 10 google.com

# XML formatında
$ mtr --xml --report -c 10 google.com
```

#### 10. İnteraktif Modda Kısayollar

```
h - Yardım
d - Display mode değiştir
r - İstatistikleri sıfırla
p - Pause/Unpause
q - Çıkış
```

### Gerçek Dünya MTR Örnekleri ve Analiz

#### Örnek 1: Sağlıklı Bağlantı
```bash
$ mtr --report -c 50 cloudflare.com

Start: 2024-11-25T11:00:00+0000
HOST: localhost                          Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway (192.168.1.1)            0.0%    50    1.1   1.2   0.9   2.1   0.2
  2.|-- 10.20.30.1                        0.0%    50    7.8   8.3   7.2  11.2   0.9
  3.|-- 81.213.147.1                      0.0%    50   11.5  12.1  10.8  15.3   1.1
  4.|-- 195.175.193.141                   0.0%    50   13.2  13.8  12.5  17.8   1.2
  5.|-- 104.16.132.229                    0.0%    50    7.8   8.2   7.1  11.5   1.0
```

**Analiz:**
> ✅ Tüm hop'larda %0 kayıp \
    ✅ Düşük ve tutarlı gecikme \
    ✅ Düşük StDev (jitter yok) \
    ✅ Düz bir performans çizgisi

**Sonuç:** Mükemmel bağlantı kalitesi

#### Örnek 2: Belirli Bir Hop'ta Sorun
```bash
$ mtr --report -c 100 problematic-site.com

HOST: localhost                          Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway                           0.0%   100    1.2   1.3   1.0   2.5   0.2
  2.|-- 10.20.30.1                         0.0%   100    8.4   8.9   7.8  12.1   0.9
  3.|-- 81.213.147.1                      15.0%   100   45.3  52.1  12.3 198.7  34.2
  4.|-- 195.175.193.141                   14.0%   100   56.7  63.4  14.2 215.3  38.9
  5.|-- 203.0.113.1                       13.0%   100   58.9  65.1  15.1 218.9  39.1
  6.|-- target-server.com                 12.0%   100   59.3  65.8  15.5 220.1  39.5
```

**Analiz:**
> ❌ 3. hop'tan itibaren %15 kayıp başlıyor \
    ❌ Yüksek StDev (34-39ms) - Ciddi jitter \
    ❌ Worst case çok yüksek (198-220ms) \
    ⚠️ Kayıp oranı giderek azalıyor (15% → 12%)

**Yorum:**
- **3. hop sorunlu:** Muhtemelen ISP'nin backbone router'ı
- **Kaybın azalması:** Sonraki hop'lar ICMP'ye düşük öncelik veriyor (ICMP rate limiting)
- **Gerçek sorun:** 3. hop - ISP ile iletişime geçilmeli

**Önemli Not:** Eğer sadece son hop'ta kayıp varsa, bu genelde önemsizdir (ICMP rate limiting).

<!-- <HIDE_DEV_TO> -->

#### Örnek 3: Asimetrik Routing
```bash
# İstanbul'dan New York'a
$ mtr --report -c 50 newyork-server.com

HOST: istanbul-host                      Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway                           0.0%    50    1.1   1.2   0.9   2.0   0.2
  2.|-- turk-telekom-router                0.0%    50    8.3   8.8   7.5  12.1   1.0
  3.|-- istanbul-ix                        0.0%    50   12.1  12.7  11.2  15.8   1.1
  4.|-- frankfurt-de3                      0.0%    50   35.2  36.1  34.5  42.3   2.1
  5.|-- london-lhr                         0.0%    50   48.7  49.5  47.8  56.2   2.5
  6.|-- new-york-ewr                       0.0%    50   95.3  96.8  94.2 108.7   3.8
  7.|-- newyork-server.com                 0.0%    50   97.1  98.5  95.8 110.3   3.9

# New York'tan İstanbul'a (reverse path)
# Farklı bir yol kullanılabilir!
```

**Asimetrik Routing:** Gidiş ve dönüş farklı yollar kullanır
- Normalde internet bu şekilde çalışır
- Sorun tespitinde her iki yönü test etmek önemli

#### Örnek 4: ICMP Rate Limiting
```bash
$ mtr --report -c 100 rate-limited.com

HOST: localhost                          Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway                           0.0%   100    1.2   1.3   1.0   2.1   0.2
  2.|-- isp-router-1                       0.0%   100    8.5   9.0   7.9  12.3   1.0
  3.|-- isp-router-2                      20.0%   100   45.2  52.3  12.1 156.7  28.4
  4.|-- tier1-backbone                    25.0%   100   56.3  63.1  14.5 178.9  32.1
  5.|-- tier1-backbone-2                  30.0%   100   58.7  65.4  15.2 189.3  34.5
  6.|-- target-network                     5.0%   100   60.1  66.8  15.8 195.7  35.2
  7.|-- rate-limited.com                   0.0%   100   61.3  67.5  16.1 198.1  35.8
```

**Analiz:**
> ⚠️ Orta hop'larda yüksek kayıp (%20-30) \
    ✅ Hedefte düşük kayıp (%0) \
    ⚠️ Gecikme yüksek ama tutarlı artış

**Yorum:**
- **Yanıltıcı görünüm:** Sanki 3-5. hop'larda sorun var
- **Gerçek durum:** Bu router'lar ICMP rate limiting yapıyor
- **Kanıt:** Hedefte kayıp yok, sadece geçiş noktalarında

**Doğru Yaklaşım:**
```bash
# TCP kullanarak test et
$ mtr -T -P 443 rate-limited.com
# Şimdi gerçek durumu görürsünüz
```

#### Örnek 5: Coğrafi Latency Pattern
```bash
$ mtr --report -c 50 tokyo-server.jp

HOST: istanbul-host                      Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway (TR)                      0.0%    50    1.2   1.3   1.0   2.1   0.2
  2.|-- istanbul-ix (TR)                   0.0%    50   12.3  13.1  11.5  16.7   1.2
  3.|-- frankfurt-de (DE)                  0.0%    50   35.7  36.5  34.8  42.1   2.0
  4.|-- moscow-ru (RU)                     0.0%    50   55.3  56.8  54.2  65.7   3.1
  5.|-- novosibirsk-ru (RU)                0.0%    50   88.5  90.2  87.1 102.3   4.2
  6.|-- vladivostok-ru (RU)                0.0%    50  145.7 147.9 143.2 165.8   6.1
  7.|-- seoul-kr (KR)                      0.0%    50  178.3 180.5 175.9 198.7   7.2
  8.|-- tokyo-jp (JP)                      0.0%    50  195.8 198.2 193.4 215.3   7.8
  9.|-- tokyo-server.jp                    0.0%    50  197.3 199.8 195.1 217.9   7.9
```

**Analiz:**
> ✅ %0 paket kaybı - Sağlıklı \
    ⚠️ Yüksek gecikme - Coğrafi mesafe \
    ✅ Düzenli artış patern - Normal

**Coğrafi Latency Hesabı:**
```
İstanbul → Tokyo: ~9,000 km
Işık hızı (vakumda): 300,000 km/s
Teorik minimum: 9000/300000 = 0.03s = 30ms

Gerçek: ~198ms
Ekstra: 168ms

Neden?
- Fiber optik: ~200,000 km/s (vakumdan yavaş)
- Routing overhead: Düz gitmez, dolambaçlı yol
- Router işleme gecikmesi: Her hop'ta ~1-2ms
- Serialization delay: Paket iletim süresi
```

#### Örnek 6: Packet Loss Pattern Analizi

```bash
$ mtr --report -c 200 unstable-host.com

HOST: localhost                          Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway                           0.0%   200    1.2   1.3   1.0   2.5   0.2
  2.|-- isp-router                         0.0%   200    8.4   8.9   7.8  12.5   1.0
  3.|-- regional-hub                       2.0%   200   15.3  16.1  14.2  45.7   5.2
  4.|-- backbone-router                    2.5%   200   28.7  30.2  27.1  98.3   9.8
  5.|-- international-link                15.0%   200   55.3  68.4  52.8 245.7  35.2
  6.|-- destination-network               18.0%   200   67.8  82.3  65.1 287.9  42.1
  7.|-- unstable-host.com                 20.0%   200   72.5  89.7  68.9 312.4  48.7
```

**Detaylı Analiz:**

1. **1-2. Hop:** Temiz (%0 kayıp)
2. **3-4. Hop:** Minimal kayıp (%2-2.5) - Kabul edilebilir
3. **5. Hop:** Keskin kayıp artışı (%15) - ⚠️ Kritik nokta
4. **6-7. Hop:** Devam eden kayıp - Zincir etkisi

**Sorun Lokalizasyonu:**
```
International Link (5. hop) = Ana sorun kaynağı
- Yüksek StDev (35.2ms) → Jitter sorunu
- %15 kayıp → Ciddi tıkanıklık
- Worst: 245.7ms → Aralıklı spike'lar
```

**Olası Nedenler:**
- Submarine kablo tıkanıklığı
- Peering point sorunları
- BGP route flapping
- DDoS saldırısı etkisi

<!-- </HIDE_DEV_TO> -->


### MTR ile İleri Seviye Kullanım

#### 1. Sürekli Monitoring Script
```bash
#!/bin/bash
# mtr-monitor.sh

TARGET="critical-server.com"
THRESHOLD=5  # %5 kayıp eşiği
LOG_FILE="/var/log/mtr-monitor.log"

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # MTR raporu al
    REPORT=$(mtr --report -c 20 --no-dns $TARGET)

    # Paket kaybını kontrol et
    LOSS=$(echo "$REPORT" | tail -1 | awk '{print $3}' | tr -d '%')
    
    if (( $(echo "$LOSS > $THRESHOLD" | bc -l) )); then
        echo "[$TIMESTAMP] ALERT: Packet loss $LOSS% detected!" >> $LOG_FILE
        echo "$REPORT" >> $LOG_FILE
        
        # E-posta/Slack bildirimi gönder
        # mail -s "Network Alert" admin@cyclechain.io < $LOG_FILE
    fi
    
    sleep 300  # 5 dakikada bir kontrol
done
```

<!-- <HIDE_DEV_TO> -->
#### 2. Çoklu Hedef Karşılaştırma
```bash
#!/bin/bash
# compare-routes.sh

TARGETS=("google.com" "cloudflare.com" "aws.com" "azure.com")

for target in "${TARGETS[@]}"; do
    echo "=== Testing $target ==="
    mtr --report -c 50 "$target"
    echo ""
done
```

#### 3. JSON Çıktısını Parse Etme
```bash
$ mtr --json --report -c 10 google.com > mtr-output.json

# Python ile analiz
$ cat << 'EOF' > parse_mtr.py
import json
import sys

with open('mtr-output.json', 'r') as f:
    data = json.load(f)

print("MTR Analysis Report")
print("=" * 50)

for hop in data['report']['hubs']:
    hop_num = hop['count']
    host = hop['host']
    loss = hop['Loss%']
    avg_rtt = hop['Avg']
    
    print(f"Hop {hop_num}: {host}")
    print(f"  Loss: {loss}%, Avg RTT: {avg_rtt}ms")
    
    if loss > 5.0:
        print(f"  ⚠️  WARNING: High packet loss!")
    
    print()
EOF

python3 parse_mtr.py
```

#### 4. Grafik Oluşturma (mtr + gnuplot)
```bash
# MTR verilerini CSV'ye çevir
$ mtr --csv --report -c 100 google.com > mtr-data.csv

# gnuplot ile grafik
$ cat << 'EOF' > plot.gp
set datafile separator ","
set xlabel "Hop"
set ylabel "Latency (ms)"
set title "Network Latency by Hop"
set grid
set terminal png size 800,600
set output 'mtr-graph.png'

plot 'mtr-data.csv' using 1:5 with linespoints title 'Avg Latency'
EOF

gnuplot plot.gp
```
<!-- </HIDE_DEV_TO> -->

### MTR Çıktısını Yorumlama: Best Practices

#### 1. Paket Kaybı Yorumlama

**Sadece Son Hop'ta Kayıp:**
```
Hop 1-7: 0% loss
Hop 8 (hedef): 10% loss
```
→ **Muhtemelen önemsiz** (ICMP rate limiting)

**Ara Hop'ta Kayıp:**
```
Hop 1-3: 0% loss
Hop 4: 15% loss
Hop 5-8: 15% loss
```
→ **Ciddi sorun** - 4. hop'tan sonraki tüm yol etkileniyor

**Giderek Artan Kayıp:**
```
Hop 1: 0%
Hop 2: 5%
Hop 3: 10%
Hop 4: 15%
```
→ **Zincir etkisi** - İlk sorunlu hop'u bul

#### 2. Latency Pattern Analizi

**Düzenli Artış (Normal):**
```
Hop 1:  1ms
Hop 2: 10ms (+9ms)
Hop 3: 20ms (+10ms)
Hop 4: 30ms (+10ms)
```
→ Her hop benzer gecikme ekliyor - **normal**

**Ani Sıçrama:**
```
Hop 1:  1ms
Hop 2: 10ms
Hop 3: 150ms (+140ms!)
Hop 4: 160ms (+10ms)
```
→ **3. hop'ta sorun** - Uluslararası bağlantı, yük vs.

**Azalan Latency (Anormal):**
```
Hop 1: 50ms
Hop 2: 30ms (???)
Hop 3: 40ms
```
→ **Asimetrik routing** veya **zaman senkronizasyon sorunu**

#### 3. Jitter (StDev) Değerlendirmesi

```
StDev < 5ms:   Mükemmel - Real-time uygulamalar için ideal
StDev 5-20ms:  İyi - Çoğu uygulama için yeterli
StDev 20-50ms: Orta - VoIP'te sorun yaşanabilir
StDev > 50ms:  Kötü - Ciddi istikrarsızlık
```

**VoIP İçin Önemli:**
- Jitter > 30ms → Konuşma kalitesi düşer
- Latency > 150ms → Gecikme hissedilir
- Paket kaybı > 1% → Ses kayıpları

---

<!-- <HIDE_DEV_TO> -->
## Gerçek Dünya Senaryoları ve Sorun Çözme

### Senaryo 1: "İnternet Yavaş" Şikayeti

**İlk Adım: Temel Testler**
```bash
# 1. Yerel ağ testi
$ ping -c 10 192.168.1.1
# Sonuç: Ortalama 1.2ms, %0 kayıp → Yerel ağ OK

# 2. DNS testi
$ ping -c 10 8.8.8.8
# Sonuç: Ortalama 85ms, %15 kayıp → Problem var!

# 3. MTR ile detay
$ mtr --report -c 50 8.8.8.8
```

**MTR Çıktısı:**
```
HOST: laptop                             Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- 192.168.1.1                       0.0%    50    1.2   1.3   1.0   2.1   0.2
  2.|-- 10.50.123.1                      15.0%    50   45.3  52.8  12.5 198.7  35.2
  3.|-- 81.213.x.x                       15.0%    50   56.2  63.4  15.1 215.8  38.1
  4.|-- 8.8.8.8                          15.0%    50   87.5  94.2  80.3 234.5  42.3
```

**Teşhis:**
- Gateway sonrası hemen sorun başlıyor (2. hop)
- %15 tutarlı kayıp
- Yüksek jitter (StDev ~35-42ms)

**Çözüm:**
1. ISP router'ını yeniden başlat
2. Düzelmezse ISP ile iletişime geç
3. 2. hop'taki ISP cihazının loglarını incele

### Senaryo 2: Website Bazen Açılıyor, Bazen Açılmıyor

**Test:**
```bash
# 30 dakika boyunca sürekli izle
$ mtr --report -c 1800 problematic-website.com
```

**MTR Çıktısı (Excerpt):**
```
HOST: laptop                             Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- gateway                            0.0%  1800    1.2   1.3   1.0   2.3   0.2
  2.|-- isp                                0.0%  1800    8.4   8.9   7.8  12.5   0.9
  3.|-- backbone-1                         0.0%  1800   15.3  16.2  14.5  25.7   2.1
  4.|-- backbone-2                         0.0%  1800   28.7  30.1  27.3  45.8   3.2
  5.|-- cdn-edge                           3.5%  1800   35.2  38.7  33.1 456.7  28.9
  6.|-- problematic-website.com            5.0%  1800   37.8  42.3  35.7 489.2  32.1
```

**Gözlem:**
- CDN edge'de aralıklı sorun (%3.5 kayıp)
- Çok yüksek worst-case latency (456-489ms)
- Yüksek StDev → Intermittent sorun

**Analiz:**
```bash
# CDN edge'in AS numarasını öğren
$ mtr -z --report -c 10 problematic-website.com

# Farklı CDN edge'den test et (DNS üzerinden)
$ dig problematic-website.com +short
203.0.113.50
203.0.113.51
203.0.113.52

$ mtr --report -c 50 203.0.113.51
$ mtr --report -c 50 203.0.113.52
```

**Çözüm:**
- CDN sağlayıcıyla iletişime geç
- Alternatif CDN edge kullan
- Geçici çözüm: `/etc/hosts` dosyasına sabit IP ekle

### Senaryo 3: VoIP Çağrı Kalitesi Düşük

**Gereksinimler:**
- Latency < 150ms
- Jitter < 30ms
- Packet loss < 1%

**Test:**
```bash
# VoIP sunucusunu test et
$ mtr --report -c 200 voip.company.com
```

**MTR Çıktısı:**
```
HOST: office-pc                          Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- office-gateway                     0.0%   200    0.8   0.9   0.7   1.5   0.1
  2.|-- datacenter-switch                  0.0%   200    2.3   2.5   2.1   4.2   0.3
  3.|-- datacenter-router                  0.0%   200    3.1   3.4   2.9   5.7   0.4
  4.|-- voip.company.com                   0.0%   200    4.2   4.6   4.0   7.8   0.5
```

**Analiz:**
- ✅ Latency: 4.6ms ortalama - Mükemmel
- ✅ Jitter: 0.5ms StDev - Mükemmel
- ✅ Packet loss: %0 - Mükemmel

**Ama problem var!** Farklı bir yöntem deneyelim:

```bash
# UDP ile test et (VoIP UDP kullanır)
$ mtr -u --report -c 200 voip.company.com

HOST: office-pc                          Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- office-gateway                     0.0%   200    0.9   1.0   0.8   1.6   0.1
  2.|-- datacenter-switch                  0.5%   200    2.4   2.6   2.2   8.9   0.9
  3.|-- datacenter-router                  1.2%   200    3.2   4.8   3.0  45.7   5.2
  4.|-- voip.company.com                   2.5%   200    4.5   6.3   4.1  67.8   8.7
```

**Yeni Bulgular:**
> ❌ UDP ile %2.5 kayıp - Eşik aşıldı \
    ❌ Jitter: 8.7ms - Hala kabul edilebilir ama yükseliyor \
    ⚠️ Router'da QoS sorunu olabilir

**Çözüm:**
1. QoS (Quality of Service) politikalarını kontrol et
2. VoIP trafiğine öncelik ver
3. Datacenter router konfigürasyonunu incele

### Senaryo 4: Belirli Saatlerde Yavaşlama

**Monitoring Script:**
```bash
#!/bin/bash
# hourly-mtr.sh

TARGET="critical-app.com"
LOG_DIR="/var/log/mtr-hourly"

mkdir -p $LOG_DIR

while true; do
    TIMESTAMP=$(date '+%Y%m%d-%H%M')
    OUTPUT_FILE="$LOG_DIR/mtr-$TIMESTAMP.txt"
    
    echo "=== MTR Report: $(date) ===" > $OUTPUT_FILE
    mtr --report -c 100 $TARGET >> $OUTPUT_FILE
    
    # Kayıp analizi
    LOSS=$(tail -1 $OUTPUT_FILE | awk '{print $3}' | tr -d '%')
    AVG_RTT=$(tail -1 $OUTPUT_FILE | awk '{print $6}')
    
    echo "Loss: $LOSS%, Avg RTT: $AVG_RTT ms" >> $OUTPUT_FILE
    
    sleep 3600  # Her saat
done
```

**Analiz:**
```bash
# Tüm logları analiz et
$ for file in /var/log/mtr-hourly/*.txt; do
    echo -n "$(basename $file): "
    grep "Loss:" $file
done

mtr-20241125-0800.txt: Loss: 0.0%, Avg RTT: 15.3 ms
mtr-20241125-0900.txt: Loss: 0.5%, Avg RTT: 18.7 ms
mtr-20241125-1000.txt: Loss: 12.0%, Avg RTT: 89.3 ms  # ← Problem!
mtr-20241125-1100.txt: Loss: 15.0%, Avg RTT: 102.7 ms # ← Problem devam ediyor
mtr-20241125-1200.txt: Loss: 2.0%, Avg RTT: 22.1 ms
```

**Bulgu:** 10:00-11:00 arası ciddi düşüş
**Olası Neden:** Peak hours, backup işlemi, scheduled task

### Senaryo 5: Multi-Path Routing Tespiti

Bazen paketler farklı yollardan gider:

```bash
# 10 kez art arda MTR çalıştır
$ for i in {1..10}; do
    echo "=== Run $i ==="
    mtr --report -c 5 cyclechain.io | grep "cyclechain.io"
    sleep 2
done

=== Run 1 ===
8.|-- cyclechain.io  0.0% 5  45.2  46.1  44.8  48.3  1.2
=== Run 2 ===
9.|-- cyclechain.io  0.0% 5  87.5  88.2  86.9  90.1  1.1  # ← Farklı!
=== Run 3 ===
8.|-- cyclechain.io  0.0% 5  44.9  45.7  44.1  47.8  1.3
```

**Gözlem:** 
- Run 2'de bir hop fazla (9 vs 8)
- Latency çok farklı (88ms vs 45ms)

**Açıklama:** Load balancing - Farklı path'ler kullanılıyor
**Bu normal mi?** Evet, modern internetin bir özelliği!

---

## İleri Seviye İpuçları ve Best Practices

### 1. ICMP'yi Optimize Etme

**Linux Kernel Parametreleri:**
```bash
# ICMP rate limiting ayarları
sudo sysctl -w net.ipv4.icmp_ratelimit=1000
sudo sysctl -w net.ipv4.icmp_ratemask=6168

# ICMP echo ignore (ping'e cevap verme)
sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0  # 0=cevap ver, 1=verme

# ICMP echo ignore broadcast
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1  # Smurf saldırısına karşı
```

### 2. Firewall ve ICMP

**iptables Kuralları:**
```bash
# ICMP'yi tamamen bloke etme (önerilmez!)
sudo iptables -A INPUT -p icmp -j DROP

# Sadece ping cevabını bloke et
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Rate limiting ile izin ver (önerilen)
sudo iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Tüm ICMP tiplerini kontrollü şekilde izin ver
sudo iptables -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/s -j ACCEPT
```

### 3. MTR vs Traceroute

**Traceroute:**
```bash
$ traceroute google.com

traceroute to google.com (142.250.185.46), 30 hops max, 60 byte packets
 1  _gateway (192.168.1.1)  1.234 ms  1.189 ms  1.156 ms
 2  10.20.30.1 (10.20.30.1)  8.456 ms  8.423 ms  8.389 ms
 3  81.213.147.1 (81.213.147.1)  12.567 ms  12.534 ms  12.501 ms
```

**MTR Avantajları:**
- Sürekli güncelleme (real-time)
- İstatistiksel analiz (min/avg/max/StDev)
- Paket kaybı tespiti
- Interaktif mod

**Traceroute Kullanım Alanı:**
- Tek seferlik yol belirleme
- Script'lerde basit output istenmesi
- MTR'nin bulunmadığı sistemler

### 4. Performans İzleme Dashboard

**Prometheus + Grafana ile MTR Monitoring:**

```yaml
# prometheus-mtr-exporter config
targets:
  - name: google
    host: google.com
    interval: 60s
  - name: cloudflare
    host: cloudflare.com
    interval: 60s

# Grafana'da visualize et:
# - Latency timeline
# - Packet loss heatmap
# - Jitter graph
# - Alert rules
```

### 5. Mobil/Uzak Çalışma İçin MTR

**SSH üzerinden MTR çalıştırma:**
```bash
# Sunucuda MTR çalıştır
$ ssh user@remote-server "mtr --report -c 50 google.com"

# Veya interaktif mod
$ ssh -t user@remote-server "mtr google.com"
```

**VPN Önce/Sonra Karşılaştırma:**
```bash
# VPN olmadan
$ mtr --report -c 50 work-server.com > without-vpn.txt

# VPN ile
$ sudo openvpn --config company.ovpn &
$ mtr --report -c 50 work-server.com > with-vpn.txt

# Karşılaştır
$ diff without-vpn.txt with-vpn.txt
```

---
<!-- </HIDE_DEV_TO> -->

## Sonuç

Bu rehberde, internetin temellerinden başlayarak ICMP protokolünü, ping komutunu ve MTR aracını derinlemesine inceledik.

### Öğrendiklerimizin Özeti:

1. **İnternet Mimarisi**
   - Paket anahtarlama sayesinde esnek ve dayanıklı
   - Katmanlı mimari (TCP/IP) modülerlik sağlar
   - Routing, dağıtık zeka ile çalışır

2. **ICMP Protokolü**
   - IP'nin kontrol ve hata bildirimi katmanı
   - Ping, traceroute gibi araçların temeli
   - Güvenlik açısından kontrollü kullanılmalı

3. **Ping Komutu**
   - Basit ama güçlü tanılama aracı
   - Ulaşılabilirlik, gecikme ve kayıp tespiti
   - Sistematik sorun gidermenin ilk adımı

4. **MTR Aracı**
   - Ping + traceroute'un gelişmiş versiyonu
   - Gerçek zamanlı, istatistiksel analiz
   - Ağ sorunlarını lokalize etmede çok etkili

### Mastering Yoda & Kaynaklar:

**RFC Dökümanları:**
- [RFC 791: Internet Protocol (IP)](https://www.rfc-editor.org/rfc/rfc791 "{nofollow} RFC 791 - Internet Protocol")
- [RFC 792: Internet Control Message Protocol (ICMP)](https://www.rfc-editor.org/rfc/rfc792 "{nofollow} RFC 792 - Internet Control Message Protocol")
- [RFC 2151: A Primer On Internet and TCP/IP Tools and Utilities](https://www.rfc-editor.org/rfc/rfc2151 "{nofollow} RFC 2151 - A Primer On Internet and TCP/IP Tools")
- [RFC 4443: Internet Control Message Protocol (ICMPv6)](https://www.rfc-editor.org/rfc/rfc4443 "{nofollow} RFC 4443 - Internet Control Message Protocol for IPv6")

**Kitaplar:**
- ["TCP/IP Illustrated, Volume 1" - W. Richard Stevens](https://www.amazon.com/TCP-Illustrated-Vol-Addison-Wesley-Professional/dp/0201633469 "{nofollow} TCP/IP Illustrated kitabı")
- ["Computer Networks" - Andrew S. Tanenbaum](https://www.amazon.com/Computer-Networks-5th-Andrew-Tanenbaum/dp/0132126952 "{nofollow} Computer Networks kitabı")
- ["The TCP/IP Guide" - Charles M. Kozierok](http://www.tcpipguide.com/ "{nofollow} The TCP/IP Guide web sitesi")

**Online Araçlar:**
- [https://mtr.sh](https://mtr.sh "{nofollow} Web-based MTR aracı") - Web-based MTR
- [https://www.subnet-calculator.com](https://www.subnet-calculator.com "{nofollow} IP hesaplama aracı") - IP hesaplama
- [https://bgp.he.net](https://bgp.he.net "{nofollow} BGP routing bilgi aracı") - BGP routing bilgileri
- [https://ping.pe](https://ping.pe "{nofollow} Global Ping ve MTR görselleştirme aracı") - Global Ping & MTR (Renkli blok görselleştirme)
- [https://www.uptrends.com/tools/traceroute](https://www.uptrends.com/tools/traceroute "{nofollow} Harita üzerinde traceroute gösterimi") - Haritalı Visual Traceroute
- [https://maplatency.com](https://maplatency.com "{nofollow} Dünya geneli ping ısı haritası") - Görsel Ping Isı Haritası (Heatmap)
- [https://toolbox.googleapps.com/apps/dig](https://toolbox.googleapps.com/apps/dig "{nofollow} Google Dig ve Trace aracı") - Google Admin Dig & Trace
- [https://tools.keycdn.com/traceroute](https://tools.keycdn.com/traceroute "{nofollow} Coğrafi konumlu traceroute") - Geo-Location Traceroute
- [https://radar.cloudflare.com](https://radar.cloudflare.com "{nofollow} Gerçek zamanlı internet trafiği ve saldırı haritası") - Cloudflare Radar (Trafik Haritası)
- [https://lg.ring.nlnog.net](https://lg.ring.nlnog.net "{nofollow} NLNOG Looking Glass aracı") - Çoklu Lokasyon Looking Glass (Komut satırı çıktıları)
- [https://threatmap.fortiguard.com](https://threatmap.fortiguard.com "{nofollow} Canlı siber saldırı haritası") - Canlı Siber Tehdit Haritası (Görsel)

### Son Söz

İnternet, insanlık tarihinin en karmaşık ve etkileyici mühendislik başarılarındandır. Dolayısıyla incelediğimiz araçlar, bu devasa yapının sağlığını kontrol etmenin ve sorunları teşhis etmenin en temel yollarındandır.

Ping atmak, sadece bir paketi gönderip cevap beklemek değil; milyarlarca insanı birbirine bağlayan bu ağın bir parçası olmaktır. Her ICMP Echo Request, internetin sinir sisteminde yolculuğa çıkan küçük bir elçidir.

MTR ile ağınızı izlerken, aslında dünyanın dört bir yanına uzanan fiber optik kablolar, dev veri merkezleri ve sayısız router üzerinden akan veri akışını gözlemliyorsunuz.

---

*Son güncelleme: 25 Kasım 2024*
*Yazar: Fatih Mert Doğancan*
*Lisans: Creative Commons BY-SA 4.0*

