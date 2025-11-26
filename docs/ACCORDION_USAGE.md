# Accordion Shortcode Kullanım Kılavuzu

## Genel Bakış

Bu Hugo blog'unda kullanabileceğiniz özel bir accordion (genişletilebilir) shortcode'u oluşturduk. Bu, okuyucuların tıklayarak açabileceği katlanabilir içerik bölümleri oluşturmanıza olanak tanır.

## Kurulum

Shortcode dosyası şu konumda bulunur:
```
layouts/shortcodes/accordion.html
```

## Temel Kullanım

### Sözdizimi

```markdown
{{< accordion title="Başlık Buraya" >}}

İçerik buraya gelir. Markdown formatında yazabilirsiniz.

- Liste öğeleri
- **Kalın metin**
- `Kod blokları`

{{< /accordion >}}
```

### Örnek 1: Basit Metin

```markdown
{{< accordion title="Daha Fazla Bilgi" >}}

Bu bir genişletilebilir bölümdür. Tıkladığınızda açılır ve kapanır.

{{< /accordion >}}
```

### Örnek 2: Kod Blokları ile

```markdown
{{< accordion title="Kod Örneği" >}}

Python'da Hello World:

\`\`\`python
print("Hello, World!")
\`\`\`

{{< /accordion >}}
```

### Örnek 3: Prompt Guide (AI Yardımı)

```markdown
{{< accordion title="🤖 Prompt Guide: Bu Çıktıyı AI ile Analiz Et" >}}

ChatGPT veya Claude'a şunu sorun:

\`\`\`
Aşağıdaki çıktıyı analiz et ve şunları açıkla:
1. Problem nedir?
2. Nasıl çözülür?

[Çıktınızı buraya yapıştırın]
\`\`\`

{{< /accordion >}}
```

### Örnek 4: İleri Seviye İpuçları

```markdown
{{< accordion title="💡 İleri Seviye İpuçları" >}}

**İpucu 1:** Her zaman `sudo` kullanın

**İpucu 2:** Log dosyalarını kontrol edin:
\`\`\`bash
tail -f /var/log/syslog
\`\`\`

{{< /accordion >}}
```

## Emoji Kullanımı

Başlıklarda emoji kullanarak görsel olarak daha çekici hale getirebilirsiniz:

- 🤖 AI/Bot ile ilgili içerik
- 💡 İpuçları ve püf noktaları
- ⚠️ Uyarılar
- 📝 Notlar
- 🔧 Araçlar ve konfigürasyon
- 📊 Veri ve istatistikler
- 🚀 Gelişmiş özellikler
- ❓ Sık sorulan sorular

## Özelleştirme

### Başlık Değiştirme

`title` parametresini istediğiniz metinle değiştirin:

```markdown
{{< accordion title="İstediğiniz Başlık" >}}
...
{{< /accordion >}}
```

### Stil Değişiklikleri

`layouts/shortcodes/accordion.html` dosyasındaki `<style>` bölümünü düzenleyerek görünümü özelleştirebilirsiniz:

- `.accordion-custom`: Ana kutu stili
- `.accordion-title`: Başlık stili
- `.accordion-content`: İçerik alanı stili
- `.accordion-title:before`: Ok işareti stili

## Kullanım Senaryoları

### 1. Uzun Kod Örnekleri

Makalenin akışını bozmadan uzun kod örnekleri ekleyin:

```markdown
{{< accordion title="Tam Kod Örneği" >}}
\`\`\`python
# Uzun kod burada...
\`\`\`
{{< /accordion >}}
```

### 2. İleri Seviye Açıklamalar

Temel okuyucular için karmaşık detayları gizleyin:

```markdown
{{< accordion title="Teknik Detaylar (İleri Seviye)" >}}
Buffer overflow, memory leak vs...
{{< /accordion >}}
```

### 3. Alternatif Çözümler

Ana metinde bir yöntem gösterip, alternatifleri accordion'da sunun:

```markdown
{{< accordion title="Alternatif Yöntemler" >}}
- Yöntem 2: ...
- Yöntem 3: ...
{{< /accordion >}}
```

### 4. Prompt Engineering Kılavuzları

AI asistanları için hazır promptlar:

```markdown
{{< accordion title="🤖 ChatGPT Prompt'u" >}}
\`\`\`
Bu hatayı analiz et ve çözüm öner:
[Hata mesajı buraya]
\`\`\`
{{< /accordion >}}
```

### 5. Sorun Giderme Adımları

Uzun troubleshooting adımlarını düzenli tutun:

```markdown
{{< accordion title="🔧 Sorun Giderme Adımları" >}}
1. İlk kontrol: ...
2. İkinci adım: ...
3. Son çare: ...
{{< /accordion >}}
```

## En İyi Uygulamalar

1. **Açıklayıcı Başlıklar Kullanın**: Okuyucu içeriği açmadan ne bulacağını bilmeli
2. **Çok Fazla Accordion Kullanmayın**: Sayfada 3-5 taneden fazla olmamalı
3. **İçeriği Kısa Tutun**: Accordion içinde çok uzun metinler koymayın
4. **Emoji ile Kategori Belirtin**: Görsel ipuçları okuyucuya yardımcı olur
5. **İsteğe Bağlı İçerik İçin Kullanın**: Ana akış için gerekli olmayan bilgiler için idealdir

## Tarayıcı Uyumluluğu

Bu accordion `<details>` HTML elementini kullanır, şu tarayıcılarda çalışır:
- ✅ Chrome 12+
- ✅ Firefox 49+
- ✅ Safari 6+
- ✅ Edge 79+
- ✅ Opera 15+

## Sorun Giderme

### Accordion Görünmüyor

1. Shortcode sözdizimini kontrol edin
2. Başlangıç ve bitiş etiketlerinin doğru olduğundan emin olun
3. Hugo sunucusunu yeniden başlatın: `hugo server -D`

### Markdown Render Edilmiyor

İçeriği `{{ .Inner | markdownify }}` ile işlediğimiz için markdown otomatik render edilmelidir. Sorun devam ederse:
- Kod bloklarında backtick'leri escape edin (`\`\`\``)
- İçerikte `{{` veya `}}` karakterleri varsa escape edin

### Stil Çalışmıyor

CSS'in `accordion.html` dosyasında `<style>` etiketi içinde olduğundan emin olun.

## Gelişmiş Özellikler

### Varsayılan Olarak Açık

Accordion'ı varsayılan olarak açık hale getirmek için `accordion.html` dosyasında `<details>` etiketine `open` ekleyin:

```html
<details class="accordion-custom" open>
```

### Birden Fazla Accordion

Ardışık birden fazla accordion kullanabilirsiniz:

```markdown
{{< accordion title="Bölüm 1" >}}
İçerik 1
{{< /accordion >}}

{{< accordion title="Bölüm 2" >}}
İçerik 2
{{< /accordion >}}

{{< accordion title="Bölüm 3" >}}
İçerik 3
{{< /accordion >}}
```

## Örnekler

Blog yazınızda zaten eklediğimiz örneklere bakabilirsiniz:
- [internetin-derinliklerine-icmp-ping-mtr-ag-tanilamanin-anatomisi.tr.md](content/posts/internetin-derinliklerine-icmp-ping-mtr-ag-tanilamanin-anatomisi.tr.md)

---

**Son Güncelleme:** 2025-11-26
**Yazar:** AI Assistant