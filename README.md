# 🚀 XHTTPRelayAzure

**نسخه اختصاصی Azure App Service برای XHTTP Relay** دارای اینستالر ویندوزی، پروفایل‌های بهینه و تنظیمات پیشرفته برای استریم بدون قطعی.

---

## 💎 معرفی پروژه

این نسخه دقیقا برای زمانی طراحی شده که می‌خواهید **XHTTP Relay** را روی سرویس‌های **Azure App Service** اجرا کنید (به جای Vercel یا Netlify).

در این متد، یک Node.js Server دائمی روی App Service بالا می‌آید که:

* فایل‌های استاتیک را از پوشه `public/` سرو می‌کند.
* ترافیک Relay را به سمت Inbound اصلی شما روی `TARGET_DOMAIN` هدایت می‌کند.
* برخلاف نسخه‌های Serverless، محدودیت زمانی (Timeout) اجرایی ندارد.

📢 **کانال اطلاع‌رسانی و نکات فنی:** [@B3hnamR](https://t.me/B3hnamR)

---

## 🛠️ وضعیت فعلی ریپو

> [!IMPORTANT]
> در حال حاضر فقط فایل `README.md` جهت معرفی پروژه کامیت شده است. فایل‌های اجرایی، Installer و سورس اصلی کد ریلی به زودی پس از نهایی‌سازی ساختار منتشر خواهند شد.

---

## ❓ این پروژه چه کار می‌کند؟

این پروژه یک Relay سبک و قدرتمند است که به صورت زیر عمل می‌کند:

1. درخواست کاربر به دامنه اختصاصی Azure شما می‌رسد.
2. مسیرهای عمومی (مثل لندینگ پیج) بررسی می‌شوند.
3. درخواست‌های اصلی به آدرس Upstream شما (مثلاً `https://your-domain.com:443/api`) فوروارد می‌شوند.
4. پاسخ دریافتی به صورت **Stream** و بدون وقفه به کاربر برگردانده می‌شود.

**مسیر جریان ترافیک:**

`User Client` ➔ `Azure App Service` ➔ `TARGET_DOMAIN Inbound`

---

## 📊 مقایسه: چرا Azure؟

برای استفاده‌های سنگین و استریم، Azure معمولاً انتخاب بهتری نسبت به Vercel یا Netlify است.

| ویژگی | Azure App Service | Vercel / Netlify |
| :--- | :--- | :--- |
| **نوع اجرا** | Node.js App (دائمی) | Serverless Functions |
| **محدودیت زمان** | ندارد (مناسب استریم طولانی) | دارد (Duration Limit) |
| **کنترل ترافیک** | بالا و قابل تنظیم | محدود |
| **مناسب برای** | Relay دائمی و سنگین | پروژه‌های کوچک و Rewrite |

---

## ⚙️ پارامترهای ورودی اینستالر

### 🌐 TARGET_DOMAIN

آدرس Inbound اصلی شما (باید همراه با پروتکل و پورت باشد):

* `https://your-domain.com:443`
* `https://sub.example.site:2053`

### 🛣️ RELAY_PATH

مسیری که روی Inbound تنظیم کرده‌اید (مثلا `/api`). در نسخه Azure، این مقدار به صورت خودکار برای کلاینت نهایی هم ست می‌شود.

### 🔑 RELAY_KEY (اختیاری)

اگر امنیت اضافه می‌خواهید، یک پسورد وارد کنید. در این صورت کلاینت باید هدر زیر را بفرستد:

```json
{
  "headers": { "x-relay-key": "YourPassword" }
}
```

---

## ⚡ پروفایل‌های آماده Deploy

اینستالر دارای پروفایل‌های پیش‌فرض برای مدیریت بهتر منابع (مخصوصاً برای اکانت‌های Free Trial) است:

* **⚖️ Trial Balanced (پیشنهادی):** تعادل بین قدرت و هزینه (`SKU B2`)
* **📉 Trial Economy:** برای تست‌های سبک و کم‌هزینه (`SKU B1`)
* **🚀 Trial High Throughput:** بیشترین قدرت در لایه بیسیک (`SKU B3`)
* **🛠️ Custom Build:** تنظیم دستی تمامی پارامترها (SKU, Node Version, Speed Limits)

---

## 📉 تنظیمات سرعت و تایم‌اوت

* **Timeout:** در این نسخه مقدار `UPSTREAM_TIMEOUT_MS` به صورت پیش‌فرض روی `0` (غیرفعال) است تا دانلودهای طولانی قطع نشوند.
* **Speed Limit:** برای سرعت نامحدود، مقادیر `MAX_UP_BPS` و `MAX_DOWN_BPS` روی `0` تنظیم شده‌اند.

---

## 🌍 انتخاب بهترین Region

بر اساس IP سرور مقصد شما، اینستالر بهترین ریجن‌های Azure را پیشنهاد می‌دهد.

* **برای سرورهای اروپا:** `westeurope`, `uksouth`, `northeurope`
* **برای سرورهای خاورمیانه:** `uaenorth`, `qatarcentral`

---

## ⚠️ خطاهای رایج Azure

1. **Throttling Error:** اگر پشت سر هم پلن بسازید، Azure موقتاً شما را محدود می‌کند. چند دقیقه صبر کنید.
2. **SKU Not Allowed:** اگر از اکانت رایگان استفاده می‌کنید، فقط از سری **B** (مثل B1, B2, B3) استفاده کنید. سری Premium در اکانت‌های رایگان معمولاً مسدود است.

---

## 📂 ساختار پروژه

```text
index.js                    # Azure Node relay server
package.json                # npm scripts
Deploy-Azure.ps1            # Windows installer & deploy script
Run-Deploy-Azure.bat        # Easy launcher for Windows
scripts/prepare-build.mjs   # Static frontend generator
public/                     # Generated static frontend
```

---

## 📝 لایسنس

فعلاً لایسنس رسمی برای این ریپو تنظیم نشده است.
