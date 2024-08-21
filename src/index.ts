import { registerPlugin } from '@capacitor/core';

import type { DocScannerPlugin } from './definitions';

const DocScanner = registerPlugin<DocScannerPlugin>('DocScanner', {
  web: () => import('./web').then(m => new m.DocScannerWeb()),
});

export * from './definitions';
export { DocScanner };
