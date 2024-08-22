package cl.kgames.capacitordocscanner;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "DocScanner")
public class DocScannerPlugin extends Plugin {

    private DocScanner implementation;

    @PluginMethod
    public void scan(PluginCall call) {
        Integer max = call.getInt("maxScans",1);
        implementation.startScan(call,max);
    }


    @Override
    public void load() {
        System.out.println("Cargando plugin docscanner");
        implementation = new DocScanner(getBridge());
    }
}
