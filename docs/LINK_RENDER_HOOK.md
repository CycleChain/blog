# Link Render Hook Kullanım Kılavuzu

Hugo'nun Markdown link render hook'u, tüm Markdown linklerinin HTML'e nasıl dönüştürüleceğini kontrol eder. Bu projede, linkler için otomatik güvenlik özellikleri ve manuel kontrol seçenekleri eklenmiştir.

## Dosya Konumu

```
layouts/_default/_markup/render-link.html
```

## Özellikler

### 1. Otomatik Dış Link İşleme

Tüm dış linkler (http:// veya https:// ile başlayanlar) otomatik olarak şu özellikleri alır:

- `target="_blank"` - Yeni sekmede açılır
- `rel="noopener noreferrer nofollow"` - Güvenlik ve SEO özellikleri

#### Örnek:

**Markdown:**
```markdown
[Google](https://google.com "Arama Motoru")
```

**HTML Çıktısı:**
```html
<a href="https://google.com"
   title="Arama Motoru"
   target="_blank"
   rel="noopener noreferrer nofollow">Google</a>
```

---

### 2. İç Linkler

İç linkler (/ ile başlayanlar veya anchor linkler) otomatik özellik almaz:

#### Örnek:

**Markdown:**
```markdown
[Ana Sayfa](/tr/ "Ana sayfa")
[Yukarı](#top "Yukarı git")
```

**HTML Çıktısı:**
```html
<a href="/tr/" title="Ana sayfa">Ana Sayfa</a>
<a href="#top" title="Yukarı git">Yukarı</a>
```

---

## Manuel Kontrol: Özel İşaretler

Title içinde özel işaretler kullanarak link davranışını manuel olarak kontrol edebilirsiniz. İşaretler otomatik olarak title'dan temizlenir.

### Kullanılabilir İşaretler

| İşaret | Açıklama | HTML Özelliği |
|--------|----------|---------------|
| `{blank}` | Yeni sekmede aç | `target="_blank"` |
| `{nofollow}` | Arama motorları takip etmesin | `rel="nofollow"` |
| `{noopener}` | Yeni pencere güvenliği | `rel="noopener"` |
| `{noreferrer}` | Referrer bilgisi gönderme | `rel="noreferrer"` |

### Örnekler

#### Örnek 1: Sadece nofollow

**Markdown:**
```markdown
[Sponsor](https://sponsor.com "{nofollow} Sponsorumuz")
```

**HTML:**
```html
<a href="https://sponsor.com"
   title="Sponsorumuz"
   target="_blank"
   rel="nofollow">Sponsor</a>
```

> **Not:** Dış link olduğu için `target="_blank"` otomatik eklenir, ama `rel` sadece `nofollow` içerir.

---

#### Örnek 2: Birden fazla işaret

**Markdown:**
```markdown
[Dış Kaynak](https://external.com "{blank}{nofollow}{noreferrer} Dış kaynak açıklaması")
```

**HTML:**
```html
<a href="https://external.com"
   title="Dış kaynak açıklaması"
   target="_blank"
   rel="nofollow noreferrer">Dış Kaynak</a>
```

---

#### Örnek 3: İç linke blank eklemek

İç linkler normalde yeni sekmede açılmaz, ama zorlayabilirsiniz:

**Markdown:**
```markdown
[PDF İndir](/files/document.pdf "{blank} Belge dosyası")
```

**HTML:**
```html
<a href="/files/document.pdf"
   title="Belge dosyası"
   target="_blank">PDF İndir</a>
```

---

#### Örnek 4: Sadece noopener ve noreferrer

**Markdown:**
```markdown
[Güvenli Link](https://example.com "{noopener}{noreferrer} Güvenli harici link")
```

**HTML:**
```html
<a href="https://example.com"
   title="Güvenli harici link"
   target="_blank"
   rel="noopener noreferrer">Güvenli Link</a>
```

---

## Referans Stili Linkler

Hugo'da referans stili linklerde de aynı kurallar geçerlidir:

### Otomatik dış link

**Markdown:**
```markdown
[IANA ICMP Parameters][1]

[1]: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml "Internet Control Message Protocol (ICMP) Parameters"
```

**HTML:**
```html
<a href="https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml"
   title="Internet Control Message Protocol (ICMP) Parameters"
   target="_blank"
   rel="noopener noreferrer nofollow">IANA ICMP Parameters</a>
```

### Manuel kontrol ile

**Markdown:**
```markdown
[RFC 792][rfc]

[rfc]: https://www.rfc-editor.org/rfc/rfc792 "{nofollow} RFC 792 - Internet Control Message Protocol"
```

**HTML:**
```html
<a href="https://www.rfc-editor.org/rfc/rfc792"
   title="RFC 792 - Internet Control Message Protocol"
   target="_blank"
   rel="nofollow">RFC 792</a>
```

---

## Pratik Kullanım Senaryoları

### Senaryo 1: Blog yazısında dış kaynaklar

```markdown
Bu konuda daha fazla bilgi için [MDN Web Docs](https://developer.mozilla.org "Web geliştirme kaynağı") sayfasını ziyaret edebilirsiniz.
```

**Sonuç:** Otomatik olarak yeni sekmede açılır, nofollow eklenir.

---

### Senaryo 2: Sponsor/Reklam linkleri

```markdown
Bu içerik [Acme Corp](https://acme.com "{nofollow} Sponsorumuz Acme Corp") tarafından desteklenmektedir.
```

**Sonuç:** Yeni sekmede açılır, sadece nofollow eklenir (SEO için).

---

### Senaryo 3: İç navigasyon

```markdown
Daha fazla bilgi için [Hakkımızda](/about "Hakkımızda sayfası") sayfasını okuyun.
```

**Sonuç:** Aynı sekmede açılır, ekstra özellik yok.

---

### Senaryo 4: PDF/Dosya indirme

```markdown
Detaylı rapor için [2024 Raporu](/files/report-2024.pdf "{blank} 2024 yılı faaliyet raporu") indirebilirsiniz.
```

**Sonuç:** İç link ama yeni sekmede açılır.

---

## rel Attribute Açıklamaları

### `noopener`
Yeni pencerede açılan sayfa, orijinal sayfanın `window.opener` nesnesine erişemez. Güvenlik açığı önler.

### `noreferrer`
Yeni sayfaya HTTP referrer bilgisi gönderilmez. Gizlilik sağlar.

### `nofollow`
Arama motorlarına bu linkin takip edilmemesi gerektiğini söyler. SEO için önemli (sponsored/user-generated content).

---

## Önemli Notlar

1. **Otomatik davranış devre dışı bırakılamaz**: Tüm dış linkler otomatik olarak `target="_blank"` alır.

2. **İşaretler sadece title'da çalışır**: Link URL'sinde veya link metninde işaret kullanmak işe yaramaz.

3. **İşaretler büyük/küçük harf duyarlı**: `{blank}` çalışır, `{Blank}` veya `{BLANK}` çalışmaz.

4. **Boşluklar önemli değil**: `{blank} {nofollow}` ile `{blank}{nofollow}` aynıdır.

5. **Temizlik otomatik**: İşaretler HTML çıktısında görünmez, sadece title metni kalır.

---

## Test Etme

Hugo sunucusunu çalıştırın ve sayfanın kaynak kodunu kontrol edin:

```bash
hugo server
```

Tarayıcıda sağ tık > "Kaynağı Görüntüle" yaparak HTML çıktısını kontrol edebilirsiniz.

---

## Sorun Giderme

### Problem: İşaretler çalışmıyor

**Çözüm:** Title kısmına yazdığınızdan emin olun:

```markdown
✅ Doğru: [Link](url "{blank} Başlık")
❌ Yanlış: [Link {blank}](url "Başlık")
❌ Yanlış: [Link](url{blank} "Başlık")
```

### Problem: Dış linkler otomatik açılmıyor

**Çözüm:** URL'nin `http://` veya `https://` ile başladığından emin olun:

```markdown
✅ Doğru: https://example.com
❌ Yanlış: example.com
❌ Yanlış: www.example.com
```

### Problem: İç link yeni sekmede açılıyor

**Çözüm:** Title'da yanlışlıkla `{blank}` işareti var mı kontrol edin.

---

## Gelecek Geliştirmeler

Potansiyel eklemeler:

- [ ] Front matter'da global ayarlar
- [ ] Belirli domainler için istisna listesi
- [ ] Özel CSS class ekleme desteği
- [ ] Icon ekleme (dış link ikonu vb.)
