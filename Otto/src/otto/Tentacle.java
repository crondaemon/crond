/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package otto;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;

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
            Socket s = new Socket();
            s.connect(new InetSocketAddress(_host, _port), 10);
            //s.connect(_host, _port);
            _open = true;
            s.close();
        } catch (IOException ex) {
            //Logger.getLogger(Tentacle.class.getName()).log(Level.SEVERE, null, ex);
            _open = false;
        }
    }
}
