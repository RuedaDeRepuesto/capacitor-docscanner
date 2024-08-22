# capacitor-docscanner


The `capacitor-docscanner` allows you to scan documents using the camera on your device. The plugin automatically crops the scanned documents and provides them as Base64-encoded JPEG images.

This plugin leverages Google's ML Kit on Android and Vision API on iOS to perform document scanning and cropping.

## Versioning

See the table below for details.

| Version | Description                    | Capacitor Version |
|---------|--------------------------------|-------------------|
| 0.0.1   | Initial release.               |         6         |


## Install

```bash
npm install capacitor-docscanner
npx cap sync
```

## API

<docgen-index>

* [`scan(...)`](#scan)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### scan(...)

```typescript
scan(opts?: DocScanOpts | undefined) => Promise<DocScanResult>
```

Initiates the document scanning process.
This method opens the document scanner and allows the user to scan documents.

| Param      | Type                                                | Description                                              |
| ---------- | --------------------------------------------------- | -------------------------------------------------------- |
| **`opts`** | <code><a href="#docscanopts">DocScanOpts</a></code> | Optional configuration options for the scanning process. |

**Returns:** <code>Promise&lt;<a href="#docscanresult">DocScanResult</a>&gt;</code>

--------------------


### Interfaces


#### DocScanResult

The result of a document scanning operation.

| Prop         | Type                  | Description                                                                   |
| ------------ | --------------------- | ----------------------------------------------------------------------------- |
| **`images`** | <code>string[]</code> | An array of scanned images, each represented as a Base64-encoded JPEG string. |


#### DocScanOpts

Configuration options for the document scanning process.

| Prop           | Type                | Description                                                                                                                                                                          |
| -------------- | ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **`maxScans`** | <code>number</code> | The maximum number of documents that can be scanned. If not provided, the scanner will allow scanning a default number of documents. Note: This option is only supported on Android. |

</docgen-api>
