# Locale Setup - I18n Expert Reference

Configuration guide for different frameworks.

## next-intl (Next.js App Router)

```bash
npm install next-intl
```

```typescript
// i18n/request.ts
import { getRequestConfig } from 'next-intl/server';

export default getRequestConfig(async () => {
  const locale = 'en'; // from middleware
  return {
    locale,
    messages: (await import(`../messages/${locale}.json`)).default,
  };
});
```

```typescript
// middleware.ts
import createMiddleware from 'next-intl/middleware';

export default createMiddleware({
  locales: ['en', 'es'],
  defaultLocale: 'en',
});

export const config = {
  matcher: ['/((?!api|_next|_vercel|.*\\..*).*)'],
};
```

## react-i18next (React / Vite)

```bash
npm install react-i18next i18next
```

```typescript
// i18n.ts
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import en from './locales/en.json';
import es from './locales/es.json';

i18n.use(initReactI18next).init({
  resources: { en: { translation: en }, es: { translation: es } },
  lng: 'en',
  fallbackLng: 'en',
  interpolation: { escapeValue: false },
});
```

## Locale File Structure

```
public/locales/
├── en-US/
│   ├── common.json
│   ├── errors.json
│   ├── pricing.json
│   └── workspace.json
└── es-AR/
    ├── common.json
    ├── errors.json
    ├── pricing.json
    └── workspace.json
```

## Key Naming Convention

```
namespace.section.action
├── common.buttons.save
├── common.buttons.cancel
├── errors.auth.invalidCredentials
├── pricing.tier.pro
└── workspace.settings.title
```

## Related

- [SKILL.md](../SKILL.md) - Main workflow
- [Audit Script](../scripts/i18n_audit.py) - Audit script
