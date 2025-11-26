# Tabs Shortcode Kullanım Kılavuzu

Tabs shortcode'u, içeriği sekmeler halinde düzenlemek için kullanılır. Özellikle farklı işletim sistemleri veya platformlar için alternatif komutları göstermede idealdir.

## Dosya Konumları

```
layouts/shortcodes/tabs.html
layouts/shortcodes/tab.html
```

## Temel Kullanım

```markdown
{{< tabs titles="Sekme 1|Sekme 2|Sekme 3" >}}

{{< tab index="0" >}}
Birinci sekmenin içeriği
{{< /tab >}}

{{< tab index="1" >}}
İkinci sekmenin içeriği
{{< /tab >}}

{{< tab index="2" >}}
Üçüncü sekmenin içeriği
{{< /tab >}}

{{< /tabs >}}
```

## Parametreler

### `tabs` Shortcode

| Parametre | Gerekli | Açıklama | Örnek |
|-----------|---------|----------|-------|
| `titles` | Evet | Pipe (`\|`) ile ayrılmış sekme başlıkları | `"macOS\|Linux\|Windows"` |
| `id` | Hayır | Benzersiz ID (otomatik oluşturulur) | `"install-tabs"` |

### `tab` Shortcode

| Parametre | Gerekli | Açıklama | Örnek |
|-----------|---------|----------|-------|
| `index` | Evet | Sekme sırası (0'dan başlar) | `"0"`, `"1"`, `"2"` |

## Örnekler

### Örnek 1: İşletim Sistemi Kurulum Komutları

```markdown
### MTR Kurulumu

{{< tabs titles="Linux (Debian/Ubuntu)|Linux (RHEL/Fedora)|macOS|Windows" >}}

{{< tab index="0" >}}
```bash
sudo apt-get update
sudo apt-get install mtr
```
{{< /tab >}}

{{< tab index="1" >}}
```bash
sudo yum install mtr
```
{{< /tab >}}

{{< tab index="2" >}}
```bash
brew install mtr
```
{{< /tab >}}

{{< tab index="3" >}}
WinMTR indir: https://sourceforge.net/projects/winmtr/

GUI aracılığıyla kurulum yapılır.
{{< /tab >}}

{{< /tabs >}}
```

**Görünüm:**
- İlk sekme (index 0) varsayılan olarak aktif
- Kullanıcı sekmelere tıklayarak geçiş yapar
- Smooth animasyon ile içerik değişir

---

### Örnek 2: Programlama Dili Örnekleri

```markdown
### API İsteği Örnekleri

{{< tabs titles="JavaScript|Python|Go|cURL" >}}

{{< tab index="0" >}}
```javascript
fetch('https://api.example.com/data')
  .then(response => response.json())
  .then(data => console.log(data));
```
{{< /tab >}}

{{< tab index="1" >}}
```python
import requests

response = requests.get('https://api.example.com/data')
data = response.json()
print(data)
```
{{< /tab >}}

{{< tab index="2" >}}
```go
resp, err := http.Get("https://api.example.com/data")
if err != nil {
    log.Fatal(err)
}
defer resp.Body.Close()
```
{{< /tab >}}

{{< tab index="3" >}}
```bash
curl -X GET https://api.example.com/data
```
{{< /tab >}}

{{< /tabs >}}
```

---

### Örnek 3: Konfigürasyon Dosyaları

```markdown
### Nginx Konfigürasyonu

{{< tabs titles="HTTP|HTTPS|Reverse Proxy" >}}

{{< tab index="0" >}}
```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        root /var/www/html;
        index index.html;
    }
}
```
{{< /tab >}}

{{< tab index="1" >}}
```nginx
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /etc/ssl/cert.pem;
    ssl_certificate_key /etc/ssl/key.pem;

    location / {
        root /var/www/html;
        index index.html;
    }
}
```
{{< /tab >}}

{{< tab index="2" >}}
```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
    }
}
```
{{< /tab >}}

{{< /tabs >}}
```

---

## Stil ve Tema

Tabs shortcode, aşağıdaki CSS değişkenlerini kullanır:

```css
--content-primary: rgb(218, 218, 218);      /* Ana metin rengi */
--content-secondary: rgb(140, 140, 140);    /* İkincil metin (pasif sekmeler) */
--background: rgb(20, 20, 20);              /* Sekme başlıkları arka planı */
--code-background: rgb(30, 30, 30);         /* İçerik arka planı */
--code-border: rgb(50, 50, 50);             /* Kenarlık rengi */
```

### Özelleştirme

Tema değişkenlerini değiştirerek stilleri özelleştirebilirsiniz:

```css
:root {
  --content-primary: #ffffff;
  --content-secondary: #888888;
  --background: #1a1a1a;
  --code-background: #252525;
  --code-border: #404040;
}
```

---

## Önemli Notlar

### 1. Index Numaralandırma

Index **mutlaka 0'dan başlamalı** ve sıralı olmalıdır:

```markdown
✅ Doğru:
{{< tab index="0" >}}...{{< /tab >}}
{{< tab index="1" >}}...{{< /tab >}}
{{< tab index="2" >}}...{{< /tab >}}

❌ Yanlış:
{{< tab index="1" >}}...{{< /tab >}}  <!-- 0'dan başlamıyor -->
{{< tab index="2" >}}...{{< /tab >}}
{{< tab index="3" >}}...{{< /tab >}}
```

