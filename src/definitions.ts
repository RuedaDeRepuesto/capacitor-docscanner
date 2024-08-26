export interface DocScannerPlugin {
  /**
   * Initiates the document scanning process.
   * This method opens the document scanner and allows the user to scan documents.

   * 
   * @param opts Optional configuration options for the scanning process.
   * @returns A Promise that resolves to a `DocScanResult` containing the scanned images.
   * @throws An exception if the scanning process fails. The exception will contain
   * a message describing why the scan could not be completed.
   */
  scan(opts?: DocScanOpts): Promise<DocScanResult>;
}

/**
 * Configuration options for the document scanning process.
 */
export interface DocScanOpts {
  /**
   * The maximum number of documents that can be scanned.
   * If not provided, the scanner will scan only one
   * Note: This option is only supported on Android, in ios is ignored.
   */
  maxScans?: number;
}

/**
 * The result of a document scanning operation.
 */
export interface DocScanResult {
  /**
   * An array of scanned images, each represented as a Base64-encoded JPEG string.
   */
  images: string[];
}