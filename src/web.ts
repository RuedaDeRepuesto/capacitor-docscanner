import { WebPlugin } from '@capacitor/core';

import type { DocScannerPlugin, DocScanResult } from './definitions';

export class DocScannerWeb extends WebPlugin implements DocScannerPlugin {
  async scan(): Promise<DocScanResult> {
    throw new Error('Method not implemented in web.');
  }
}
