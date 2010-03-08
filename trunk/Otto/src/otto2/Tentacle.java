/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package otto2;
import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author 00918055
 */
public class Tentacle extends Thread implements Runnable {
    private String _host;
    private int _port;
    private boolean _open;

    Tentacle(String host, int port) {
        _host = host;
        _port = port;
    }

    public boolean isOpen() {
        return _open;
    }

    @Override
    public void run() {
        //System.out.println("Tentacle " + _host + "/" + _port);
        try {
            Socket s = new Socket(_host, _port);
            _open = true;
            s.close();
        } catch (IOException ex) {
            //Logger.getLogger(Tentacle.class.getName()).log(Level.SEVERE, null, ex);
            _open = false;
        }
    }
}
