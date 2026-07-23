# coc-analytics

App Flutter para consultar perfiles, clanes, estadísticas y comparativas de jugadores de Clash of Clans usando la API oficial de Supercell.

## Setup

1. Copia `.env.example` si quieres un override local; por defecto debug usa `.env.development`.
2. Arranca el proxy en `api/` (ahí vive `COC_KEY`, no en la app).
3. Instala dependencias: `flutter pub get`
4. Genera localizaciones: `flutter gen-l10n`
5. Debug: `flutter run` → `.env.development`  
   Release / Play: `.env.production` (Cloud Run, sin `COC_KEY`).

Probar la API de producción en debug:

```bash
flutter run --dart-define=ENV_FILE=.env.production
```

## Nota

Esta app no está afiliada, respaldada ni patrocinada por Supercell.