### 2. Titles ve Tab Sayısı

`titles` parametresindeki başlık sayısı, `tab` shortcode sayısıyla eşleşmelidir:

```markdown
✅ Doğru: 3 başlık, 3 tab
{{< tabs titles="A|B|C" >}}
{{< tab index="0" >}}...{{< /tab >}}
{{< tab index="1" >}}...{{< /tab >}}
{{< tab index="2" >}}...{{< /tab >}}
{{< /tabs >}}

❌ Yanlış: 3 başlık, 2 tab
{{< tabs titles="A|B|C" >}}
{{< tab index="0" >}}...{{< /tab >}}
{{< tab index="1" >}}...{{< /tab >}}
{{< /tabs >}}
```

### 3. Pipe (|) Karakteri

Sekme başlıklarını ayırmak için `|` karakterini kullanın. Başlıklarda boşluk olabilir:

```markdown
{{< tabs titles="Linux (Debian)|Linux (Red Hat)|macOS (Homebrew)" >}}
```

### 4. İçerik Formatı

Tab içeriği Markdown formatında yazılabilir:

```markdown
{{< tab index="0" >}}
### Alt başlık

- Liste öğesi 1
- Liste öğesi 2

**Kalın metin** ve *italik metin*

```bash
kod bloğu
` ` `
{{< /tab >}}
```

---

## Responsive Davranış

Tabs shortcode mobil cihazlarda da düzgün çalışır:

- Çok fazla sekme varsa, başlık kısmı yatay kaydırma (scroll) yapar
- Her sekme sığacak kadar genişliği korur (`flex-shrink: 0`)
- Dokunmatik cihazlarda tıklama/dokunma çalışır

---

## JavaScript Davranışı

- Sayfa yüklendiğinde ilk sekme (index 0) otomatik olarak aktiftir
- Kullanıcı bir sekmeye tıkladığında:
  - İlgili sekme aktif hale gelir
  - Diğer sekmeler pasif olur
  - İlgili içerik gösterilir, diğerleri gizlenir
- Her tabs için benzersiz bir ID oluşturulur (çakışma önlenir)

---

## Birden Fazla Tabs Kullanımı

Aynı sayfada birden fazla tabs kullanabilirsiniz:

```markdown
### Kurulum

{{< tabs titles="macOS|Linux|Windows" >}}
{{< tab index="0" >}}brew install tool{{< /tab >}}
{{< tab index="1" >}}apt install tool{{< /tab >}}
{{< tab index="2" >}}choco install tool{{< /tab >}}
{{< /tabs >}}

### Kullanım

{{< tabs titles="Başlangıç|Orta Seviye|İleri Seviye" >}}
{{< tab index="0" >}}Temel komutlar...{{< /tab >}}
{{< tab index="1" >}}Orta seviye örnekler...{{< /tab >}}
{{< tab index="2" >}}İleri seviye kullanım...{{< /tab >}}
{{< /tabs >}}
```

Her tabs bağımsız çalışır.

---

## Sorun Giderme

### Problem: Sekmeler çalışmıyor

**Çözüm:**
1. `tabs` ve `tab` shortcode'larının doğru kapatıldığından emin olun
2. Index numaralarının 0'dan başladığını kontrol edin
3. Tarayıcı konsolu hatalarını kontrol edin

### Problem: Stil uygulanmıyor

**Çözüm:**
1. CSS değişkenlerinin tanımlı olduğunu kontrol edin
2. Hugo sunucusunu yeniden başlatın: `hugo server --disableFastRender`

### Problem: İçerik gösterilmiyor

**Çözüm:**
1. `tab` shortcode'larının `tabs` içinde olduğundan emin olun
2. Markdown syntax hatalarını kontrol edin (özellikle kod blokları)

---

## Best Practices

1. **Anlamlı başlıklar kullanın**: "Tab 1" yerine "Ubuntu", "macOS" gibi açıklayıcı başlıklar tercih edin

2. **Tutarlı içerik**: Her sekmedeki içeriğin benzer yapıda olmasını sağlayın

3. **Fazla sekme kullanmayın**: 5-6 sekmeden fazla olursa kullanıcı deneyimi kötüleşir

4. **Kod bloklarında syntax highlighting**: Dil belirterek kod vurgulama kullanın

```markdown
{{< tab index="0" >}}
```javascript  <!-- Dil belirtilmiş -->
console.log('Hello');
` ` `
{{< /tab >}}
```

---

## Gelişmiş Kullanım

### Özel ID ile Kullanım

Birden fazla tabs'i programatik olarak kontrol etmek isterseniz:

```markdown
{{< tabs titles="A|B|C" id="my-custom-tabs" >}}
...
{{< /tabs >}}
```

Ardından JavaScript ile:

```javascript
const tabs = document.querySelector('[data-tabs-id="my-custom-tabs"]');
// Özel işlemler...
```

---

## Accordion ile Karşılaştırma

| Özellik | Tabs | Accordion |
|---------|------|-----------|
| Kullanım | Aynı anda 1 içerik gösterir | Birden fazla açık olabilir |
| Görünüm | Yatay sekmeler | Dikey liste |
| İdeal kullanım | Platform/dil alternatifleri | FAQ, detaylı açıklamalar |
| Mobil | Kaydırılabilir başlıklar | Daha uygun |
