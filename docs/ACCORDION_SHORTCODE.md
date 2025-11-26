# Accordion Shortcode Kullanım Kılavuzu

Accordion shortcode'u, içeriği genişletilebilir/daraltılabilir bölümler halinde düzenlemek için kullanılır. FAQ, uzun açıklamalar veya detaylı bilgiler için idealdir.

## Dosya Konumu

```
layouts/shortcodes/accordion.html
```

## Temel Kullanım

```markdown
{{< accordion title="Başlık metni buraya" >}}

Accordion içeriği buraya gelir. Markdown formatında yazabilirsiniz.

- Liste öğeleri
- **Kalın metin**
- `Kod bloğu`

{{< /accordion >}}
```

## Parametreler

| Parametre | Gerekli | Açıklama | Örnek |
|-----------|---------|----------|-------|
| `title` | Evet | Accordion başlığı (tıklanabilir) | `"Sıkça Sorulan Sorular"` |

## Örnekler

### Örnek 1: Basit Metin İçeriği

```markdown
{{< accordion title="MTR Nedir?" >}}

MTR (My Traceroute), ping ve traceroute komutlarının işlevselliğini tek bir ağ tanılama aracında birleştiren bir programdır. Gerçek zamanlı olarak ağ bağlantı kalitesini izlemenizi sağlar.

{{< /accordion >}}
```

---

### Örnek 2: Kod Bloğu İçeren

```markdown
{{< accordion title="MTR Kurulum Komutları" >}}

Debian/Ubuntu sistemlerde:

```bash
sudo apt-get update
sudo apt-get install mtr
```

Kurulum sonrası test için:

```bash
mtr google.com
```

{{< /accordion >}}
```

---

### Örnek 3: Liste ve Formatlanmış İçerik

```markdown
{{< accordion title="MTR Özellikleri" >}}

MTR aşağıdaki özellikleri sunar:

1. **Gerçek zamanlı izleme**: Sürekli güncellenen istatistikler
2. **Detaylı analiz**: Her hop için:
   - Paket kaybı yüzdesi
   - Ortalama gecikme
   - Minimum/maksimum değerler
3. **Çoklu protokol desteği**: ICMP, UDP, TCP

> **Not:** Root yetkisi gerektirebilir.

{{< /accordion >}}
```

---

### Örnek 4: FAQ Bölümü

```markdown
## Sıkça Sorulan Sorular

{{< accordion title="MTR neden root yetkisi istiyor?" >}}

MTR, raw socket kullandığı için sistemlerde root yetkisi gerektirir. Alternatif olarak:

```bash
sudo chmod u+s /usr/bin/mtr
```

komutuyla SUID biti ayarlayabilirsiniz.

{{< /accordion >}}

{{< accordion title="MTR sonuçları nasıl okunur?" >}}

MTR çıktısı şu sütunları içerir:

| Sütun | Açıklama |
|-------|----------|
| Host | Hop IP adresi/hostname |
| Loss% | Paket kaybı yüzdesi |
| Snt | Gönderilen paket sayısı |
| Last | Son paketin RTT değeri |
| Avg | Ortalama RTT |
| Best | En iyi (minimum) RTT |
| Wrst | En kötü (maksimum) RTT |

{{< /accordion >}}

{{< accordion title="MTR ve traceroute farkı nedir?" >}}

**MTR:**
- Sürekli çalışır (gerçek zamanlı)
- İstatistiksel veri toplar
- Paket kaybını gösterir
- Dinamik güncelleme yapar

**Traceroute:**
- Tek seferlik çalışır
- Basit hop listesi verir
- İstatistik toplamaz

{{< /accordion >}}
```

---

### Örnek 5: İç İçe İçerik

