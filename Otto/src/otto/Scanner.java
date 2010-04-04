/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package otto;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Dario
 */
public class Scanner extends Thread implements Runnable {
    private int _fromPort;
    private int _toPort;
    private String _host;
    private int _timeout;
    private boolean _finish;
    private MainFrame _caller;

    public Scanner() {
        _host = new String();
        _fromPort = 1;
        _toPort = 65535;
    }

    public Scanner(String host, int fromPort, int toPort, int timeout, MainFrame caller) {
        System.out.println("Creating scanner for " + host + " port " +
                fromPort + ".." + toPort);
        _host = host;
        _fromPort = fromPort;
        _toPort = toPort;
        _caller = caller;
        _timeout = timeout;
        _finish = false;
    }

    @Override
    public void run() {
        int v;

        for (int i = _fromPort; i <= _toPort && _finish == false; i++) {
            Socket s = new Socket();
            // Try to connect to port
            try {
                s.connect(new InetSocketAddress(_host, i), _timeout);
                _caller.addPort(i);
            }
            catch (Exception e) {
                //System.out.println("Exception: " + e.getMessage());
            }

            // Close the socket
            try {
                s.close();
            } catch (IOException ex) {
                Logger.getLogger(Scanner.class.getName()).log(Level.SEVERE, null, ex);
            }

            v = (i - _fromPort) * 100 / (_toPort - _fromPort);
            _caller.setBar(v);
            _caller.validate();
        }

        if (_finish == true)
            System.out.println("Scanner stop requested.");
    }

    public void finish() {
        _finish = true;
    }
}
