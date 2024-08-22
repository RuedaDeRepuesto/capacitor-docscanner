package cl.kgames.capacitordocscanner;

import android.app.Activity;
import android.content.IntentSender;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.util.Base64;
import android.util.Log;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.IntentSenderRequest;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;

import com.getcapacitor.Bridge;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.PluginCall;
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions;
import com.google.mlkit.vision.documentscanner.GmsDocumentScanning;
import com.google.mlkit.vision.documentscanner.GmsDocumentScanningResult;

import org.json.JSONArray;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class DocScanner  {

    private final ActivityResultLauncher<IntentSenderRequest> scannerLauncher;
    private PluginCall currentCall;
    private Bridge bridge;

    public DocScanner(Bridge capacitorBridge){
        bridge = capacitorBridge;
        scannerLauncher = capacitorBridge.getActivity().registerForActivityResult(new ActivityResultContracts.StartIntentSenderForResult(), this::handleActivityResult);
    }

    public void startScan(PluginCall call, Integer maxPages){
        currentCall = call;

        GmsDocumentScannerOptions.Builder options =
                new GmsDocumentScannerOptions.Builder()
                        .setResultFormats(
                                GmsDocumentScannerOptions.RESULT_FORMAT_JPEG)
                        .setGalleryImportAllowed(false);
        options.setScannerMode(GmsDocumentScannerOptions.SCANNER_MODE_BASE);
        options.setPageLimit(maxPages);

        GmsDocumentScanning.getClient(options.build())
                .getStartScanIntent(bridge.getActivity())
                .addOnSuccessListener(
                        intentSender ->
                                scannerLauncher.launch(new IntentSenderRequest.Builder(intentSender).build())
                )
                .addOnFailureListener(
                        e -> error(e.getLocalizedMessage()));
    }

    private void error(String msg){
        currentCall.reject(msg);
    }

    private void handleActivityResult(ActivityResult activityResult) {
        int resultCode = activityResult.getResultCode();
        GmsDocumentScanningResult result =
                GmsDocumentScanningResult.fromActivityResultIntent(activityResult.getData());
        if (resultCode == Activity.RESULT_OK && result != null) {

            List<GmsDocumentScanningResult.Page> pages = result.getPages();


            JSObject capResult = new JSObject();
            JSArray arrayImages = new JSArray();
            for(GmsDocumentScanningResult.Page i: pages){
                String base64 = convertUriToBase64(i.getImageUri());
                if(base64 != null){
                    arrayImages.put(base64);
                    System.out.println(base64);
                }
            }
            capResult.put("images",arrayImages);
            currentCall.resolve(capResult);

        } else if (resultCode == Activity.RESULT_CANCELED) {
            currentCall.reject("User canceled scan");
        } else {
            currentCall.reject("An error has occurred");
        }
    }


    public String convertUriToBase64(Uri imageUri) {
        try {
            InputStream inputStream = bridge.getContext().getContentResolver().openInputStream(imageUri);

            Bitmap bitmap = BitmapFactory.decodeStream(inputStream);

            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
            byte[] byteArray = byteArrayOutputStream.toByteArray();

            String base64String = Base64.encodeToString(byteArray, Base64.DEFAULT);

            inputStream.close();

            return base64String;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}