```markdown
{{< accordion title="Gelişmiş MTR Kullanımı" >}}

### Rapor Modu

```bash
mtr --report --report-cycles 10 google.com
```

### UDP Modu

```bash
mtr --udp google.com
```

### TCP Modu (belirli port)

```bash
mtr --tcp --port 443 google.com
```

### Çıktıyı Kaydetme

```bash
mtr --report --report-cycles 100 google.com > mtr-report.txt
```

**İpucu:** JSON formatında çıktı almak için:

```bash
mtr --json google.com
```

{{< /accordion >}}
```

---

## Stil ve Tema

Accordion shortcode, aşağıdaki CSS değişkenlerini kullanır:

```css
--content-primary: rgb(218, 218, 218);      /* Ana metin rengi */
--content-secondary: rgb(140, 140, 140);    /* Ok işareti rengi */
--background: rgb(20, 20, 20);              /* Başlık arka planı */
--code-background: rgb(30, 30, 30);         /* İçerik arka planı */
--code-border: rgb(50, 50, 50);             /* Kenarlık rengi */
```

### Görsel Özellikler

- **Kapalı durum**: Sağa bakan ok (▶)
- **Açık durum**: Aşağı bakan ok (▶ 90° döner)
- **Hover efekti**: Hafif arka plan renk değişimi
- **Smooth animasyon**: Ok dönme animasyonu (0.3s)

---

## HTML Yapısı

Accordion, standart HTML `<details>` ve `<summary>` elementlerini kullanır:

```html
<details class="accordion-custom">
  <summary class="accordion-title">Başlık</summary>
  <div class="accordion-content">
    İçerik...
  </div>
</details>
```

Bu sayede JavaScript gerektirmez ve SEO dostudur.

---

## Birden Fazla Accordion Kullanımı

Aynı sayfada birden fazla accordion kullanabilirsiniz:

```markdown
## Rehber

{{< accordion title="Adım 1: Kurulum" >}}
Kurulum talimatları...
{{< /accordion >}}

{{< accordion title="Adım 2: Konfigürasyon" >}}
Konfigürasyon detayları...
{{< /accordion >}}

{{< accordion title="Adım 3: Kullanım" >}}
Kullanım örnekleri...
{{< /accordion >}}
```

Her accordion bağımsız çalışır - birden fazla accordion aynı anda açık olabilir.

---

## Önemli Notlar

### 1. Markdown İçerik

Accordion içeriği `markdownify` ile işlenir, yani:

```markdown
✅ Desteklenir:
- Başlıklar (###, ####)
- Listeler (-, *, 1.)
- Kod blokları (```)
- Kalın/italik (**bold**, *italic*)
- Linkler
- Tablolar
- Blockquote (>)
```

### 2. Başlık Formatı

Başlık plain text olmalıdır (Markdown işlenmez):

```markdown
✅ Doğru:
{{< accordion title="MTR Nedir?" >}}

❌ Yanlış (Markdown başlıkta çalışmaz):
{{< accordion title="**MTR** Nedir?" >}}
```

### 3. İç İçe Accordion

Accordion içinde başka accordion kullanmak mümkündür ama önerilmez (UX açısından kafa karıştırıcı).

---

## Erişilebilirlik

Accordion shortcode erişilebilirlik için optimize edilmiştir:

- Klavye ile kullanılabilir (Enter/Space ile aç/kapa)
- Ekran okuyucular doğru çalışır
- Semantik HTML kullanır (`<details>`, `<summary>`)
- ARIA özellikleri otomatik yönetilir

---

## Responsive Davranış

- Mobil cihazlarda düzgün görünür
- Başlık ve içerik padding'leri optimize edilmiştir
- Kod blokları yatay kaydırma yapar (taşma durumunda)

---

## Varsayılan Durum

Accordion varsayılan olarak **kapalıdır**. Açık başlamak isterseniz HTML düzenlemesi gerekir:

```html
<details class="accordion-custom" open>
  <summary class="accordion-title">Başlık</summary>
  <div class="accordion-content">
    İçerik
  </div>
