import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.foodhero.app',
  appName: 'Food Hero',
  webDir: 'dist',
  ios: {
    contentInset: 'automatic',
    allowsLinkPreview: false,
    scrollEnabled: true,
  },
  server: {
    // Web assets are bundled. API calls go to the production backend via VITE_API_URL
    // which is baked in at build time (see npm run build:ios).
    // To load a hosted URL instead of bundled assets, uncomment:
    // url: 'https://foodwaste-production-746a.up.railway.app',
    androidScheme: 'https',
    iosScheme: 'capacitor',
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      launchAutoHide: true,
      backgroundColor: '#f97316',
      showSpinner: false,
      splashFullScreen: true,
      splashImmersive: true,
    },
    StatusBar: {
      style: 'LIGHT',
      backgroundColor: '#f97316',
    },
  },
};

export default config;
