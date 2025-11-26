# Accordion Shortcode - Hızlı Referans

## 📋 Temel Şablon

```markdown
{{< accordion title="Başlık" >}}
İçerik
{{< /accordion >}}
```

---

## 🎨 Kullanım Örnekleri

### 1. 🤖 AI Prompt Guide

```markdown
{{< accordion title="🤖 Prompt Guide: Bu Çıktıyı Analiz Et" >}}

ChatGPT veya Claude'a şunu gönderin:

\`\`\`
Aşağıdaki ping çıktısını analiz et:

1. Bağlantı durumu nedir?
2. Sorun varsa nedeni ne olabilir?
3. Nasıl düzeltebilirim?

[Çıktı buraya]
\`\`\`

**İpuçları:**
- Tüm çıktıyı kopyalayın
- Sisteminizi belirtin (macOS/Linux/Windows)
- Problem detaylarını ekleyin

{{< /accordion >}}
```

---

### 2. 💡 İpuçları ve Püf Noktaları

```markdown
{{< accordion title="💡 İpucu: Hızlı Hesaplama Yöntemi" >}}

**Formül:**

\`\`\`
Değer × 2 = Sonuç
\`\`\`

**Örnek:**
- Input: 50
- Output: 100

{{< /accordion >}}
```

---

### 3. 🔧 Konfigürasyon Örnekleri

```markdown
{{< accordion title="🔧 Konfigürasyon Dosyası Örneği" >}}

**dosya: config.yaml**

\`\`\`yaml
server:
  port: 8080
  host: localhost
database:
  url: postgresql://localhost:5432/mydb
\`\`\`

{{< /accordion >}}
```

---

### 4. ⚠️ Önemli Uyarılar

```markdown
{{< accordion title="⚠️ Dikkat: Güvenlik Uyarısı" >}}

**UYARI:** Bu komutu çalıştırmadan önce:

1. Yedek alın
2. Test ortamında deneyin
3. Log dosyalarını kontrol edin

\`\`\`bash
sudo rm -rf /path/to/data
\`\`\`

{{< /accordion >}}
```

---

### 5. 📝 Ek Notlar

```markdown
{{< accordion title="📝 Teknik Detaylar" >}}

Bu bölüm ileri seviye kullanıcılar içindir.

**Dahili Çalışma:**
- Buffer boyutu: 4KB
- Timeout: 30 saniye
- Retry count: 3

{{< /accordion >}}
```

---

### 6. 📊 Tablo ve Veriler

```markdown
{{< accordion title="📊 Performans Karşılaştırması" >}}

| Yöntem | Hız | Güvenilirlik |
|--------|-----|--------------|
| A      | 10ms| %99.9        |
| B      | 50ms| %95.0        |
| C      | 5ms | %99.99       |

**Sonuç:** Yöntem C en iyisi.

{{< /accordion >}}
```

---

### 7. 🚀 İleri Seviye Özellikler

```markdown
{{< accordion title="🚀 İleri Seviye: Custom Headers" >}}

Gelişmiş kullanıcılar için özel HTTP başlıkları:

\`\`\`bash
curl -H "X-Custom-Header: value" \\
     -H "Authorization: Bearer token" \\
     https://api.example.com
\`\`\`

{{< /accordion >}}
```

---

### 8. ❓ SSS (Sıkça Sorulan Sorular)

```markdown
{{< accordion title="❓ SSS: Neden çalışmıyor?" >}}

**S: Komut çalışmıyor, ne yapmalıyım?**

**C:** Şu adımları deneyin:

1. Syntax hatası kontrol edin
2. İzinleri kontrol edin: `ls -la`
3. Log dosyalarına bakın: `tail -f /var/log/app.log`

{{< /accordion >}}
```

---

### 9. 🎯 Tam Örnek Kombinasyon

```markdown
{{< accordion title="🎯 Komple Çözüm: Adım Adım Kurulum" >}}

### 1. Önkoşullar

\`\`\`bash
sudo apt update
sudo apt install -y python3 pip
\`\`\`

### 2. Kurulum

\`\`\`bash
pip install mypackage
\`\`\`

### 3. Konfigürasyon

config.ini dosyası oluşturun:

\`\`\`ini
[default]
debug = true
port = 8000
\`\`\`

### 4. Çalıştırma

\`\`\`bash
python3 app.py
\`\`\`

**Sorun mu yaşıyorsunuz?** `--verbose` flag'i ekleyin.

{{< /accordion >}}
```

---

### 10. 🌐 Çok Dilli Örnek

```markdown
{{< accordion title="🌐 Diğer Dillerde" >}}

**Python:**
\`\`\`python
print("Hello World")
\`\`\`

**JavaScript:**
\`\`\`javascript
console.log("Hello World");
\`\`\`

**Go:**
\`\`\`go
fmt.Println("Hello World")
\`\`\`

{{< /accordion >}}
```

---

## 🎨 Emoji Referansı

Başlıklarda kullanabileceğiniz emoji'ler:

| Emoji | Kullanım Alanı |
|-------|----------------|
| 🤖    | AI, Bot, Otomasyon |
| 💡    | İpucu, Fikir |
| 🔧    | Konfigürasyon, Ayarlar |
| ⚠️    | Uyarı, Dikkat |
| 📝    | Not, Açıklama |
| 📊    | Veri, İstatistik, Grafik |
| 🚀    | İleri Seviye, Performans |
| ❓    | Soru, SSS |
| 🎯    | Hedef, Çözüm, Komple |
| 🌐    | Çok dilli, Uluslararası |
| 🔒    | Güvenlik |
| 📦    | Paket, Kurulum |
| 🐛    | Hata, Debug |
| ✅    | Onay, Başarı |
| ❌    | Hata, Olumsuz |
| 🔍    | Arama, Analiz |
| 💻    | Kod, Programlama |
| 📚    | Dokümantasyon, Kaynak |
| 🎓    | Eğitim, Öğrenme |
| ⚡    | Hız, Performans |

---

## 🔗 Birden Fazla Accordion

```markdown
{{< accordion title="1️⃣ Adım 1: Hazırlık" >}}
Gerekli dosyaları indirin...
{{< /accordion >}}

{{< accordion title="2️⃣ Adım 2: Kurulum" >}}
Kurulum adımlarını takip edin...
{{< /accordion >}}

{{< accordion title="3️⃣ Adım 3: Test" >}}
Test komutlarını çalıştırın...
{{< /accordion >}}
```

---

## 📋 Kopyala-Yapıştır Şablonlar

### Basit Prompt Guide

```markdown
{{< accordion title="🤖 AI Prompt" >}}
\`\`\`
[Prompt metni buraya]
\`\`\`
{{< /accordion >}}
```

### Kod Örneği

```markdown
{{< accordion title="💻 Kod Örneği" >}}
\`\`\`bash
# Komutlar buraya
\`\`\`
{{< /accordion >}}
```

### Sorun Giderme

```markdown
{{< accordion title="🔧 Sorun Giderme" >}}
1. Adım bir
2. Adım iki
3. Adım üç
{{< /accordion >}}
```

---

**Kullanım Notu:** Backtick karakterlerini (\`) escape etmeyi unutmayın!
