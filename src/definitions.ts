export interface DocScannerPlugin {

  scan(): Promise<DocScanResult>;
}

export interface DocScanResult{
  images:string[]
}
