<div align="center">

# 🚀 XHTTPRelayAzure

**نسخه اختصاصی Azure App Service برای XHTTP Relay**  
دارای اینستالر ویندوزی، پروفایل‌های بهینه و تنظیمات پیشرفته برای استریم بدون قطعی.

[![Runtime](https://img.shields.io/badge/RUNTIME-NODE_22_LTS-444444?style=for-the-badge&logo=node.js&logoColor=white)]()
[![Version](https://img.shields.io/badge/VERSION-1.0.0-blueviolet?style=for-the-badge)]()
[![Platform](https://img.shields.io/badge/AZURE-APP_SERVICE-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)]()
[![Installer](https://img.shields.io/badge/WINDOWS_INSTALLER-POWERSHELL-2B579A?style=for-the-badge&logo=powershell&logoColor=white)]()
[![Recommended](https://img.shields.io/badge/RECOMMENDED-TRIAL_BALANCED-2EA44F?style=for-the-badge)]()

**📣 جهت دریافت اطلاعات و نکات بیشتر به کانال تلگرامی من مراجعه کنید:** [B3hnamR@](https://t.me/B3hnamR)

**🔒 [برای ساخت اکانت، مطالعه این آموزش کاملاً ضروری است: Anti-Ban-Tutorial.md](./Anti-Ban-Tutorial.md)**

</div>

---

## 💎 معرفی پروژه

این نسخه دقیقاً برای زمانی طراحی شده که می‌خواهید **XHTTP Relay** را روی سرویس‌های **Azure App Service** اجرا کنید، نه روی Vercel یا Netlify.

در این متد، یک Node.js Server دائمی روی App Service بالا می‌آید که:

* فایل‌های استاتیک را از پوشه `public/` سرو می‌کند.
* ترافیک Relay را به سمت Inbound اصلی شما روی `TARGET_DOMAIN` هدایت می‌کند.
* برای استریم و دانلودهای طولانی، hard timeout داخلی را غیرفعال می‌کند.
* برخلاف نسخه‌های Serverless، برای relay سنگین‌تر و پایدارتر مناسب‌تر است.

---

## ❓ این پروژه چه کار می‌کند؟

این پروژه یک Relay سبک و قدرتمند است که به صورت زیر عمل می‌کند:

1. درخواست کاربر به دامنه اختصاصی Azure شما می‌رسد.
2. مسیرهای عمومی مثل landing page بررسی می‌شوند.
3. درخواست‌های اصلی به آدرس Upstream شما، مثلاً `https://your-domain.com:443/api`، فوروارد می‌شوند.
4. پاسخ دریافتی به صورت **Stream** و بدون وقفه به کاربر برگردانده می‌شود.

**مسیر جریان ترافیک:**

```text
User Client -> Azure App Service -> TARGET_DOMAIN Inbound
```

---

## 📊 مقایسه: چرا Azure؟

برای استفاده‌های سنگین و استریم، Azure App Service معمولاً انتخاب بهتری نسبت به Functionهای کوتاه‌مدت است.

| ویژگی | Azure App Service | Vercel / Netlify |
| :--- | :--- | :--- |
| **نوع اجرا** | Node.js App دائمی | Serverless Functions / Rewrite |
| **کنترل runtime** | بالا | محدودتر |
| **مناسب برای استریم طولانی** | بهتر | وابسته به محدودیت duration |
| **پروفایل نصب** | B1 / B2 / B3 Trial-friendly | وابسته به پلن پلتفرم |
| **مناسب برای** | Relay دائمی و سنگین | پروژه‌های کوچک‌تر یا rewrite ساده |

---

## 🪟 نصب و Deploy سریع روی ویندوز

1. پروژه را دانلود یا clone کنید.
2. فایل زیر را اجرا کنید:

```text
Run-Deploy-Azure.bat
```

3. اگر Azure CLI نصب نباشد، installer نسخه رسمی Microsoft Azure CLI را نصب می‌کند.
4. اگر login نباشید، حالت ساده Device Login باز می‌شود.
5. اطلاعات inbound و path را وارد می‌کنید.
6. پروفایل deploy را انتخاب می‌کنید.
7. اسکریپت App Service را می‌سازد و ZIP deploy انجام می‌دهد.

برای کاربر عادی نیازی به Service Principal، Client Secret یا token دستی نیست.

---

## ⚙️ پارامترهای ورودی اینستالر

### 🌐 TARGET_DOMAIN

آدرس Inbound اصلی شماست و باید همراه با پروتکل و پورت وارد شود:

```text
https://your-domain.com:443
https://sub.example.site:2053
```

اگر inbound شما path دارد، آن path را داخل `RELAY_PATH` وارد کنید، نه در انتهای `TARGET_DOMAIN`.

### 🛣️ RELAY_PATH

مسیری که روی Inbound تنظیم کرده‌اید.

مثال:

```text
/api
```

در نسخه Azure، مقدار `PUBLIC_RELAY_PATH` به صورت خودکار برابر همین مقدار قرار می‌گیرد. یعنی اگر inbound path شما `/api` باشد، آدرس کلاینت نهایی هم روی Azure همین `/api` خواهد بود.

### 🔑 RELAY_KEY اختیاری

برای استفاده معمولی لازم نیست مقدار بدهید. فقط Enter بزنید تا غیرفعال بماند.

اگر امنیت اضافه می‌خواهید، یک مقدار وارد کنید. در این صورت کلاینت باید header زیر را بفرستد:

```json
{
  "headers": {
    "x-relay-key": "YourPassword"
  }
}
```

---

## ⚡ پروفایل‌های آماده Deploy

اینستالر دارای پروفایل‌های پیش‌فرض برای مدیریت بهتر منابع است، مخصوصاً برای اکانت‌های Free Trial و credit اولیه Azure.

### ⚖️ Trial Balanced پیشنهادی

تعادل بین قدرت و هزینه:

```text
SKU=B2
NODE=NODE:22-lts
MAX_INFLIGHT=256
UPSTREAM_TIMEOUT_MS=0
MAX_UP_BPS=0
MAX_DOWN_BPS=0
Always On=true
HTTP/2=true
WebSockets=true
```

### 📉 Trial Economy

برای تست سبک و کم‌هزینه:

```text
SKU=B1
MAX_INFLIGHT=128
Timeout disabled
Speed limit disabled
```

### 🚀 Trial High Throughput

بیشترین قدرت در لایه Basic:

```text
SKU=B3
MAX_INFLIGHT=512
Timeout disabled
Speed limit disabled
```

### 🛠️ Custom Build

برای تنظیم دستی:

```text
SKU: B1 / B2 / B3
Node runtime: NODE:22-lts یا NODE:20-lts
MAX_INFLIGHT
UPSTREAM_TIMEOUT_MS
MAX_UP_BPS
MAX_DOWN_BPS
```

در Custom Build مقدار `0` برای timeout و speed limit یعنی غیرفعال.

---

## 📉 تنظیمات سرعت و تایم‌اوت

برای استریم بدون قطعی از سمت خود برنامه:

```text
UPSTREAM_TIMEOUT_MS=0
```

یعنی hard timeout داخلی relay خاموش است و تا وقتی upstream دیتا بدهد، خود کد relay دانلود طولانی را قطع نمی‌کند.

برای سرعت نامحدود:

```text
MAX_UP_BPS=0
MAX_DOWN_BPS=0
```

اگر خواستید مصرف را کنترل کنید، مقدار را بر حسب bytes per second وارد کنید:

```text
5242880  = حدود 5 MiB/s
10485760 = حدود 10 MiB/s
```

---

## 🌍 انتخاب بهترین Region

بر اساس IP سرور مقصد شما، اینستالر بهترین regionهای Azure را پیشنهاد می‌دهد.

برای کاربر ایران، مسیر واقعی این است:

```text
Iran user -> Azure region -> Upstream inbound
```

پیشنهادهای معمول:

* **برای سرورهای اروپا:** `westeurope`, `uksouth`, `northeurope`, `germanywestcentral`
* **برای سرورهای خاورمیانه:** `uaenorth`, `qatarcentral`

نتیجه نهایی به routing اپراتور و upstream بستگی دارد. بعد از deploy، با کلاینت واقعی benchmark بگیرید.

---

## ⚠️ خطاهای رایج Azure

### App Service Plan Create operation is throttled

اگر پشت سر هم App Service Plan بسازید، Azure موقتاً شما را محدود می‌کند.

طبق داک رسمی Azure Resource Manager، اگر پاسخ throttling مقدار `Retry-After` بدهد، باید همان تعداد ثانیه صبر کنید. اگر Azure CLI این مقدار را نشان ندهد، زمان دقیق رسمی در خروجی وجود ندارد. چند دقیقه صبر کنید و اگر ممکن بود از App Service Plan قبلی reuse کنید.

داک رسمی:

```text
https://learn.microsoft.com/azure/azure-resource-manager/management/request-limits-and-throttling
```

### The subscription is not allowed to create or update the serverfarm

اگر از اکانت رایگان یا Trial استفاده می‌کنید، معمولاً بهتر است فقط از سری Basic استفاده کنید:

```text
B1
B2
B3
```

سری Premium در اکانت‌های رایگان یا بعضی subscriptionها ممکن است مسدود باشد.

---

## 📂 ساختار پروژه

```text
index.js                    # Azure Node relay server
package.json                # npm scripts
Deploy-Azure.ps1            # Windows installer & deploy script
Run-Deploy-Azure.bat        # Easy launcher for Windows
scripts/prepare-build.mjs   # Static frontend generator
templates/landing/          # Landing templates
public/                     # Generated static frontend, ignored by git
```

---

## 🧪 اجرای لوکال

```powershell
$env:TARGET_DOMAIN="https://your-upstream-domain.com:443"
$env:RELAY_PATH="/api"
$env:PUBLIC_RELAY_PATH="/api"
npm run build
npm start
```

سپس:

```text
http://localhost:8080/
http://localhost:8080/health
http://localhost:8080/api
```

---

## 📝 لایسنس
---
این پروژه تحت لایسنس MIT منتشر می‌شود.