</details>
```

Ancak shortcode üzerinden bu özellik şu an desteklenmemektedir.

---

## Sorun Giderme

### Problem: Accordion açılmıyor

**Çözüm:**
1. Tarayıcı konsolu hatalarını kontrol edin
2. `<details>` elementini desteklemeyen eski tarayıcı kullanıyor olabilirsiniz
3. CSS çakışması olabilir - sayfanın kaynak kodunu kontrol edin

### Problem: İçerik bozuk görünüyor

**Çözüm:**
1. Markdown syntax hatalarını kontrol edin (özellikle kod blokları)
2. Tırnak işaretlerinin doğru kapatıldığından emin olun
3. Hugo sunucusunu yeniden başlatın

### Problem: Stil uygulanmıyor

**Çözüm:**
1. CSS değişkenlerinin tanımlı olduğunu kontrol edin
2. Tema CSS dosyalarını kontrol edin
3. Tarayıcı önbelleğini temizleyin

---

## Best Practices

### 1. Açıklayıcı Başlıklar

```markdown
✅ İyi: "MTR ile ağ sorunları nasıl tespit edilir?"
❌ Kötü: "MTR"
```

### 2. Kısa ve Öz İçerik

Accordion içeriği çok uzun olmamalı. Çok uzunsa sayfaya bölün.

### 3. Mantıksal Sıralama

İlgili accordionları bir araya getirin:

```markdown
## Kurulum

{{< accordion title="Linux Kurulum" >}}...{{< /accordion >}}
{{< accordion title="macOS Kurulum" >}}...{{< /accordion >}}
{{< accordion title="Windows Kurulum" >}}...{{< /accordion >}}

## Kullanım

{{< accordion title="Temel Kullanım" >}}...{{< /accordion >}}
{{< accordion title="Gelişmiş Özellikler" >}}...{{< /accordion >}}
```

### 4. Kod Bloklarında Syntax Highlighting

```markdown
{{< accordion title="Python Örneği" >}}

```python  <!-- Dil belirtilmiş -->
import subprocess
result = subprocess.run(['mtr', '--report', 'google.com'])
` ` `

{{< /accordion >}}
```

---

## Tabs vs Accordion: Ne Zaman Hangisi?

| Kullanım Senaryosu | Tercih |
|-------------------|--------|
| Platform/OS alternatifleri | **Tabs** |
| FAQ bölümü | **Accordion** |
| Kod örnekleri (farklı diller) | **Tabs** |
| Adım adım rehber | **Accordion** |
| Detaylı açıklamalar | **Accordion** |
| Aynı anda 1 şey göster | **Tabs** |
| Birden fazla açık olabilir | **Accordion** |

---

## Gelişmiş Özellikler

### Özel Stil Ekleme

Accordion'a özel stil eklemek isterseniz, `accordion.html` dosyasını düzenleyebilirsiniz:

```html
<details class="accordion-custom my-custom-class">
  ...
</details>
```

### Icon Değiştirme

Ok işaretini değiştirmek için CSS'i düzenleyin:

```css
.accordion-title:before {
  content: '▶';  /* Bunu değiştirin: ▼, ►, ⯈, +, etc. */
}
```

---

## SEO ve Erişilebilirlik Faydaları

1. **Semantik HTML**: `<details>` ve `<summary>` arama motorları tarafından anlaşılır
2. **İçerik indexlenir**: Kapalı bile olsa içerik Google tarafından indexlenir
3. **Klavye erişimi**: TAB ve Enter tuşları ile kullanılabilir
4. **Ekran okuyucu desteği**: ARIA rolleri otomatik yönetilir
5. **Progressive enhancement**: JavaScript olmadan çalışır

---

## Gelecek Geliştirmeler

Potansiyel eklemeler:

- [ ] `open` parametresi (varsayılan açık)
- [ ] Özel icon desteği
- [ ] Grup accordion (sadece biri açık olabilir)
- [ ] Animasyon süresi kontrolü
- [ ] Tema varyantları (success, warning, error)